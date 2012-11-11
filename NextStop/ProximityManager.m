#import "DataManager.h"
#import "ProximityManagedObject.h"
#import "ProximityManager.h"
#import "ProximityManagerLogger.h"
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
    ProximityManagerLogger *logger = [[ProximityManagerLogger alloc] init];
    [logger setMessage:@"Will Start Monitoring"];
    [logger setCurrentLocation:self.locationManager.location];
    [logger setProximity:proximity];
    [logger log];
    if ([proximity precisionRadiusContainsCoordinate:self.locationManager.location.coordinate]) {
        [self addProximity:proximity];
    } else {
        [self.locationManager startMonitoringForRegion:[proximity precisionRegion]];
    }
    [self.dataManager save];
}

- (void)stopMonitoringProximity:(ProximityManagedObject *)proximity {
    ProximityManagerLogger *logger = [[ProximityManagerLogger alloc] init];
    [logger setMessage:@"Will Stop Monitoring"];
    [logger setProximity:proximity];
    [logger log];
    [self stopMonitoringProximityWithoutSave:proximity];
    [self.dataManager save];
}

- (void)stopMonitoringProximityWithoutSave:(ProximityManagedObject *)proximity {
    if (proximity) {
        ProximityManagerLogger *logger = [[ProximityManagerLogger alloc] init];
        [logger setMessage:@"Will Stop Monitoring Without Save"];
        [logger setProximity:proximity];
        [logger log];
    }
    [self.locationManager stopMonitoringForRegion:[proximity precisionRegion]];
    [self removeProximity:proximity];
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

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    ProximityManagerLogger *logger = [[ProximityManagerLogger alloc] init];
    [logger setMessage:@"Monitoring Did Fail For Region"];
    [logger setError:error];
    [logger setRegion:region];
    [logger log];
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    ProximityManagerLogger *logger = [[ProximityManagerLogger alloc] init];
    [logger setMessage:@"Did Enter Region"];
    [logger setCurrentLocation:self.locationManager.location];
    [logger setRegion:region];
    [logger log];
    ProximityManagedObject *proximity = [ProximityManagedObject proximityMatchingIdentifier:region.identifier managedObjectContext:self.dataManager.managedObjectContext];
    if (proximity) {
        ProximityManagerLogger *logger = [[ProximityManagerLogger alloc] init];
        [logger setMessage:@"Will Switch From Region Monitoring to GPS"];
        [logger setProximity:proximity];
        [logger log];
        [self.locationManager stopMonitoringForRegion:region];
        [self addProximity:proximity];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSSet *proximities = [self.proximitySet.proximities copy];
    for (ProximityManagedObject *proximity in proximities) {
        if ([proximity notificationRadiusContainsCoordinate:newLocation.coordinate]) {
            ProximityManagerLogger *logger = [[ProximityManagerLogger alloc] init];
            [logger setMessage:@"Will Notify Proximity Within Notification Radius"];
            [logger setCurrentLocation:newLocation];
            [logger setProximity:proximity];
            [logger log];
            [proximity targetContainedWithinNotificationRadius];
        }
    }
}

@end
