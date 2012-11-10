#import <CoreLocation/CoreLocation.h>
#import "RegionSerializer.h"

@implementation RegionSerializer

+ (id)serialize:(id)object {
    CLRegion *region = object;
    return @{@"identifier" : region.identifier};
}

@end
