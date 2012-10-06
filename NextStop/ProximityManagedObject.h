#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

@class DirectionManagedObject;
@class ProximitySetManagedObject;

@interface ProximityManagedObject : NSManagedObject

@property (readonly) DirectionManagedObject *direction;
@property (readonly) NSString *identifier;
@property (readonly) CLLocationDistance notificationRadius;
@property (readonly) CLLocationDistance precisionRadius;
@property (strong, nonatomic) ProximitySetManagedObject *proximitySet;
@property (readonly) CLLocationCoordinate2D target;

+ (id)proximityMatchingIdentifier:(NSString *)identifier managedObjectContext:(NSManagedObjectContext *)context;

- (id)initWithDirectionManagedObject:(DirectionManagedObject *)direction target:(CLLocationCoordinate2D)target notificationRadius:(CLLocationDistance)notificationRadius precisionRadius:(CLLocationDistance)precisionRadius identifier:(NSString *)identifier managedObjectContext:(NSManagedObjectContext *)context;

- (BOOL)notificationRadiusContainsCoordinate:(CLLocationCoordinate2D)coordinate;
- (BOOL)precisionRadiusContainsCoordinate:(CLLocationCoordinate2D)coordinate;

- (CLRegion *)precisionRegion;

- (void)targetContainedWithinNotificationRadius;

@end
