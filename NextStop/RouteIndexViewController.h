#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import "MoreInfoViewController.h"
#import "RouteNewViewController.h"

@interface RouteIndexViewController : UIViewController <MoreInfoViewControllerDelegate, NSFetchedResultsControllerDelegate, RouteNewViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UIBarButtonItem *addBarButtonItem;
@property (strong, nonatomic) UIView *emptyRouteView;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *routes;
@property (strong, nonatomic) UITableView *tableView;

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context;

@end
