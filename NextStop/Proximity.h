#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

@class Journey;

@interface Proximity : NSObject <NSCoding>

@property (weak, nonatomic) Journey *journey;
@property (assign, nonatomic) CLLocationDistance radius;
@property (assign, nonatomic) CLLocationCoordinate2D target;

- (id)initWithJourney:(Journey *)journey radius:(CLLocationDistance)radius target:(CLLocationCoordinate2D)target;

- (BOOL)isCoordinateInProximityToTarget:(CLLocationCoordinate2D)coordinate;

@end
