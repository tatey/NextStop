#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>
#import "Proximity.h"

extern NSString *const DirectionManagedObjectDidApproachTargetNotification;

@class DirectionRecord;
@class StopRecord;
@class RouteManager;

@protocol DirectionManagedObjectDelegate;

@interface DirectionManagedObject : NSManagedObject <ProximityDelegate>

@property (strong, nonatomic) DirectionRecord *direction;
@property (assign, nonatomic, getter = isMonitoringProximityToTarget) BOOL monitorProximityToTarget;
@property (strong, nonatomic) RouteManager *routeManager;
@property (strong, nonatomic) StopRecord *target;

+ (void)startMonitoringProximityToTargetsInManagedObjectContext:(NSManagedObjectContext *)context;

- (id)initWithDirection:(DirectionRecord *)direction managedObjectContext:(NSManagedObjectContext *)context;

- (NSString *)headsign;
- (NSArray *)stops;

@end

@protocol DirectionManagedObjectDelegate

- (void)directionManagedObject:(DirectionManagedObject *)directionManagedObject didChangeMonitorProximityToTarget:(BOOL)monitorProximityToTarget;

@end
