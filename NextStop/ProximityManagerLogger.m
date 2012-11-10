#import "DDLog.h"
#import "JSONSerializer.h"
#import "LocationSerializer.h"
#import "ProximityManagerLogger.h"
#import "ProximitySerializer.h"
#import "RegionSerializer.h"

static const int ddLogLevel = LOG_LEVEL_INFO;

@implementation ProximityManagerLogger

- (id)init {
    self = [super init];
    if (self) {
        self.serializer = [[JSONSerializer alloc] init];
    }
    return self;
}

- (void)setCurrentLocation:(CLLocation *)location {
    [self.serializer setObject:[LocationSerializer serialize:location] forKey:@"current_location"];
}

- (void)setMessage:(NSString *)message {
    [self.serializer setObject:message forKey:@"message"];
}

- (void)setProximity:(ProximityManagedObject *)proximity {
    [self.serializer setObject:[ProximitySerializer serialize:proximity] forKey:@"proximity"];
}

- (void)setRegion:(CLRegion *)region {
    [self.serializer setObject:[RegionSerializer serialize:region] forKey:@"region"];
}

- (void)log {
    DDLogInfo([self.serializer string]);
}

@end
