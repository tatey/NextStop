#import "Route.h"
#import "SQLiteDB.h"

#define QUERY @"SELECT * FROM routes WHERE code LIKE ? OR name LIKE ?"

@implementation Route

+ (NSArray *)routesMatchingCodeOrName:(NSString *)codeOrName {
    SQLiteDB *db = [SQLiteDB sharedDB];
    sqlite3_stmt *stmt = [db prepareStatementWithQuery:QUERY];
    const char *wildcard = [[NSString stringWithFormat:@"%%%@%%", codeOrName] UTF8String];
    sqlite3_bind_text(stmt, 1, wildcard, -1, SQLITE_STATIC);
    sqlite3_bind_text(stmt, 2, wildcard, -1, SQLITE_STATIC);
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
