#import <UIKit/UIKit.h>
#import "Trip.h"

@class RoutesTableViewController;

@interface RoutesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *routes;
@property (strong, nonatomic) RoutesTableViewController *routesController;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UISearchDisplayController *searchController;
@property (strong, nonatomic) UITableView *tableView;

@end
