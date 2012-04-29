#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

@class Trip;

@interface MapViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) Trip *trip;

- (id)initWithTrip:(Trip *)trip;

- (void)zoomToFit;

@end
