#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

typedef enum {
    ProximityAccuracyBestMode,
    ProximityPowerBestMode,
} ProximityMode;

extern NSString *const ProximityDidApproachTargetNotification;

@class Proximity;

@interface ProximityCenter : NSObject <NSCoding>

@property (assign, nonatomic) CLLocationCoordinate2D current;

+ (id)defaultCenter;

- (void)addProximity:(Proximity *)proximity;
- (void)removeProximity:(Proximity *)proximity;

- (void)startUpdatingCurrent:(ProximityMode)mode;
- (void)stopUpdatingCurrent;

@end
