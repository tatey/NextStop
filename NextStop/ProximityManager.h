#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

@class DataManager;
@class ProximityManagedObject;
@class ProximitySetManagedObject;

@interface ProximityManager : NSObject <CLLocationManagerDelegate>

@property (strong, nonatomic) DataManager *dataManager;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) ProximitySetManagedObject *proximitySet;

- (id)initWithDataManager:(DataManager *)dataManager;

- (void)resume;

- (void)startMonitoringProximity:(ProximityManagedObject *)proximity;
- (void)stopMonitoringProximity:(ProximityManagedObject *)proximity;

@end
