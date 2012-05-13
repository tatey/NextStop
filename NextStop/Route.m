#import "Route.h"
#import "SQLiteDB.h"
#import "Trip.h"

#define QUERY @"SELECT routes.* "                                              \
               "FROM routes "                                                  \
               "WHERE (routes.short_name LIKE ? OR routes.long_name LIKE ?); " \

static inline const char * RouteStringToWildcardUTF8String(NSString *string) {
    return [[NSString stringWithFormat:@"%%%@%%", string] UTF8String];
}

@interface Route () {
@private
    __strong NSString *_longName;
    NSUInteger _primaryKey;
    __strong NSString *_shortName;
}

- (id)initWithStatement:(sqlite3_stmt *)stmt;
    
@end

@implementation Route

+ (NSArray *)routesMatchingShortNameOrLongName:(NSString *)searchText {
    SQLiteDB *db = [SQLiteDB sharedDB];
    sqlite3_stmt *stmt = [db prepareStatementWithQuery:QUERY];
    sqlite3_bind_text(stmt, 1, RouteStringToWildcardUTF8String(searchText), -1, SQLITE_STATIC);
    sqlite3_bind_text(stmt, 2, RouteStringToWildcardUTF8String(searchText), -1, SQLITE_STATIC);
    NSMutableArray *routes = [NSMutableArray array];
    [db performAndFinalizeStatement:stmt blockForEachRow:^(sqlite3_stmt *stmt) {
        Route *route = [[self alloc] initWithStatement:stmt];
        [routes addObject:route];
    }];
    return [routes copy];
}

- (id)initWithStatement:(sqlite3_stmt *)stmt {
    self = [self init];
    if (self) {
        _longName = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 2)] copy];
        _primaryKey = sqlite3_column_int(stmt, 0);
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

- (NSUInteger)primaryKey {
    return _primaryKey;
}

- (NSArray *)trips {
    return [Trip tripsBelongingToRoute:self];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, longName: %@ primaryKey: %d, shortName: %@>", NSStringFromClass([self class]), self, self.longName, self.primaryKey, self.shortName];
}

@end
