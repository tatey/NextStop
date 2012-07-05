#import "NSObject+KVOSEL.h"
#import "Proximity.h"
#import "ProximityCenter.h"

static NSString *const kCurrentKeyPath = @"current";
static NSString *const kModeKeyPath = @"mode";
static NSString *const kProximityCountKeyPath = @"proximityCount";

static NSString *const kProximitiesArchiveKey = @"me.nextstop.archive.proximity_center.proximities";

@interface ProximityCenter () <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (copy, nonatomic) NSMutableArray *proximities;

- (void)modeDidChangeValue;
- (void)proximityCountDidChange;
- (void)proximitiesInRadiusToTargets;

- (void)startUpdatingCurrent:(ProximityMode)mode;
- (void)stopUpdatingCurrent;

@end

@implementation ProximityCenter

// Public
@synthesize current = _current;
@synthesize mode = _mode;

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
        [self addObserver:self forKeyPath:kModeKeyPath options:NSKeyValueObservingOptionNew context:@selector(modeDidChangeValue)];
        [self addObserver:self forKeyPath:kProximityCountKeyPath options:NSKeyValueObservingOptionNew context:@selector(proximityCountDidChange)];
    }
    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:kCurrentKeyPath];
    [self removeObserver:self forKeyPath:kModeKeyPath];
    [self removeObserver:self forKeyPath:kProximityCountKeyPath];
}

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
    }
    return _locationManager;
}

- (NSMutableArray *)proximities {
    if (!_proximities) {
        _proximities = [NSMutableArray array];
    }
    return _proximities;
}

- (NSInteger)proximityCount {
    return [self.proximities count];
}

- (void)addProximity:(Proximity *)proximity {
    [self willChangeValueForKey:kProximityCountKeyPath];
    [self.proximities addObject:proximity];
    [self didChangeValueForKey:kProximityCountKeyPath];
}

- (void)removeProximity:(Proximity *)proximity {
    [self willChangeValueForKey:kProximityCountKeyPath];
    [self.proximities removeObject:proximity];
    [self didChangeValueForKey:kProximityCountKeyPath];
}

- (void)startUpdatingCurrent:(ProximityMode)mode {
    switch (mode) {
        case ProximityAccuracyBestMode:
            [self.locationManager startUpdatingLocation];
            break;
        case ProximityPowerBestMode:
            [self.locationManager startUpdatingLocation];
            break;
    }
}

- (void)stopUpdatingCurrent {
    [self.locationManager stopUpdatingLocation];
}

#pragma mark - Events

- (void)modeDidChangeValue {
    if (self.proximityCount == 0) return;
    [self startUpdatingCurrent:self.mode];
}

- (void)proximityCountDidChange {
    if (self.proximityCount > 0) {
        [self startUpdatingCurrent:self.mode];
    } else {
        [self stopUpdatingCurrent];
    }
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
