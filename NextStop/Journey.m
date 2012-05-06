#import "Journey.h"
#import "Stop.h"
#import "Trip.h"

@interface Journey () {
@private
    NSArray *_stops;
}
@end

@implementation Journey

@synthesize destination = _destination;
@synthesize trip = _trip;

- (id)initWithTrip:(Trip *)trip {
    self = [self init];
    if (self) {
        self.trip = trip;
    }
    return self;
}

- (void)setTrip:(Trip *)trip {
    _trip = trip;
    _stops = nil; // Clear cached stops
}

- (NSArray *)stops {
    if (!_stops) {
        _stops = [Stop stopsMatchingTrip:self.trip];
    }
    return _stops;
}

@end
