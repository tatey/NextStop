#import <Foundation/Foundation.h>
#import "Proximity.h"

extern NSString *const TripTrackerDidApproachTargetNotification;

@class Stop;
@class Trip;

@interface TripTracker : NSObject <ProximityDelegate>

@property (assign, nonatomic) BOOL monitorProximityToTarget;
@property (readonly) NSArray *stops;
@property (strong, nonatomic) Stop *target;
@property (strong, nonatomic) Trip *trip;

- (id)initWithTrip:(Trip *)trip;

@end
