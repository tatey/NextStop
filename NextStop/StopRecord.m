#import <CoreLocation/CoreLocation.h>
#import "DirectionRecord.h"
#import "StopRecord.h"
#import "SQLiteDB.h"

#define QUERY1 @"SELECT stops.* "                                                                                                                 \
                "FROM stops "                                                                                                                     \
                "INNER JOIN directions_stops ON directions_stops.stop_id = stops.stop_id "                                                        \
                "INNER JOIN directions ON directions_stops.direction = directions.direction AND directions_stops.route_id = directions.route_id " \
                "WHERE directions.direction = ? AND directions.route_id = ?; "                                                                    \

#define QUERY2 @"SELECT stops.* "          \
                "FROM stops "              \
                "WHERE stops.stop_id = ? " \
                "LIMIT 1; "                \

@interface StopRecord () {
@private 
    CLLocationDegrees _latitude;
    CLLocationDegrees _longitude;
    __strong NSString *_name;
    __strong NSString *_stopId;
}

- (id)initWithStatement:(sqlite3_stmt *)stmt;

@end

@implementation StopRecord

+ (NSArray *)stopsBelongingToDirection:(DirectionRecord *)direction {
    SQLiteDB *db = [SQLiteDB sharedDB];
    sqlite3_stmt *stmt = [db prepareStatementWithQuery:QUERY1];
    sqlite3_bind_int(stmt, 1, direction.direction);
    sqlite3_bind_text(stmt, 2, [direction.routeId UTF8String], -1, SQLITE_STATIC);
    NSMutableArray *stops = [NSMutableArray array];
    [db performAndFinalizeStatement:stmt blockForEachRow:^(sqlite3_stmt *stmt) {
        StopRecord *stop = [[self alloc] initWithStatement:stmt];
        [stops addObject:stop];
    }];
    return [stops copy];
}

+ (id)stopMatchingStopId:(NSString *)stopId {
    SQLiteDB *db = [SQLiteDB sharedDB];
    sqlite3_stmt *stmt = [db prepareStatementWithQuery:QUERY2];
    sqlite3_bind_text(stmt, 1, [stopId UTF8String], -1, SQLITE_STATIC);
    __block StopRecord *stop = nil;
    [db performAndFinalizeStatement:stmt blockForEachRow:^(sqlite3_stmt *stmt) {
        stop = [[self alloc] initWithStatement:stmt];
    }];
    return stop;
}

- (id)initWithStatement:(sqlite3_stmt *)stmt {
    self = [self init];
    if (self) {
        _latitude = sqlite3_column_double(stmt, 2);
        _longitude = sqlite3_column_double(stmt, 3);
        _name = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 1)] copy];
        _stopId = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 0)] copy];
    }
    return self;
}

- (NSString *)name {
    return _name;
}

- (NSString *)stopId {
    return _stopId;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, latitude: %f, longitude: %f, name: %@, stopId: %@>", NSStringFromClass([self class]), self, _latitude, _longitude, _name, _stopId];
}

- (BOOL)isEqualToStop:(StopRecord *)stop {
    return [self.stopId isEqualToString:stop.stopId];
}

#pragma mark - MKAnnotation

- (NSString *)title {
    return self.name;
}

- (CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake(_latitude, _longitude);
}

@end
