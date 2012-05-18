#import "Journey.h"
#import "NSObject+KVOSEL.h"
#import "Proximity.h"
#import "ProximityCenter.h"

static NSString *const kCurrentKeyPath = @"current";

static NSString *const kProximitiesArchiveKey = @"me.nextstop.archive.proximity_center.proximities";

@interface ProximityCenter () <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (copy, nonatomic) NSMutableArray *proximities;

- (void)proximitiesInRadiusToTargets;

@end

@implementation ProximityCenter

// Public
@synthesize current = _current;

// Private
@synthesize locationManager = _locationManager;
@synthesize proximities = _proximities;

+ (id)defaultCenter {
    static dispatch_once_t predicate;
    static id defaultCenter = nil;
    dispatch_once(&predicate, ^{
        defaultCenter = [[ProximityCenter alloc] init];
    });
    return defaultCenter;
}

- (id)init {
    self = [super init];
    if (self) {
        [self addObserver:self forKeyPath:kCurrentKeyPath options:NSKeyValueObservingOptionNew context:@selector(proximitiesInRadiusToTargets)];
    }
    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:kCurrentKeyPath];
}

- (NSMutableArray *)proximities {
    if (!_proximities) {
        _proximities = [NSMutableArray array];
    }
    return _proximities;
}

- (void)addProximity:(Proximity *)proximity {
    [self.proximities addObject:proximity];
}

- (void)removeProximity:(Proximity *)proximity {
    [self.proximities removeObject:proximity];
}

- (void)startUpdatingCurrent:(ProximityMode)mode {
    switch (mode) {
        case ProximityAccuracyBestMode:
            [self.locationManager stopMonitoringSignificantLocationChanges];
            [self.locationManager startUpdatingLocation];
            break;
        case ProximityPowerBestMode:
            [self.locationManager stopUpdatingLocation];
            [self.locationManager startMonitoringSignificantLocationChanges];
            break;
    }
}

- (void)stopUpdatingCurrent {
    [self.locationManager stopUpdatingLocation];
    [self.locationManager stopMonitoringSignificantLocationChanges];
}

- (void)proximitiesInRadiusToTargets {
    for (Proximity *proximity in self.proximities) {
        if ([proximity isCoordinateInProximityToTarget:self.current]) {
            [proximity.delegate proximityDidApproachTarget:proximity];
        }
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    self.current = newLocation.coordinate;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)coder {
    self = [self init];
    if (self) {
        _proximities = [coder decodeObjectForKey:kProximitiesArchiveKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.proximities forKey:kProximitiesArchiveKey];
}

@end
