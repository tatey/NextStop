#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ModalSearchViewController.h"

@class RouteManager;

@interface RouteViewController : UIViewController <ModalSearchViewControllerDelegate, UISearchBarDelegate>

@property (strong, nonatomic) UISegmentedControl *directionsControl;
@property (strong, nonatomic) ModalSearchViewController *modalSearchViewController;
@property (strong, nonatomic) RouteManager *routeManager;
@property (strong, nonatomic) UIBarButtonItem *searchBarButtonItem;
@property (assign, nonatomic) NSInteger selectedIndex;
@property (strong, nonatomic) UIToolbar *toolbar;

- (id)initWithRouteMananger:(RouteManager *)routeManager;

@end
