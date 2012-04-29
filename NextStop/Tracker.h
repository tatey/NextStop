#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

extern NSString *const TrackerDidApproachDestinationNotification;

@interface Tracker : NSObject <CLLocationManagerDelegate>

@property (assign, nonatomic) CLLocationCoordinate2D current;
@property (assign, nonatomic) CLLocationCoordinate2D destination;

- (void)start;
- (void)stop;

@end
