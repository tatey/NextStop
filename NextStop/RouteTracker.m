#import "Route.h"
#import "RouteTracker.h"
#import "Trip.h"

static NSString *const kDirectionsKey = @"directions";
static NSString *const kTripsKey = @"trips";

@interface RouteTracker () {
@private
    __strong NSArray *_directions;
    __strong NSArray *_trips;
}

@end

@implementation RouteTracker

@synthesize directions = _directions;
@synthesize route = _route;
@synthesize selectedDirectionIndex = _selectedDirectionIndex;
@synthesize trips = _trips;

- (id)initWithRoute:(Route *)route {
    self = [self init];
    if (self) {
        self.route = route;
    }
    return self;
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

- (NSArray *)trips {
    if (!_trips) {
        _trips = [self.route trips];
    }
    return _trips;
}

- (void)setRoute:(Route *)route {
    _route = route;
    [self willChangeValueForKey:kDirectionsKey];
    [self willChangeValueForKey:kTripsKey];
    _directions = nil; // Clear cache
    _trips = nil; // Clear cache
    [self didChangeValueForKey:kDirectionsKey];
    [self didChangeValueForKey:kTripsKey];
}

- (NSString *)name {
    return self.route.shortName;
}

@end
