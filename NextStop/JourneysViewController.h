#import <UIKit/UIKit.h>
#import "Trip.h"

@class TripsTableViewController;

@interface JourneysViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *journeys;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UISearchDisplayController *searchController;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) TripsTableViewController *tripsController;

@end
