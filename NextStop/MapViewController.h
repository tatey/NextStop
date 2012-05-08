#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

@class Route;

@interface MapViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) Route *route;

- (id)initWithRoute:(Route *)route;

@end
