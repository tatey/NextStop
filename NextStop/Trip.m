#import "Route.h"
#import "Stop.h"
#import "Trip.h"

static NSString *const kRouteKey = @"route";
static NSString *const kStopsKey = @"stops";

@interface Trip () {
@private
    NSArray *_stops;
}
@end

@implementation Trip

@synthesize destination = _destination;
@synthesize route = _route;

- (id)initWithRoute:(Route *)route {
    self = [self init];
    if (self) {
        self.route = route;
    }
    return self;
}

- (void)setRoute:(Route *)route {
    [self willChangeValueForKey:kRouteKey];
    _route = route;
    _stops = nil; // Clear cached stops
    [self didChangeValueForKey:kRouteKey];
}

- (NSArray *)stops {
    if (!_stops) {
        [self willChangeValueForKey:kStopsKey];
        _stops = [Stop stopsMatchingRoute:self.route];
        [self didChangeValueForKey:kStopsKey];
    }
    return _stops;
}

- (NSInteger)numberOfStops {
    return [self.stops count];
}

@end
