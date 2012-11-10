#import "ProximityManagedObject.h"
#import "ProximitySerializer.h"

@implementation ProximitySerializer

+ (id)serialize:(id)object {
    ProximityManagedObject *proximity = object;
    return @{@"identifier" : proximity.identifier};
}

@end
