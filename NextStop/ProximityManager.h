#import <CoreLocation/CoreLocation.h>
#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

@class ProximityManagedObject;
@class ProximitySetManagedObject;

@interface ProximityManager : NSObject <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) ProximitySetManagedObject *proximitySet;

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context;

- (void)resume;

- (void)startMonitoringProximity:(ProximityManagedObject *)proximity;
- (void)stopMonitoringProximity:(ProximityManagedObject *)proximity;

@end
