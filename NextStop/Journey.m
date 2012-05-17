#import "Journey.h"
#import "Route.h"
#import "Trip.h"

static NSString *const kHeadingsKey = @"headings";
static NSString *const kStopsKey = @"stops";

@interface Journey () {
@private
    __strong NSArray *_headings;
    __strong NSArray *_stops;
    __strong NSArray *_trips;
}

@property (readonly) NSArray *trips;

- (Trip *)selectedTrip;

@end

@implementation Journey

@synthesize monitorProximityToTarget = _monitorProximityToTarget;
@synthesize route = _route;
@synthesize selectedHeadingIndex = _selectedHeadingIndex;
@synthesize target = _target;

- (id)initWithRoute:(Route *)route {
    self = [self init];
    if (self) {
        self.route = route;
    }
    return self;
}

- (void)setSelectedHeadingIndex:(NSInteger)selectedHeadingIndex {
    [self willChangeValueForKey:kHeadingsKey];
    [self willChangeValueForKey:kStopsKey];
    _selectedHeadingIndex = selectedHeadingIndex;
    _headings = nil; // Clear cache
    _stops = nil; // Clear cache
    _trips = nil; // Clear cache
    [self didChangeValueForKey:kHeadingsKey];
    [self didChangeValueForKey:kStopsKey];
}

- (NSArray *)headings {
    if (!_headings) {
        NSArray *trips = [self trips];
        NSMutableArray *headings = [NSMutableArray arrayWithCapacity:[trips count]];
        for (Trip *trip in trips) {
            NSString *heading = NSLocalizedString(TripHeadingToLocalizableString(trip.heading), nil);
            [headings addObject:heading];
        }
        _headings = [headings copy];
    }
    return _headings;
}

- (NSArray *)stops {
    if (!_stops) {
        Trip *trip = [self selectedTrip];
        _stops = [trip stops];
    }
    return _stops;
}

- (NSString *)name {
    return self.route.shortName;
}

- (NSArray *)trips {
    if (!_trips) {
        _trips = [self.route trips];
    }
    return _trips;
}

- (Trip *)selectedTrip {
    return [self.trips objectAtIndex:self.selectedHeadingIndex];    
}

@end
