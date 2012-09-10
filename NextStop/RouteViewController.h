#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class RouteManager;

@interface RouteViewController : UIViewController

@property (strong, nonatomic) UISegmentedControl *directionsControl;
@property (strong, nonatomic) RouteManager *routeManager;
@property (assign, nonatomic) NSInteger selectedIndex;
@property (strong, nonatomic) UIToolbar *toolbar;

- (id)initWithRouteMananger:(RouteManager *)routeManager;

@end
