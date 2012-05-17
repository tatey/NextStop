#import <math.h>
#import "Proximity.h"

#define EQUATOR 6378100.0 // Meters

static NSString *const kCurrentKeyPath = @"current";

static NSString *kJourneyArchiveKey = @"me.nextstop.archive.proximity.journey";
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

@synthesize journey = _journey;
@synthesize radius = _radius;
@synthesize target = _target;

- (id)initWithJourney:(Journey *)journey radius:(CLLocationDistance)radius target:(CLLocationCoordinate2D)target {
    self = [self init];
    if (self) {
        self.journey = journey;
        self.radius = radius;
        self.target = target;
    }
    return self;    
}

- (BOOL)isCoordinateInProximityToTarget:(CLLocationCoordinate2D)coordinate {
    return Haversin(coordinate, self.target) <= self.radius;    
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)coder {
    Journey *journey = [coder decodeObjectForKey:kJourneyArchiveKey];
    CLLocationDistance radius = [coder decodeDoubleForKey:kRadiusArchiveKey];
    CLLocationCoordinate2D target = CLLocationCoordinate2DMake([coder decodeDoubleForKey:kTargetLatitudeArchiveKey], [coder decodeDoubleForKey:kTargetLongitudeArchiveKey]);
    self = [self initWithJourney:journey radius:radius target:target];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.journey forKey:kJourneyArchiveKey];
    [coder encodeDouble:self.radius forKey:kRadiusArchiveKey];
    [coder encodeDouble:self.target.latitude forKey:kTargetLatitudeArchiveKey];
    [coder encodeDouble:self.target.longitude forKey:kTargetLongitudeArchiveKey];
}

@end
