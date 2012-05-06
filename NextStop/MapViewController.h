#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

@class Journey;

@interface MapViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) Journey *journey;

- (id)initWithJourney:(Journey *)journey;

@end
