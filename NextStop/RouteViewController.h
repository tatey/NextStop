#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class RouteManager;

@interface RouteViewController : UIViewController

@property (strong, nonatomic) UISegmentedControl *directionsControl;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) RouteManager *routeManager;
@property (strong, nonatomic) UIBarButtonItem *searchBarButtonItem;
@property (assign, nonatomic) NSInteger selectedIndex;
@property (strong, nonatomic) UIToolbar *toolbar;

- (id)initWithRouteMananger:(RouteManager *)routeManager managedObjectContext:(NSManagedObjectContext *)context;

@end
