#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ModalSearchDisplayController.h"

@class RouteManager;

@interface RouteViewController : UIViewController <ModalSearchDisplayControllerDelegate, UISearchBarDelegate>

@property (strong, nonatomic) UISegmentedControl *directionsControl;
@property (strong, nonatomic) ModalSearchDisplayController *modalSearchDisplayController;
@property (strong, nonatomic) RouteManager *routeManager;
@property (strong, nonatomic) UIBarButtonItem *searchBarButtonItem;
@property (assign, nonatomic) NSInteger selectedIndex;
@property (strong, nonatomic) UIToolbar *toolbar;

- (id)initWithRouteMananger:(RouteManager *)routeManager;

@end
