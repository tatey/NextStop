#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class RouteManagedObject;

@interface RouteShowViewController : UIViewController

@property (strong, nonatomic) UISegmentedControl *directionsControl;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) RouteManagedObject *routeManagedObject;
@property (strong, nonatomic) UIBarButtonItem *searchBarButtonItem;
@property (assign, nonatomic) NSInteger selectedIndex;

- (id)initWithRouteMananger:(RouteManagedObject *)routeManagedObject managedObjectContext:(NSManagedObjectContext *)context;

@end
