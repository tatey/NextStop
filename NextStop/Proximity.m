#import <math.h>
#import "Proximity.h"

#define EQUATOR 6378100.0 // Meters

static NSString *const kCurrentKeyPath = @"current";

static NSString *kDelegateArchiveKey = @"me.nextstop.archive.proximity.delegate";
static NSString *kRadiusArchiveKey = @"me.nextstop.archive.proximity.radius";
static NSString *kTargetLatitudeArchiveKey = @"me.nextstop.archive.proximity.target_latitude";
static NSString *kTargetLongitudeArchiveKey = @"me.nextstop.archive.proximity.target_longitude";

typedef double Radians;

static Radians DegreesToRadians(CLLocationDegrees degrees) {
    return degrees * M_PI / 180.0;
}

static CLLocationDistance Haversin(CLLocationCoordinate2D c1, CLLocationCoordinate2D c2) {
    Radians lat1rad = DegreesToRadians(c1.latitude);
    Radians lat2rad = DegreesToRadians(c2.latitude);
    return acos(sin(lat1rad) * sin(lat2rad) + cos(lat1rad) * cos(lat2rad) * cos(DegreesToRadians(c2.longitude) - DegreesToRadians(c1.longitude))) * EQUATOR;
}

@implementation Proximity

@synthesize delegate = _delegate;
@synthesize radius = _radius;
@synthesize target = _target;

- (id)initWithDelegate:(id <NSCoding, ProximityDelegate>)delegate radius:(CLLocationDistance)radius target:(CLLocationCoordinate2D)target {
    self = [self init];
    if (self) {
        self.delegate = delegate;
        self.radius = radius;
        self.target = target;
    }
    return self;
}

- (BOOL)isCoordinateInProximityToTarget:(CLLocationCoordinate2D)coordinate {
    return Haversin(coordinate, self.target) <= self.radius;    
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, radius: %f, target: %f,%f>", NSStringFromClass([self class]), self, self.radius, self.target.latitude, self.target.longitude];
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)coder {
    id <NSCoding, ProximityDelegate> delegate = [coder decodeObjectForKey:kDelegateArchiveKey];
    CLLocationDistance radius = [coder decodeDoubleForKey:kRadiusArchiveKey];
    CLLocationCoordinate2D target = CLLocationCoordinate2DMake([coder decodeDoubleForKey:kTargetLatitudeArchiveKey], [coder decodeDoubleForKey:kTargetLongitudeArchiveKey]);
    self = [self initWithDelegate:delegate radius:radius target:target];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.delegate forKey:kDelegateArchiveKey];
    [coder encodeDouble:self.radius forKey:kRadiusArchiveKey];
    [coder encodeDouble:self.target.latitude forKey:kTargetLatitudeArchiveKey];
    [coder encodeDouble:self.target.longitude forKey:kTargetLongitudeArchiveKey];
}

@end
