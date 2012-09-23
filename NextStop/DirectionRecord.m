#import <CoreLocation/CoreLocation.h>
#import "DirectionRecord.h"
#import "Haversin.h"
#import "RouteRecord.h"
#import "StopRecord.h"
#import "SQLiteDB.h"

#define QUERY1 @"SELECT directions.* "            \
                "FROM directions "                \
                "WHERE directions.route_id = ?; " \

#define QUERY2 @"SELECT directions.* "                                        \
                "FROM directions "                                            \
                "WHERE directions.direction = ? AND directions.route_id = ? " \
                "LIMIT 1; "                                                   \

@interface DirectionRecord () {
@private
    __strong NSString *_headsign;
    __strong NSString *_routeId;
    __strong NSArray *_stops;
}

- (id)initWithStatement:(sqlite3_stmt *)stmt;

@end

@implementation DirectionRecord

@synthesize direction = _direction;
@synthesize routeId = _routeId;
@synthesize headsign = _headsign;

+ (NSArray *)directionsBelongingToRoute:(RouteRecord *)route {
    SQLiteDB *db = [SQLiteDB sharedDB];
    sqlite3_stmt *stmt = [db prepareStatementWithQuery:QUERY1];
    sqlite3_bind_text(stmt, 1, [route.routeId UTF8String], -1, SQLITE_STATIC);
    NSMutableArray *directions = [NSMutableArray array];
    [db performAndFinalizeStatement:stmt blockForEachRow:^(sqlite3_stmt *stmt) {
        DirectionRecord *direction = [[self alloc] initWithStatement:stmt];
        [directions addObject:direction];
    }];
    return [directions copy];
}

+ (id)directionMatchingDirection:(DirectionRecordDirection)direction routeId:(NSString *)routeId {
    SQLiteDB *db = [SQLiteDB sharedDB];
    sqlite3_stmt *stmt = [db prepareStatementWithQuery:QUERY2];
    sqlite3_bind_int(stmt, 1, direction);
    sqlite3_bind_text(stmt, 2, [routeId UTF8String], -1, SQLITE_STATIC);
    __block RouteRecord *route = nil;
    [db performAndFinalizeStatement:stmt blockForEachRow:^(sqlite3_stmt *stmt) {
        route = [[self alloc] initWithStatement:stmt];
    }];
    return route;
}

- (id)initWithStatement:(sqlite3_stmt *)stmt {
    self = [self init];
    if (self) {
        _direction = sqlite3_column_int(stmt, 0);
        _headsign = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 1)] copy];
        _routeId = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 2)] copy];
    }
    return self;
}

- (NSArray *)stops {
    if (!_stops) {
        _stops = [StopRecord stopsBelongingToDirection:self];
    }
    return _stops;
}

- (StopRecord *)stopClosestByLineOfSightToCoordinate:(CLLocationCoordinate2D)coordinate {
    StopRecord *closestStop = nil;
    CLLocationDistance minimumDistance = DIRECTION_RECORD_MAX_STOP_DISTANCE_METERS;
    for (StopRecord *stop in [self stops]) {
        CLLocationDistance distance = Haversin(stop.coordinate, coordinate);
        if (distance < minimumDistance) {
            closestStop = stop;
            minimumDistance = distance;
        }
    }
    return closestStop;
}

- (NSString *)localizedHeadsign {
    NSString *key = [NSString stringWithFormat:@"direction_record.direction.%@", self.headsign];
    return NSLocalizedString(key, nil);
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, direction %d, headsign: %@, routeId: %@>", NSStringFromClass([self class]), self, _direction, _headsign, _routeId];
}

@end
