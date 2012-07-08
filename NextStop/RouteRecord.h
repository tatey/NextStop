#import <Foundation/Foundation.h>

@interface RouteRecord : NSObject <NSCoding>

@property (readonly) NSString *longName;
@property (readonly) NSUInteger primaryKey;
@property (readonly) NSString *shortName;

+ (NSArray *)routesMatchingShortNameOrLongName:(NSString *)searchText;

- (NSArray *)trips;

@end
