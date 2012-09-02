#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

@protocol ProximityDelegate;

@interface Proximity : NSObject

@property (weak, nonatomic) id <NSCoding, ProximityDelegate> delegate;
@property (assign, nonatomic) CLLocationDistance radius;
@property (assign, nonatomic) CLLocationCoordinate2D target;

- (id)initWithDelegate:(id <ProximityDelegate>)delegate radius:(CLLocationDistance)radius target:(CLLocationCoordinate2D)target;

- (BOOL)isCoordinateInProximityToTarget:(CLLocationCoordinate2D)coordinate;

@end

@protocol ProximityDelegate <NSObject>

- (void)proximityDidApproachTarget:(Proximity *)proximity;

@end
