#import "User.h"

@interface User () {
@private
    CLLocationCoordinate2D _coordinate;
}

@property (strong, nonatomic) CLLocationManager *manager;

@end

@implementation User

@synthesize manager = _manager;

- (CLLocationManager *)manager {
    if (!_manager) {
        _manager = [[CLLocationManager alloc] init];
        _manager.delegate = self;
    }
    return _manager;
}

- (void)startTracking {
    [self.manager startUpdatingLocation];
}

- (void)stopTracking {
    [self.manager stopUpdatingLocation];
}

#pragma mark - MKAnnotation

- (void)setCoordinate:(CLLocationCoordinate2D)coordinate {
    _coordinate = coordinate;
}

- (CLLocationCoordinate2D)coordinate {
    return _coordinate;
}

- (NSString *)title {
    return NSLocalizedString(@"user.title", nil);
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    self.coordinate = newLocation.coordinate;
}

@end
