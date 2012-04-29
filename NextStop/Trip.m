#import "Route.h"
#import "Stop.h"
#import "Trip.h"

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
    _route = route;
    _stops = nil; // Clear cached stops
}

- (NSArray *)stops {
    if (!_stops) {
        _stops = [Stop stopsMatchingRoute:self.route];
    }
    return _stops;
}

- (NSInteger)numberOfStops {
    return [self.stops count];
}

@end
