#import <Foundation/Foundation.h>

@interface RouteRecord : NSObject

@property (readonly) NSString *longName;
@property (readonly) NSString *routeId;
@property (readonly) NSString *shortName;

- (NSString *)mediumName;

+ (RouteRecord *)routeMatchingRouteId:(NSString *)routeId;
+ (NSArray *)routes;
+ (NSArray *)routesMatchingShortNameOrLongName:(NSString *)searchText;

@end
