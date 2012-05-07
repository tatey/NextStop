#import "Route.h"
#import "SQLiteDB.h"

#define QUERY @"SELECT * "                                      \
               "FROM routes "                                   \
               "WHERE (short_name LIKE ? OR long_name LIKE ?) " \

static inline const char * RouteStringToWildcardUTF8String(NSString *string) {
    return [[NSString stringWithFormat:@"%%%@%%", string] UTF8String];
}

@interface Route () {
@private
    NSString *_longName;
    NSString *_shortName;
    NSUInteger _primaryKey;
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
        _primaryKey = sqlite3_column_int(stmt, 0);
        _shortName = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 1)] copy];
        _longName = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 2)] copy];
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

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, shortName: %@, longName: %@ primaryKey: %d>", NSStringFromClass([self class]), self, self.shortName, self.longName, self.primaryKey];
}

@end
