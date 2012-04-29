#import "Tracker.h"

@interface Tracker ()

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation Tracker

@synthesize current = _current;
@synthesize destination = _destination;

@synthesize locationManager = _locationManager;

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    return _locationManager;
}

- (void)start {
    [self.locationManager startUpdatingLocation];
}

- (void)stop {
    [self.locationManager stopUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    self.current = manager.location.coordinate;
}

@end
