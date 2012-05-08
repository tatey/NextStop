#import <math.h>
#import "Tracker.h"

#define EQUATOR 6378100.0
#define RADIUS  500.0

typedef double Radians;

NSString *const TrackerWillApproachDestinationNotification = @"me.nextstop.tracker.notifications.approaching";

static NSString *const kCurrentKeyPath = @"current";

static inline Radians DegreesToRadians(CLLocationDegrees degrees) {
    return degrees * M_PI / 180.0;
}

static inline CLLocationDistance Haversin(CLLocationDegrees lat1, CLLocationDegrees lng1, CLLocationDegrees lat2, CLLocationDegrees lng2) {
    Radians lat1rad = DegreesToRadians(lat1);
    Radians lat2rad = DegreesToRadians(lat2);
    return acos(sin(lat1rad) * sin(lat2rad) + cos(lat1rad) * cos(lat2rad) * cos(DegreesToRadians(lng2) - DegreesToRadians(lng1))) * EQUATOR;
}

@interface Tracker ()

@property (strong, nonatomic) CLLocationManager *manager;

@end

@implementation Tracker

@synthesize current = _current;
@synthesize destination = _destination;

@synthesize manager = _manager;

- (id)init {
    self = [super init];
    if (self) {
        self.manager = [[CLLocationManager alloc] init];
        self.manager.delegate = self;
        [self addObserver:self forKeyPath:kCurrentKeyPath options:0 context:@selector(currentDidChange:)];
    }
    return self;
}

- (id)initWithDestination:(CLLocationCoordinate2D)destination {
    self = [self init];
    if (self) {
        self.destination = destination;
    }
    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:kCurrentKeyPath];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    #if defined (__clang__)
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    #endif
    [self performSelector:(SEL)context withObject:change];
    #if defined (__clang__)
        #pragma clang diagnostic pop
    #endif
}

- (void)start {
    [self.manager startUpdatingLocation];
}

- (void)stop {
    [self.manager stopUpdatingLocation];
}

- (void)currentDidChange:(NSDictionary *)change {
    if (Haversin(self.current.latitude, self.current.longitude, self.destination.latitude, self.destination.longitude) <= RADIUS) {
        [[NSNotificationCenter defaultCenter] postNotificationName:TrackerWillApproachDestinationNotification object:self];
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    self.current = newLocation.coordinate;
}

@end
