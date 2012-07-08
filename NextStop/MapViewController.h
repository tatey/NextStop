#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

@class RouteManager;
@class TripTracker;

@interface MapViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) RouteManager *routeManager;
@property (strong, nonatomic) TripTracker *tripTracker;

- (id)initWithRouteManager:(RouteManager *)routeManager;

@end
