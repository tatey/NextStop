#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface Route : NSObject {
@private
    NSString *_code;
    NSString *_name;
    NSUInteger _primaryKey;
}

@property (readonly) NSString *code;
@property (readonly) NSString *name;
@property (readonly) NSUInteger primaryKey;

+ (NSArray *)routesMatchingCodeOrName:(NSString *)codeOrName;

- (id)initWithStatement:(sqlite3_stmt *)stmt;

@end
