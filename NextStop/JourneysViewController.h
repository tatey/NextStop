#import <UIKit/UIKit.h>
#import "Route.h"

@class RoutesTableViewController;

@interface JourneysViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) RoutesTableViewController *routesController;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UISearchDisplayController *searchController;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *journeys;

@end