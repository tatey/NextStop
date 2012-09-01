#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

@class RouteRecord;

@protocol RouteSearchDisplayControllerDelegate;

@interface RouteSearchDisplayController : NSObject <UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) id <RouteSearchDisplayControllerDelegate> delegate;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSArray *routes;
@property (strong, nonatomic) UISearchDisplayController *searchDisplayController;

- (id)initWithSearchBar:(UISearchBar *)searchBar contentsController:(UIViewController *)viewController managedObjectContext:(NSManagedObjectContext *)context;

- (void)setActive:(BOOL)active;

@end

@protocol RouteSearchDisplayControllerDelegate <NSObject>

- (void)routeSearchDisplayController:(RouteSearchDisplayController *)routeSearchDisplayController didSelectRoute:(RouteRecord *)route;

@end
