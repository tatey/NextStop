#import "Route.h"
#import "SQLiteDB.h"

#define QUERY @"SELECT routes.* "                    \
               "FROM routes "                        \
               "WHERE (code LIKE ? OR name LIKE ?) " \
               "      AND direction = ? "            \

static inline const char * RouteDirectionToUTF8String(RouteDirection direction) {
    switch (direction) {
        case RouteInboundDirection:
            return [@"inbound" UTF8String];
        case RouteOutboundDirection:
            return [@"outbound" UTF8String];
    }
}

@implementation Route

+ (NSArray *)routesMatchingCodeOrName:(NSString *)codeOrName direction:(RouteDirection)direction {
    SQLiteDB *db = [SQLiteDB sharedDB];
    sqlite3_stmt *stmt = [db prepareStatementWithQuery:QUERY];
    const char *wildcard = [[NSString stringWithFormat:@"%%%@%%", codeOrName] UTF8String];
    sqlite3_bind_text(stmt, 1, wildcard, -1, SQLITE_STATIC);
    sqlite3_bind_text(stmt, 2, wildcard, -1, SQLITE_STATIC);
    sqlite3_bind_text(stmt, 3, RouteDirectionToUTF8String(direction), -1, SQLITE_STATIC);
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
        _code = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 1)];
        _name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 2)];
    }
    return self;
}

- (NSString *)code {
    return _code;
}

- (NSString *)name {
    return _name;
}

- (NSUInteger)primaryKey {
    return _primaryKey;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, code: %@, name: %@ primaryKey: %d>", NSStringFromClass([self class]), self, self.code, self.name, self.primaryKey];
}

@end
