#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class RouteRecord;

@protocol RouteNewViewControllerDelegate;

@interface RouteNewViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate>

@property (strong, nonatomic) UIBarButtonItem *cancelBarButtonItem;
@property (weak, nonatomic) id <RouteNewViewControllerDelegate> delegate;
@property (strong, nonatomic) NSArray *routes;
@property (strong, nonatomic) NSArray *filteredRoutes;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UISearchDisplayController *searchController;

- (id)initWithDelegate:(id <RouteNewViewControllerDelegate>)delegate;

@end

@protocol RouteNewViewControllerDelegate <NSObject>

- (void)routeNewViewController:(RouteNewViewController *)routeNewViewController didSelectRoute:(RouteRecord *)route;
- (void)routeNewViewControllerDidFinish:(RouteNewViewController *)routeNewViewController;

@end
