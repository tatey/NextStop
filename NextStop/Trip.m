#import "Route.h"
#import "Stop.h"
#import "SQLiteDB.h"
#import "Trip.h"

#define QUERY @"SELECT trips.* "          \
               "FROM trips "              \
               "WHERE trips.route_id = ?" \
               "GROUP BY direction;"      \

static NSString *const kInbound = @"inbound";
static NSString *const kOutbound = @"outbound";

@interface Trip () {
@private
    __strong NSString *_heading;
    NSUInteger _primaryKey;
}

- (id)initWithStatement:(sqlite3_stmt *)stmt;

@end

@implementation Trip

+ (NSArray *)tripsBelongingToRoute:(Route *)route {
    SQLiteDB *db = [SQLiteDB sharedDB];
    sqlite3_stmt *stmt = [db prepareStatementWithQuery:QUERY];
    sqlite3_bind_int(stmt, 1, route.primaryKey);
    NSMutableArray *trips = [NSMutableArray array];
    [db performAndFinalizeStatement:stmt blockForEachRow:^(sqlite3_stmt *stmt) {
        Trip *trip = [[Trip alloc] initWithStatement:stmt];
        [trips addObject:trip];
    }];
    return [trips copy];
}

- (id)initWithStatement:(sqlite3_stmt *)stmt {
    self = [self init];
    if (self) {
        _heading = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 1)] copy];
        _primaryKey = sqlite3_column_int(stmt, 0);
    }
    return self;
}

- (TripHeading)heading {
    if ([_heading isEqualToString:kInbound]) return TripInboundHeading;
    if ([_heading isEqualToString:kOutbound]) return TripOutboundHeading;
    return TripUnknownHeading;
}

- (NSUInteger)primaryKey {
    return _primaryKey;
}

- (NSArray *)stops {
    return [Stop stopsBelongingToTrip:self];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, heading: %d, primaryKey: %d>", NSStringFromClass([self class]), self, self.heading, self.primaryKey];
}

@end
