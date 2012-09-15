#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>
#import "Proximity.h"

@class DestinationManagedObject;
@class DirectionRecord;
@class StopRecord;
@class RouteManager;

@protocol DirectionManagedObjectDelegate;

@interface DirectionManagedObject : NSManagedObject <ProximityDelegate>

@property (strong, nonatomic) DestinationManagedObject *destination;
@property (strong, nonatomic) DirectionRecord *direction;
@property (assign, nonatomic, getter = isMonitoringProximityToTarget) BOOL monitorProximityToTarget;
@property (strong, nonatomic) RouteManager *routeManager;
@property (strong, nonatomic) StopRecord *target;

+ (void)startMonitoringProximityToTargetsInManagedObjectContext:(NSManagedObjectContext *)context;

- (id)initWithDirection:(DirectionRecord *)direction managedObjectContext:(NSManagedObjectContext *)context;

- (void)replaceDestinationWithDestination:(DestinationManagedObject *)destination;

- (NSArray *)annotations;
- (NSString *)headsign;
- (NSArray *)stops;

@end

@protocol DirectionManagedObjectDelegate

- (void)directionManagedObject:(DirectionManagedObject *)directionManagedObject didChangeMonitorProximityToTarget:(BOOL)monitorProximityToTarget;

@end
