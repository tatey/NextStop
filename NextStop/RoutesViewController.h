#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import "RoutesTableViewController.h"

@interface RoutesViewController : UITableViewController <NSFetchedResultsControllerDelegate, RoutesTableViewDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *routes;
@property (strong, nonatomic) RoutesTableViewController *routesController;
@property (strong, nonatomic) UISearchBar *searchBar;

@end
