#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

typedef enum {
    ProximityCenterPrecisionBestMode,
    ProximityCenterPowerBestMode,
} ProximityCenterMode;

static NSString *NSStringFromProximityCenterMode(ProximityCenterMode mode) {
    switch (mode) {
        case ProximityCenterPrecisionBestMode:
            return @"ProximityCenterPrecisionBestMode";
        case ProximityCenterPowerBestMode:
            return @"ProximityCenterPowerBestMode";
    }
}

@class Proximity;

@interface ProximityCenter : NSObject

@property (assign, nonatomic) CLLocationCoordinate2D current;
@property (assign, nonatomic) ProximityCenterMode proximityCenterMode;
@property (readonly, nonatomic) NSInteger proximityCount;

+ (id)defaultCenter;

- (void)addProximity:(Proximity *)proximity;
- (void)removeProximity:(Proximity *)proximity;

@end
