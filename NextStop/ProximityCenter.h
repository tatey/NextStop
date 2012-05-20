#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

typedef enum {
    ProximityAccuracyBestMode,
    ProximityPowerBestMode,
} ProximityMode;

@class Proximity;

@interface ProximityCenter : NSObject <NSCoding>

@property (assign, nonatomic) CLLocationCoordinate2D current;
@property (assign, nonatomic) ProximityMode mode;
@property (readonly, nonatomic) NSInteger proximityCount;

+ (id)defaultCenter;

- (void)addProximity:(Proximity *)proximity;
- (void)removeProximity:(Proximity *)proximity;

@end
