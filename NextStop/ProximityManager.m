#import "DataManager.h"
#import "ProximityManagedObject.h"
#import "ProximityManager.h"
#import "ProximitySetManagedObject.h"

@implementation ProximityManager

- (id)initWithDataManager:(DataManager *)dataManager {
    self = [self init];
    if (self) {
        self.dataManager = dataManager;
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

- (ProximitySetManagedObject *)proximitySet {
    if (!_proximitySet) {
        _proximitySet = [ProximitySetManagedObject proximitySetInManagedObjectContext:self.dataManager.managedObjectContext];
    }
    return _proximitySet;
}

- (void)resume {
    [self toggleUpdatingLocation:[self.proximitySet count]];
}

- (void)startMonitoringProximity:(ProximityManagedObject *)proximity {
    if ([proximity precisionRadiusContainsCoordinate:self.locationManager.location.coordinate]) {
        [self addProximity:proximity];
    } else {
        [self.locationManager startMonitoringForRegion:[proximity precisionRegion]];
    }
    [self.dataManager save];
}

- (void)stopMonitoringProximity:(ProximityManagedObject *)proximity {
    [self.locationManager stopMonitoringForRegion:[proximity precisionRegion]];
    [self removeProximity:proximity];
    [self.dataManager save];
}

- (void)addProximity:(ProximityManagedObject *)proximity {
    [self.proximitySet addProximity:proximity];
    [self toggleUpdatingLocation:[self.proximitySet count]];
}

- (void)removeProximity:(ProximityManagedObject *)proximity {
    [self.proximitySet removeProximity:proximity];
    [self toggleUpdatingLocation:[self.proximitySet count]];
}

- (void)toggleUpdatingLocation:(NSInteger)proximityCount {
    if (proximityCount > 0) {
        [self.locationManager startUpdatingLocation];
    } else {
        [self.locationManager stopUpdatingLocation];
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    ProximityManagedObject *proximity = [ProximityManagedObject proximityMatchingIdentifier:region.identifier managedObjectContext:self.dataManager.managedObjectContext];
    if (proximity) {
        [self.locationManager stopMonitoringForRegion:region];
        [self addProximity:proximity];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    for (ProximityManagedObject *proximity in self.proximitySet) {
        if ([proximity notificationRadiusContainsCoordinate:newLocation.coordinate]) {
            [proximity targetContainedWithinNotificationRadius];
        }
    }
}

@end
