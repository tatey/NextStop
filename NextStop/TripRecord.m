#import "RouteRecord.h"
#import "StopRecord.h"
#import "SQLiteDB.h"
#import "TripRecord.h"

#define QUERY @"SELECT trips.* "          \
               "FROM trips "              \
               "WHERE trips.route_id = ?" \
               "GROUP BY direction;"      \

static NSString *const kInbound = @"inbound";
static NSString *const kOutbound = @"outbound";
static NSString *const kCounterClockwise = @"counterclockwise";
static NSString *const kClockwise = @"clockwise";
static NSString *const kInward = @"inward";
static NSString *const kOutward = @"outward";
static NSString *const kSouth = @"south";
static NSString *const kNorth = @"north";
static NSString *const kEast = @"east";
static NSString *const kWest = @"west";

@interface TripRecord () {
@private
    __strong NSString *_direction;
    NSUInteger _primaryKey;
}

- (id)initWithStatement:(sqlite3_stmt *)stmt;

@end

@implementation TripRecord

+ (NSArray *)tripsBelongingToRoute:(RouteRecord *)route {
    SQLiteDB *db = [SQLiteDB sharedDB];
    sqlite3_stmt *stmt = [db prepareStatementWithQuery:QUERY];
    sqlite3_bind_int(stmt, 1, route.primaryKey);
    NSMutableArray *trips = [NSMutableArray array];
    [db performAndFinalizeStatement:stmt blockForEachRow:^(sqlite3_stmt *stmt) {
        TripRecord *trip = [[TripRecord alloc] initWithStatement:stmt];
        [trips addObject:trip];
    }];
    return [trips copy];
}

- (id)initWithStatement:(sqlite3_stmt *)stmt {
    self = [self init];
    if (self) {
        _direction = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 1)] copy];
        _primaryKey = sqlite3_column_int(stmt, 0);
    }
    return self;
}

- (TripRecordDirection)direction {
    if ([_direction isEqualToString:kInbound]) return TripRecordInboundDirection;
    if ([_direction isEqualToString:kOutbound]) return TripRecordOutboundDirection;
    if ([_direction isEqualToString:kInward]) return TripRecordInwardDirection;
    if ([_direction isEqualToString:kOutward]) return TripRecordOutwardDirection;
    if ([_direction isEqualToString:kCounterClockwise]) return TripRecordCounterClockwiseDirection;
    if ([_direction isEqualToString:kClockwise]) return TripRecordClockwiseDirection;
    if ([_direction isEqualToString:kSouth]) return TripRecordSouthDirection;
    if ([_direction isEqualToString:kNorth]) return TripRecordNorthDirection;
    if ([_direction isEqualToString:kEast]) return TripRecordEastDirection;
    if ([_direction isEqualToString:kWest]) return TripRecordWestDirection;
    return TripRecordUnknownDirection;
}

- (NSUInteger)primaryKey {
    return _primaryKey;
}

- (NSArray *)stops {
    return [StopRecord stopsBelongingToTrip:self];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, direction: %d, primaryKey: %d>", NSStringFromClass([self class]), self, self.direction, self.primaryKey];
}

@end
