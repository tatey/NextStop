#import "ProximityManagedObject.h"
#import "ProximityManager.h"
#import "ProximitySetManagedObject.h"

@implementation ProximityManager

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context {
    self = [self init];
    if (self) {
        self.managedObjectContext = context;
    }
    return self;
}

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.delegate = self;
    }
    return _locationManager;
}

- (ProximitySetManagedObject *)proximities {
    if (!_proximities) {
        _proximities = [ProximitySetManagedObject proximitySetInManagedObjectContext:self.managedObjectContext];
    }
    return _proximities;
}

- (void)startMonitoringProximity:(ProximityManagedObject *)proximity {
    if ([proximity precisionRadiusContainsCoordinate:self.locationManager.location.coordinate]) {
        [self addProximity:proximity];
    } else {
        [self.locationManager startMonitoringForRegion:[proximity precisionRegion]];
    }
}

- (void)stopMonitoringProximity:(ProximityManagedObject *)proximity {
    [self.locationManager stopMonitoringForRegion:[proximity precisionRegion]];
    [self removeProximity:proximity];
}

- (void)addProximity:(ProximityManagedObject *)proximity {
    [self.proximities addProximity:proximity];
    if ([self.proximities count] > 0) {
        [self.locationManager startUpdatingLocation];
    }
}

- (void)removeProximity:(ProximityManagedObject *)proximity {
    [self.proximities removeProximity:proximity];
    if ([self.proximities count] == 0) {
        [self.locationManager stopUpdatingLocation];
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    ProximityManagedObject *proximity = [ProximityManagedObject proximityMatchingIdentifier:region.identifier managedObjectContext:self.managedObjectContext];
    if (proximity) {
        [self.locationManager stopMonitoringForRegion:region];
        [self addProximity:proximity];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    for (ProximityManagedObject *proximity in self.proximities) {
        if ([proximity notificationRadiusContainsCoordinate:newLocation.coordinate]) {
            [proximity targetContainedWithinNotificationRadius];
        }
    }
}

@end
