#import "ProximityManagedObject.h"
#import "ProximitySerializer.h"

@implementation ProximitySerializer

+ (id)serialize:(id)object {
    ProximityManagedObject *proximity = object;
    return @{
        @"identifier": proximity.identifier,
        @"notificationRadius": [NSNumber numberWithDouble:proximity.notificationRadius],
        @"precisionRadius": [NSNumber numberWithDouble:proximity.precisionRadius],
        @"targetLatitude": [NSNumber numberWithDouble:proximity.target.latitude],
        @"targetLongitude": [NSNumber numberWithDouble:proximity.target.longitude]
    };
}

@end
