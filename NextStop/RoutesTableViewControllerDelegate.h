#import <Foundation/Foundation.h>

@class RouteRecord;
@class RoutesTableViewController;

@protocol RoutesTableViewDelegate <NSObject>

- (void)routesTableViewController:(RoutesTableViewController *)routesTableViewController didSelectRoute:(RouteRecord *)route;

@end
