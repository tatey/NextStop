#import <Foundation/Foundation.h>

@class Route;
@class RoutesTableViewController;

@protocol RoutesTableViewDelegate <NSObject>

- (void)routesTableViewController:(RoutesTableViewController *)routesTableViewController didSelectRoute:(Route *)route;

@end
