#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

extern NSString *const TrackerWillApproachDestinationNotification;

@interface Tracker : NSObject <CLLocationManagerDelegate>

@property (assign, nonatomic) CLLocationCoordinate2D current;
@property (assign, nonatomic) CLLocationCoordinate2D destination;

- (id)initWithDestination:(CLLocationCoordinate2D)destination;

- (void)start;
- (void)stop;

@end
