#import "NSObject+KVOSEL.h"
#import "Proximity.h"
#import "ProximityCenter.h"

typedef enum {
    LocationManagerPrecisionBestMode,
    LocationManagerPowerBestMode,
} LocationManagerMode;

static NSString *NSStringFromLocationManagerMode(LocationManagerMode mode) {
    switch (mode) {
        case LocationManagerPrecisionBestMode:
            return @"LocationManagerPrecisionBestMode";
        case LocationManagerPowerBestMode:
            return @"LocationManagerPowerBestMode";
    }
}

static NSString *const kCurrentKeyPath = @"current";
static NSString *const kModeKeyPath = @"mode";
static NSString *const kProximityCountKeyPath = @"proximityCount";

@interface ProximityCenter () <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (assign, nonatomic) LocationManagerMode locationManagerMode;
@property (copy, nonatomic) NSMutableArray *proximities;

- (void)notifiyDelegatesInRadiusToProximities:(NSArray *)proximities;
- (void)setLocationManagerModeWithProximities:(NSArray *)proximities;

- (void)currentDidChangeValue;
- (void)modeDidChangeValue;
- (void)proximityCountDidChange;

- (void)startUpdatingCurrent;
- (void)stopUpdatingCurrent;

@end

@implementation ProximityCenter

// Public
@synthesize current = _current;
@synthesize proximityCenterMode = _proximityCenterMode;

// Private
@synthesize locationManager = _locationManager;
@synthesize locationManagerMode = _locationManagerMode;
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
        self.locationManagerMode = LocationManagerPrecisionBestMode;
        [self addObserver:self forKeyPath:kCurrentKeyPath options:NSKeyValueObservingOptionNew context:@selector(currentDidChangeValue)];
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

- (void)startUpdatingCurrent {
    if (self.locationManagerMode == LocationManagerPowerBestMode && self.proximityCenterMode == ProximityCenterPowerBestMode) {
        [self.locationManager startMonitoringSignificantLocationChanges];
        [self.locationManager stopUpdatingLocation];
    } else {
        [self.locationManager startUpdatingLocation];
        [self.locationManager stopMonitoringSignificantLocationChanges];
    }
}

- (void)stopUpdatingCurrent {
    [self.locationManager stopMonitoringSignificantLocationChanges];
    [self.locationManager stopUpdatingLocation];
}

- (void)notifiyDelegatesInRadiusToProximities:(NSArray *)proximities {
    for (Proximity *proximity in proximities) {
        if ([proximity isNotificationRadiusInProximityToCoordinate:self.current]) {
            [proximity.delegate proximityDidApproachTarget:proximity];
        }
    }
}

- (void)setLocationManagerModeWithProximities:(NSArray *)proximities {
    LocationManagerMode mode = LocationManagerPowerBestMode;
    for (Proximity *proximity in proximities) {
        if ([proximity isPrecisionRadiusInProximityToCoordinate:self.current]) {
            mode = LocationManagerPrecisionBestMode;
            break;
        }
    }
    self.locationManagerMode = mode;
}

#pragma mark - Events

- (void)currentDidChangeValue {
    NSArray *proximities = [self.proximities copy];
    [self notifiyDelegatesInRadiusToProximities:proximities];
    [self setLocationManagerModeWithProximities:proximities];
}

- (void)modeDidChangeValue {
    if (self.proximityCount == 0) return;
    [self startUpdatingCurrent];
}

- (void)proximityCountDidChange {
    if (self.proximityCount > 0) {
        [self startUpdatingCurrent];
    } else {
        [self stopUpdatingCurrent];
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    self.current = newLocation.coordinate;
}

@end
