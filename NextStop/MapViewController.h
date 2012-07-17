#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

@class DirectionManagedObject;
@class RouteManager;

@interface MapViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) DirectionManagedObject *direction;
@property (strong, nonatomic) RouteManager *routeManager;

- (id)initWithRouteManager:(RouteManager *)routeManager;

@end
