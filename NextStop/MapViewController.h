#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

@class User;

@interface MapViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) NSArray *stops;
@property (strong, nonatomic) User *user;

- (id)initWithStops:(NSArray *)stops user:(User *)user;

@end
