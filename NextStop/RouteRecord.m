#import "NSArray+Random.h"
#import "RouteRecord.h"
#import "SQLiteDB.h"

#define QUERY1 @"SELECT routes.* "           \
                "FROM routes "               \
                "WHERE routes.route_id = ? " \
                "LIMIT 1; "                  \

#define QUERY2 @"SELECT routes.* " \
                "FROM routes "     \
                "LIMIT 100; "      \

#define QUERY3 @"SELECT routes.* "                                             \
                "FROM routes "                                                 \
                "WHERE (routes.short_name LIKE ? OR routes.long_name LIKE ?) " \
                "LIMIT 50; "                                                   \

static const char * RouteRecordStringToWildcardUTF8String(NSString *string) {
    return [[NSString stringWithFormat:@"%%%@%%", string] UTF8String];
}

@interface RouteRecord () {
@private
    __strong NSString *_longName;
    __strong NSString *_routeId;
    __strong NSString *_shortName;
}

- (id)initWithStatement:(sqlite3_stmt *)stmt;
    
@end

@implementation RouteRecord

+ (RouteRecord *)routeMatchingRouteId:(NSString *)routeId {
    SQLiteDB *db = [SQLiteDB sharedDB];
    sqlite3_stmt *stmt = [db prepareStatementWithQuery:QUERY1];
    sqlite3_bind_text(stmt, 1, [routeId UTF8String], -1, SQLITE_STATIC);
    __block RouteRecord *route = nil;
    [db performAndFinalizeStatement:stmt blockForEachRow:^(sqlite3_stmt *stmt) {
        route = [[self alloc] initWithStatement:stmt];
    }];
    return route;
}

+ (NSArray *)routes {
    SQLiteDB *db = [SQLiteDB sharedDB];
    sqlite3_stmt *stmt = [db prepareStatementWithQuery:QUERY2];
    NSMutableArray *routes = [NSMutableArray array];
    [db performAndFinalizeStatement:stmt blockForEachRow:^(sqlite3_stmt *stmt) {
        RouteRecord *route = [[self alloc] initWithStatement:stmt];
        [routes addObject:route];
    }];
    return [routes copy];
}

+ (NSArray *)routesMatchingShortNameOrLongName:(NSString *)searchText {
    SQLiteDB *db = [SQLiteDB sharedDB];
    sqlite3_stmt *stmt = [db prepareStatementWithQuery:QUERY3];
    sqlite3_bind_text(stmt, 1, RouteRecordStringToWildcardUTF8String(searchText), -1, SQLITE_STATIC);
    sqlite3_bind_text(stmt, 2, RouteRecordStringToWildcardUTF8String(searchText), -1, SQLITE_STATIC);
    NSMutableArray *routes = [NSMutableArray array];
    [db performAndFinalizeStatement:stmt blockForEachRow:^(sqlite3_stmt *stmt) {
        RouteRecord *route = [[self alloc] initWithStatement:stmt];
        [routes addObject:route];
    }];
    return [routes copy];
}

- (id)initWithStatement:(sqlite3_stmt *)stmt {
    self = [self init];
    if (self) {
        _longName = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 2)] copy];
        _routeId = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 0)] copy];
        _shortName = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 1)] copy];
    }
    return self;
}

- (NSString *)longName {
    return _longName;
}

- (NSString *)shortName {
    return _shortName;
}

- (NSString *)routeId {
    return _routeId;
}

- (NSString *)mediumName {
    return [[self.longName componentsSeparatedByString:@", "] objectAtRandomIndex];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, longName: %@ routeId: %@, shortName: %@>", NSStringFromClass([self class]), self, _longName, _routeId, _shortName];
}

@end
