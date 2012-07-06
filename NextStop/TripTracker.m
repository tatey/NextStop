#import "ProximityCenter.h"
#import "Stop.h"
#import "Trip.h"
#import "TripTracker.h"

#define RADIUS 500 // Meters

NSString *const TripTrackerDidApproachTargetNotification = @"me.nextstop.notifications.trip_tracker.approach";

static NSString *const kStopsKey = @"stops";

@interface TripTracker () {
@private
    __strong NSArray *_stops;
}

@property (strong, nonatomic) Proximity *proximity;
@property (readonly) ProximityCenter *proximityCenter;

- (void)startMonitoringProximityToTarget;
- (void)stopMonitoringProximityToTarget;

@end

@implementation TripTracker

// Public
@synthesize monitorProximityToTarget = _monitorProximityToTarget;
@synthesize target = _target;
@synthesize trip = _trip;

// Private
@synthesize proximity = _proximity;
@synthesize proximityCenter = _proximityCenter;

- (id)initWithTrip:(Trip *)trip {
    self = [self init];
    if (self) {
        self.trip = trip;
    }
    return self;
}

- (ProximityCenter *)proximityCenter {
    return [ProximityCenter defaultCenter];
}

- (NSArray *)stops {
    if (!_stops) {
        _stops = [self.trip stops];
    }
    return _stops;
}

- (void)setMonitorProximityToTarget:(BOOL)monitorProximityToTarget {
    _monitorProximityToTarget = monitorProximityToTarget;
    if (monitorProximityToTarget) {
        [self startMonitoringProximityToTarget];
    } else {
        [self stopMonitoringProximityToTarget];
    }
}

- (void)setTarget:(Stop *)target {
    _target = target;
    [self stopMonitoringProximityToTarget];
    if (target) {
        [self startMonitoringProximityToTarget];
    }
}

- (void)setTrip:(Trip *)trip {
    _trip = trip;
    [self willChangeValueForKey:kStopsKey];
    _stops = nil; // Clear cache
    [self didChangeValueForKey:kStopsKey];
}

- (void)startMonitoringProximityToTarget {
    if (!self.monitorProximityToTarget || !self.target) return;
    self.proximity = [[Proximity alloc] initWithDelegate:self radius:RADIUS target:self.target.coordinate];
    [self.proximityCenter addProximity:self.proximity];
}

- (void)stopMonitoringProximityToTarget {
    [self.proximityCenter removeProximity:self.proximity];
    self.proximity = nil;
}

#pragma mark - ProximityDelegate

- (void)proximityDidApproachTarget:(Proximity *)proximity {
    self.monitorProximityToTarget = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:TripTrackerDidApproachTargetNotification object:self];
}

@end
