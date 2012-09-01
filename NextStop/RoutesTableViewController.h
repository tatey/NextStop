#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

@protocol RoutesTableViewDelegate;

@interface RoutesTableViewController : NSObject <UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) id <RoutesTableViewDelegate> delegate;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSArray *routes;
@property (strong, nonatomic) UISearchDisplayController *searchDisplayController;

- (id)initWithSearchBar:(UISearchBar *)searchBar contentsController:(UIViewController *)viewController managedObjectContext:(NSManagedObjectContext *)context;

- (void)setSearchDisplayControllerActive:(BOOL)active;

@end
