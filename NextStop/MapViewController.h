#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

@class RouteTracker;
@class TripTracker;

@interface MapViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) RouteTracker *routeTracker;
@property (strong, nonatomic) TripTracker *tripTracker;

- (id)initWithRouteTracker:(RouteTracker *)routeTracker;

@end
