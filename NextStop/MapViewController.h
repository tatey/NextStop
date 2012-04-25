#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

@class User;

@interface MapViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) User *user;

- (id)initWithUser:(User *)user;

@end
