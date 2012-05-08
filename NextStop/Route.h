#import <Foundation/Foundation.h>

@interface Route : NSObject

@property (readonly) NSString *longName;
@property (readonly) NSUInteger primaryKey;
@property (readonly) NSString *shortName;

+ (NSArray *)routesMatchingShortNameOrLongName:(NSString *)searchText;

@end
