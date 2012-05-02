#import <UIKit/UIKit.h>

@class RoutesTableViewController;

@interface TripsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) RoutesTableViewController *routesController;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UISearchDisplayController *searchController;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *trips;

@end
