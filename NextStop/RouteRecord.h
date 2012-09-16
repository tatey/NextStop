#import <Foundation/Foundation.h>

@interface RouteRecord : NSObject

@property (readonly) NSString *longName;
@property (readonly) NSUInteger primaryKey;
@property (readonly) NSString *shortName;

+ (RouteRecord *)routeMatchingPrimaryKey:(NSInteger)primaryKey;
+ (NSArray *)routes;
+ (NSArray *)routesMatchingShortNameOrLongName:(NSString *)searchText;

@end
