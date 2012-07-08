#import <UIKit/UIKit.h>
#import "RoutesTableViewControllerDelegate.h"

@class RoutesTableViewController;

@interface RoutesViewController : UITableViewController <RoutesTableViewDelegate>

@property (strong, nonatomic) NSArray *routes;
@property (strong, nonatomic) RoutesTableViewController *routesController;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UISearchDisplayController *searchController;

@end
