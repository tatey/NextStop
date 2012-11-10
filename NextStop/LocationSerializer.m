#import <CoreLocation/CoreLocation.h>
#import "LocationSerializer.h"

@implementation LocationSerializer

+ (id)serialize:(id)object {
    CLLocation *location = object;
    return @{@"latitude" : [NSNumber numberWithDouble:location.coordinate.latitude]};
}

@end
