#import <Foundation/Foundation.h>

@interface JSONSerializer : NSObject

@property (strong, nonatomic) NSMutableDictionary *graph;

- (void)setObject:(id)object forKey:(NSString *)key;

- (NSData *)data;
- (NSString *)string;

@end
