#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>
#import "Proximity.h"

extern NSString *const DirectionManagedObjectDidApproachTargetNotification;

@class DirectionRecord;
@class StopRecord;

@interface DirectionManagedObject : NSManagedObject <ProximityDelegate>

@property (strong, nonatomic) DirectionRecord *direction;
@property (assign, nonatomic, getter = isMonitoringProximityToTarget) BOOL monitorProximityToTarget;
@property (strong, nonatomic) StopRecord *target;

- (id)initWithDirection:(DirectionRecord *)direction managedObjectContext:(NSManagedObjectContext *)context;

- (NSString *)headsign;
- (NSArray *)stops;

@end