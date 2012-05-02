#import <UIKit/UIKit.h>
#import "Route.h"

@class RoutesTableViewController;

@interface TripsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (assign, nonatomic) RouteDirection direction;
@property (strong, nonatomic) UISegmentedControl *directionControl;
@property (strong, nonatomic) RoutesTableViewController *routesController;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UISearchDisplayController *searchController;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *trips;

- (id)initWithDirection:(RouteDirection)direction;

@end
