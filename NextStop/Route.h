#import <Foundation/Foundation.h>

@interface Route : NSObject

@property (readonly) NSString *longName;
@property (readonly) NSString *shortName;
@property (readonly) NSUInteger primaryKey;

+ (NSArray *)routesMatchingShortNameOrLongName:(NSString *)searchText;

@end
