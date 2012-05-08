#import "Journey.h"
#import "Route.h"
#import "Trip.h"

static NSString *const kHeadingsKey = @"headings";
static NSString *const kStopsKey = @"stops";

@interface Journey () {
@private
    NSArray *_headings;
    NSArray *_stops;
    NSArray *_trips;
}

@property (readonly) NSArray *trips;

- (Trip *)selectedTrip;

@end

@implementation Journey

@synthesize route = _route;
@synthesize selectedHeadingIndex = _selectedHeadingIndex;

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
        for (Trip *trip in headings) {
            NSString *heading = TripHeadingToString(trip.heading);
            [headings addObject:heading];
        }
        _headings = [headings copy];
    }
    return _headings;
}

- (NSArray *)stops {
    if (!_headings) {
        Trip *trip = [self selectedTrip];
        _headings = [trip stops];
    }
    return _headings;
}

- (NSArray *)trips {
    if (!_trips) {
        _trips = [Trip tripsBelongingToRoute:self.route];
    }
    return _trips;
}

- (Trip *)selectedTrip {
    return [self.trips objectAtIndex:self.selectedHeadingIndex];    
}

@end
