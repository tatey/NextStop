#import <CoreLocation/CoreLocation.h>
#import "LocationSerializer.h"

@implementation LocationSerializer

+ (id)serialize:(id)object {
    CLLocation *location = object;
    return @{
        @"latitude": [NSNumber numberWithDouble:location.coordinate.latitude],
        @"longitude": [NSNumber numberWithDouble:location.coordinate.longitude],
        @"horizontalAccuracy": [NSNumber numberWithDouble:location.horizontalAccuracy],
        @"speed": [NSNumber numberWithDouble:location.speed]
    };
}

@end
