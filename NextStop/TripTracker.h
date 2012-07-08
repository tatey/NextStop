#import <Foundation/Foundation.h>
#import "Proximity.h"

extern NSString *const TripTrackerDidApproachTargetNotification;

@class StopRecord;
@class TripRecord;

@interface TripTracker : NSObject <ProximityDelegate>

@property (assign, nonatomic, getter = isMonitoringProximityToTarget) BOOL monitorProximityToTarget;
@property (readonly) NSArray *stops;
@property (strong, nonatomic) StopRecord *target;
@property (strong, nonatomic) TripRecord *trip;

- (id)initWithTrip:(TripRecord *)trip;

@end
