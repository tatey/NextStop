#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import "RouteSearchDisplayController.h"

@interface RoutesViewController : UITableViewController <NSFetchedResultsControllerDelegate, RouteSearchDisplayControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *routes;
@property (strong, nonatomic) RouteSearchDisplayController *routeSearchDisplayController;
@property (strong, nonatomic) UISearchBar *searchBar;

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context;

@end
