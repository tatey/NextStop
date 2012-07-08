#import "Route.h"
#import "RouteManager.h"
#import "Trip.h"
#import "TripTracker.h"

static NSString *const kDirectionsKey = @"directions";
static NSString *const kTripsKey = @"trips";
static NSString *const kTripTrackers = @"tripTrackers";

@interface RouteManager () {
@private
    __strong NSArray *_directions;
    __strong NSArray *_trips;
    __strong NSArray *_tripTrackers;
}

@end

@implementation RouteManager

@synthesize directions = _directions;
@synthesize route = _route;
@synthesize selectedDirectionIndex = _selectedDirectionIndex;
@synthesize trips = _trips;
@synthesize tripTrackers = _tripTrackers;

- (id)initWithRoute:(Route *)route {
    self = [self init];
    if (self) {
        self.route = route;
    }
    return self;
}

- (NSArray *)directions {
    if (!_directions) {
        NSMutableArray *directions = [NSMutableArray arrayWithCapacity:[self.trips count]];
        for (Trip *trip in self.trips) {
            NSString *direction = NSLocalizedString(TripDirectionToLocalizableString(trip.direction), nil);
            [directions addObject:direction];
        }
        _directions = [directions copy];
    }
    return _directions;
}

- (NSArray *)trips {
    if (!_trips) {
        _trips = [self.route trips];
    }
    return _trips;
}

- (NSArray *)tripTrackers {
    if (!_tripTrackers) {
        NSMutableArray *tripTrackers = [NSMutableArray arrayWithCapacity:[self.trips count]];
        for (Trip *trip in self.trips) {
            TripTracker *tripTracker = [[TripTracker alloc] initWithTrip:trip];
            [tripTrackers addObject:tripTracker];
        }
        _tripTrackers = [tripTrackers copy];
    }
    return _tripTrackers;
}

- (void)setRoute:(Route *)route {
    _route = route;
    [self willChangeValueForKey:kDirectionsKey];
    [self willChangeValueForKey:kTripsKey];
    [self willChangeValueForKey:kTripTrackers];
    _directions = nil; // Clear cache
    _trips = nil; // Clear cache
    _tripTrackers = nil; // Clear cache
    [self didChangeValueForKey:kDirectionsKey];
    [self didChangeValueForKey:kTripsKey];
    [self didChangeValueForKey:kTripTrackers];
}

- (NSString *)name {
    return self.route.shortName;
}

- (TripTracker *)selectedTripTracker {
    return [self.tripTrackers objectAtIndex:self.selectedDirectionIndex];
}

@end
