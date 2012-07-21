#import "DirectionRecord.h"
#import "RouteRecord.h"
#import "StopRecord.h"
#import "SQLiteDB.h"

#define QUERY1 @"SELECT trips.* "          \
                "FROM trips "              \
                "WHERE trips.route_id = ?" \
                "GROUP BY direction; "     \

#define QUERY2 @"SELECT trips.* "      \
                "FROM trips "          \
                "WHERE trips.id = ?; " \

@interface DirectionRecord () {
@private
    __strong NSString *_headsign;
    NSInteger _primaryKey;
    __strong NSArray *_stops;
}

- (id)initWithStatement:(sqlite3_stmt *)stmt;

@end

@implementation DirectionRecord

@synthesize direction = _direction;
@synthesize primaryKey = _primaryKey;
@synthesize headsign = _headsign;

+ (NSArray *)directionsBelongingToRoute:(RouteRecord *)route {
    SQLiteDB *db = [SQLiteDB sharedDB];
    sqlite3_stmt *stmt = [db prepareStatementWithQuery:QUERY1];
    sqlite3_bind_int(stmt, 1, route.primaryKey);
    NSMutableArray *directions = [NSMutableArray array];
    [db performAndFinalizeStatement:stmt blockForEachRow:^(sqlite3_stmt *stmt) {
        DirectionRecord *direction = [[self alloc] initWithStatement:stmt];
        [directions addObject:direction];
    }];
    return [directions copy];
}

+ (id)directionMatchingPrimaryKey:(NSInteger)primaryKey {
    SQLiteDB *db = [SQLiteDB sharedDB];
    sqlite3_stmt *stmt = [db prepareStatementWithQuery:QUERY2];
    sqlite3_bind_int(stmt, 1, primaryKey);
    __block RouteRecord *route = nil;
    [db performAndFinalizeStatement:stmt blockForEachRow:^(sqlite3_stmt *stmt) {
        route = [[self alloc] initWithStatement:stmt];
    }];
    return route;
}

- (id)initWithStatement:(sqlite3_stmt *)stmt {
    self = [self init];
    if (self) {
        _direction = sqlite3_column_int(stmt, 1);
        _headsign = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 2)] copy];
        _primaryKey = sqlite3_column_int(stmt, 0);
    }
    return self;
}

- (NSArray *)stops {
    if (!_stops) {
        _stops = [StopRecord stopsBelongingToDirection:self];
    }
    return _stops;
}

- (NSString *)localizedHeadsign {
    NSString *key = [NSString stringWithFormat:@"direction_record.direction.%@", self.headsign];
    return NSLocalizedString(key, nil);
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, primaryKey: %d, direction %d, headsign: %@>", NSStringFromClass([self class]), self, self.primaryKey, _direction, _headsign];
}

@end
