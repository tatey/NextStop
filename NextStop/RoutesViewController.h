#import <UIKit/UIKit.h>
#import "RoutesTableViewControllerDelegate.h"

@class RoutesTableViewController;

@interface RoutesViewController : UIViewController <RoutesTableViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *routes;
@property (strong, nonatomic) RoutesTableViewController *routesController;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UISearchDisplayController *searchController;
@property (strong, nonatomic) UITableView *tableView;

@end
