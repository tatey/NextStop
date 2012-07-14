#import <Foundation/Foundation.h>

@interface RouteRecord : NSObject <NSCoding>

@property (readonly) NSString *longName;
@property (readonly) NSUInteger primaryKey;
@property (readonly) NSString *shortName;

+ (RouteRecord *)routeMatchingPrimaryKey:(NSInteger)primaryKey;
+ (NSArray *)routesMatchingShortNameOrLongName:(NSString *)searchText;

- (NSArray *)trips;

@end
