#import "Haversin.h"
#import "Proximity.h"

static NSString *const kCurrentKeyPath = @"current";

@implementation Proximity

@synthesize delegate = _delegate;
@synthesize notificationRadius = _notificationRadius;
@synthesize precisionRadius = _precisionRadius;
@synthesize target = _target;

- (id)initWithDelegate:(id <ProximityDelegate>)delegate notificationRadius:(CLLocationDistance)notificationRadius precisionRadius:(CLLocationDistance)precisionRadius target:(CLLocationCoordinate2D)target {
    self = [self init];
    if (self) {
        self.delegate = delegate;
        self.notificationRadius = notificationRadius;
        self.precisionRadius = precisionRadius;
        self.target = target;
    }
    return self;
}

- (BOOL)isNotificationRadiusInProximityToCoordinate:(CLLocationCoordinate2D)coordinate {
    return Haversin(coordinate, self.target) <= self.notificationRadius;
}

- (BOOL)isPrecisionRadiusInProximityToCoordinate:(CLLocationCoordinate2D)coordinate {
    return Haversin(coordinate, self.target) <= self.precisionRadius;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, notificationRadius: %f, precisionRadius: %f, target: %f,%f>", NSStringFromClass([self class]), self, self.notificationRadius, self.precisionRadius, self.target.latitude, self.target.longitude];
}

@end
