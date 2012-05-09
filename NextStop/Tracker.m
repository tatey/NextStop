#import <math.h>
#import "Tracker.h"
#import "TrackerDelegate.h"

#define EQUATOR 6378100.0 // Meters
#define RADIUS  500.0     // Meters

static NSString *const kCurrentKeyPath = @"current";

typedef double Radians;

static inline Radians DegreesToRadians(CLLocationDegrees degrees) {
    return degrees * M_PI / 180.0;
}

static inline CLLocationDistance Haversin(CLLocationCoordinate2D c1, CLLocationCoordinate2D c2) {
    Radians lat1rad = DegreesToRadians(c1.latitude);
    Radians lat2rad = DegreesToRadians(c2.latitude);
    return acos(sin(lat1rad) * sin(lat2rad) + cos(lat1rad) * cos(lat2rad) * cos(DegreesToRadians(c2.longitude) - DegreesToRadians(c1.longitude))) * EQUATOR;
}

@interface Tracker () {
@private
    BOOL _isMonitoringProximityToTarget;
    BOOL _isUpdatingCurrent;
}

@property (strong, nonatomic) CLLocationManager *manager;

- (void)checkCurrentIsInPromixityToTarget;

@end

@implementation Tracker

// Public
@synthesize delegate = _delegate;

// Public
@synthesize current = _current;
@synthesize target = _target;

// Public
@synthesize isMonitoringProximityToTarget = _isMonitoringProximityToTarget;
@synthesize isUpdatingCurrent = _isUpdatingCurrent;

// Private
@synthesize manager = _manager;

- (id)init {
    self = [super init];
    if (self) {
        self.manager = [[CLLocationManager alloc] init];
        self.manager.delegate = self;
    }
    return self;
}

- (id)initWithDelegate:(id <TrackerDelegate>)delegate {
    self = [self init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:kCurrentKeyPath];
}

- (void)startMonitoringProximityToTarget {
    _isMonitoringProximityToTarget = YES;
    [self addObserver:self forKeyPath:kCurrentKeyPath options:NSKeyValueObservingOptionNew context:@selector(checkCurrentIsInPromixityToTarget)];
}

- (void)stopMonitoringProximityToTarget {
    _isMonitoringProximityToTarget = NO;
    [self removeObserver:self forKeyPath:kCurrentKeyPath];
}

- (void)startUpdatingCurrent:(TrackerLocationMode)mode {
    _isUpdatingCurrent = YES;
    switch (mode) {
        case TrackerAccuracyBestLocationMode:
            [self.manager stopMonitoringSignificantLocationChanges];
            [self.manager startUpdatingLocation];
            break;
        case TrackerPowerConservationLocationMode:
            [self.manager stopUpdatingLocation];
            [self.manager startMonitoringSignificantLocationChanges];
            break;
    }
}

- (void)stopUpdatingCurrent {
    _isUpdatingCurrent = NO;
    [self.manager stopUpdatingLocation];
    [self.manager stopMonitoringSignificantLocationChanges];
}

- (void)checkCurrentIsInPromixityToTarget {
    if (Haversin(self.current, self.target) <= RADIUS) {
        [self.delegate trackerCurrentDidBecomeInProximityToTarget:self];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    #if defined (__clang__)
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    #endif
    [self performSelector:(SEL)context];
    #if defined (__clang__)
        #pragma clang diagnostic pop
    #endif
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    self.current = newLocation.coordinate;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [self init];
    if (self) {
        // TODO: How do we serialize structs?
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    
}

@end
