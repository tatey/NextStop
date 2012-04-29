#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface User : NSObject <CLLocationManagerDelegate, MKAnnotation>

- (void)startTracking;
- (void)stopTracking;

@end
