#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import "AboutViewController.h"
#import "RouteNewViewController.h"

@interface RouteIndexViewController : UITableViewController <AboutViewControllerDelegate, NSFetchedResultsControllerDelegate, RouteNewViewControllerDelegate>

@property (strong, nonatomic) UIBarButtonItem *addBarButtonItem;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *routes;

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context;

@end
