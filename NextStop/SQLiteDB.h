#import <Foundation/Foundation.h>
#import <sqlite3.h>

static const char *SQLiteDBWildcardUTF8String(NSString *string) {
    return [[NSString stringWithFormat:@"%%%@%%", string] UTF8String];
}

@interface SQLiteDB : NSObject {
@private
    sqlite3 *_db;
}

+ (SQLiteDB *)sharedDB;

+ (NSString *)defaultPath;

- (id)initWithPath:(NSString *)path;

- (sqlite3_stmt *)prepareStatementWithQuery:(NSString *)query;
- (void)performAndFinalizeStatement:(sqlite3_stmt *)stmt blockForEachRow:(void (^)(sqlite3_stmt *stmt))row;

@end
