#import "Journey.h"
#import "ProximityCenter.h"
#import "Route.h"
#import "Stop.h"
#import "Trip.h"

#define RADIUS 500 // Meters

NSString *const JourneyDidApproachTargetNotification = @"me.nextstop.notification.journey.approach";

static NSString *const kDirectionsKey = @"directions";
static NSString *const kStopsKey = @"stops";

static NSString *const kRouteArchiveKey = @"me.nextstop.archive.journey.route";
static NSString *const kSelectedDirectionIndexArchiveKey = @"me.nextstop.archive.journey.selected_direction_index";
static NSString *const kTargetArchiveKey = @"me.nextstop.archive.journey.target";

@interface Journey () {
@private
    __strong NSArray *_directions;
    __strong NSArray *_stops;
    __strong NSArray *_trips;
}

@property (strong, nonatomic) Proximity *proximity;
@property (weak, nonatomic) ProximityCenter *proximityCenter;
@property (readonly) NSArray *trips;

- (Trip *)selectedTrip;

- (void)startMonitoringProximityToTarget;
- (void)stopMonitoringProximityToTarget;

@end

@implementation Journey

// Public
@synthesize monitorProximityToTarget = _monitorProximityToTarget;
@synthesize route = _route;
@synthesize selectedDirectionIndex = _selectedDirectionIndex;
@synthesize target = _target;

// Private
@synthesize proximity = _proximity;
@synthesize proximityCenter = _proximityCenter;

- (id)initWithRoute:(Route *)route {
    self = [self init];
    if (self) {
        self.route = route;
    }
    return self;
}

- (void)setSelectedDirectionIndex:(NSInteger)selectedDirectionIndex {
    [self willChangeValueForKey:kDirectionsKey];
    [self willChangeValueForKey:kStopsKey];
    _selectedDirectionIndex = selectedDirectionIndex;
    _directions = nil; // Clear cache
    _stops = nil; // Clear cache
    _trips = nil; // Clear cache
    [self didChangeValueForKey:kDirectionsKey];
    [self didChangeValueForKey:kStopsKey];
}

- (NSArray *)directions {
    if (!_directions) {
        NSArray *trips = [self trips];
        NSMutableArray *directions = [NSMutableArray arrayWithCapacity:[trips count]];
        for (Trip *trip in trips) {
            NSString *direction = NSLocalizedString(TripDirectionToLocalizableString(trip.direction), nil);
            [directions addObject:direction];
        }
        _directions = [directions copy];
    }
    return _directions;
}

- (ProximityCenter *)proximityCenter {
    if (!_proximityCenter) {
        _proximityCenter = [ProximityCenter defaultCenter];
    }
    return _proximityCenter;
}

- (NSArray *)stops {
    if (!_stops) {
        Trip *trip = [self selectedTrip];
        _stops = [trip stops];
    }
    return _stops;
}

- (NSArray *)trips {
    if (!_trips) {
        _trips = [self.route trips];
    }
    return _trips;
}

- (NSString *)name {
    return self.route.shortName;
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

- (Trip *)selectedTrip {
    return [self.trips objectAtIndex:self.selectedDirectionIndex];
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

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)coder {
    self = [self initWithRoute:[coder decodeObjectForKey:kRouteArchiveKey]];
    if (self) {
        self.selectedDirectionIndex = [coder decodeIntegerForKey:kSelectedDirectionIndexArchiveKey];
        self.target = [coder decodeObjectForKey:kTargetArchiveKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.route forKey:kRouteArchiveKey];
    [coder encodeInteger:self.selectedDirectionIndex forKey:kSelectedDirectionIndexArchiveKey];
    [coder encodeObject:self.target forKey:kTargetArchiveKey];
}

#pragma mark - ProximityDelegate

- (void)proximityDidApproachTarget:(Proximity *)proximity {
    self.monitorProximityToTarget = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:JourneyDidApproachTargetNotification object:self];
}

@end
