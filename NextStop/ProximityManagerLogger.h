#import <Foundation/Foundation.h>

@class CLLocation;
@class CLRegion;
@class JSONSerializer;
@class ProximityManagedObject;
@class ProximityManager;

@interface ProximityManagerLogger : NSObject

@property (strong, nonatomic) JSONSerializer *serializer;

- (void)setCurrentLocation:(CLLocation *)location;
- (void)setMessage:(NSString *)message;
- (void)setProximity:(ProximityManagedObject *)proximity;
- (void)setRegion:(CLRegion *)region;
- (void)setError:(NSError *)error;

- (void)log;

@end
