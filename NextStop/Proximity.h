#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

@protocol ProximityDelegate;

@interface Proximity : NSObject

@property (weak, nonatomic) id <ProximityDelegate> delegate;
@property (assign, nonatomic) CLLocationDistance notificationRadius;
@property (assign, nonatomic) CLLocationDistance precisionRadius;
@property (assign, nonatomic) CLLocationCoordinate2D target;

- (id)initWithDelegate:(id <ProximityDelegate>)delegate notificationRadius:(CLLocationDistance)notificationRadius precisionRadius:(CLLocationDistance)precisionRadius target:(CLLocationCoordinate2D)target;

- (BOOL)isNotificationRadiusInProximityToCoordinate:(CLLocationCoordinate2D)coordinate;
- (BOOL)isPrecisionRadiusInProximityToCoordinate:(CLLocationCoordinate2D)coordinate;

@end

@protocol ProximityDelegate <NSObject>

- (void)proximityDidApproachTarget:(Proximity *)proximity;

@end
