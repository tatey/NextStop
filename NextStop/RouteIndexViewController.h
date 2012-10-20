#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import "AboutViewController.h"
#import "RouteNewViewController.h"

@interface RouteIndexViewController : UIViewController <AboutViewControllerDelegate, NSFetchedResultsControllerDelegate, RouteNewViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UIBarButtonItem *addBarButtonItem;
@property (strong, nonatomic) UIView *emptyRoutesView;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *routes;
@property (strong, nonatomic) UITableView *tableView;

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context;

@end
