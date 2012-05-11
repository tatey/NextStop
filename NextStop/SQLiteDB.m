#import "SQLiteDB.h"

@implementation SQLiteDB

+ (SQLiteDB *)sharedDB {
    static dispatch_once_t predicate;
	static SQLiteDB *sharedDB = nil;
	dispatch_once(&predicate, ^{ 
        sharedDB = [[self alloc] initWithPath:[self defaultPath]]; 
    });
	return sharedDB;
}

+ (NSString *)defaultPath {
    return [[NSBundle mainBundle] pathForResource:@"NextStop" ofType:@"sqlite"];
}

- (id)initWithPath:(NSString *)path {
    self = [self init];
    if (self) {
        sqlite3_open_v2([path UTF8String], &_db, SQLITE_OPEN_READONLY, NULL);
    }
    return self;
}

- (void)dealloc {
    sqlite3_close(_db);
}

- (sqlite3_stmt *)prepareStatementWithQuery:(NSString *)query {
    sqlite3_stmt *stmt;
    sqlite3_prepare_v2(_db, [query UTF8String], -1, &stmt, NULL);
    return stmt;
}

- (void)performAndFinalizeStatement:(sqlite3_stmt *)stmt blockForEachRow:(void (^)(sqlite3_stmt *stmt))row {
    while (sqlite3_step(stmt) == SQLITE_ROW) {
        row(stmt);
    }
    sqlite3_finalize(stmt);    
}

@end
