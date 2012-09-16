#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import "RouteSearchViewController.h"

@interface RouteIndexViewController : UITableViewController <NSFetchedResultsControllerDelegate, RouteSearchViewControllerDelegate>

@property (strong, nonatomic) UIBarButtonItem *addBarButtonItem;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *routes;

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context;

@end
