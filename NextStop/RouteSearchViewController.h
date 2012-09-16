#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class RouteRecord;

@protocol RouteSearchViewControllerDelegate;

@interface RouteSearchViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate>

@property (strong, nonatomic) UIBarButtonItem *cancelBarButtonItem;
@property (weak, nonatomic) id <RouteSearchViewControllerDelegate> delegate;
@property (strong, nonatomic) NSArray *routes;
@property (strong, nonatomic) NSArray *filteredRoutes;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UISearchDisplayController *searchController;

- (id)initWithDelegate:(id <RouteSearchViewControllerDelegate>)delegate;

@end

@protocol RouteSearchViewControllerDelegate <NSObject>

- (void)routeSearchViewController:(RouteSearchViewController *)routeSearchViewController didSelectRoute:(RouteRecord *)route;
- (void)routeSearchViewControllerDidFinish:(RouteSearchViewController *)routeSearchViewController;

@end
