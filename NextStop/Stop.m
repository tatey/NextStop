#import "Route.h"
#import "Stop.h"
#import "SQLiteDB.h"

#define QUERY @"SELECT DISTINCT stops.* FROM stops "                 \
               "INNER JOIN services ON services.stop_id = stops.id " \
               "INNER JOIN routes ON services.route_id = routes.id " \
               "WHERE stops.latitude IS NOT NULL AND "               \
               "      stops.longitude IS NOT NULL AND "              \
               "      routes.id = ? "                                \

@implementation Stop

+ (NSArray *)stopsMatchingRoute:(Route *)route {
    SQLiteDB *db = [SQLiteDB sharedDB];
    sqlite3_stmt *stmt = [db prepareStatementWithQuery:QUERY];    
    sqlite3_bind_int(stmt, 1, route.primaryKey);
    NSMutableArray *stops = [NSMutableArray array];
    [db performAndFinalizeStatement:stmt blockForEachRow:^(sqlite3_stmt *stmt) {
        Stop *stop = [[self alloc] initWithStatement:stmt];
        [stops addObject:stop];
    }];
    return [stops copy];
}

- (id)initWithStatement:(sqlite3_stmt *)stmt {
    self = [self init];
    if (self) {
        _primaryKey = sqlite3_column_int(stmt, 0);
        _latitude = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 3)] doubleValue];
        _longitude = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 4)] doubleValue];
        _name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 1)];
    }
    return self;
}

- (NSString *)name {
    return _name;
}

- (NSUInteger)primaryKey {
    return _primaryKey;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, latitude: %f, longitude: %f, name: %@ primaryKey: %d>", NSStringFromClass([self class]), self, _latitude, _longitude, self.name, self.primaryKey];
}

#pragma mark - MKAnnotation

- (NSString *)title {
    return self.name;
}

- (CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake(_latitude, _longitude);
}

@end
