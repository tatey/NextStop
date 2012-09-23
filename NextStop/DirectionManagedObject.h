#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Proximity.h"

@class DestinationManagedObject;
@class DirectionRecord;
@class StopRecord;
@class RouteManagedObject;

@protocol DirectionManagedObjectDelegate;

@interface DirectionManagedObject : NSManagedObject <ProximityDelegate>

@property (strong, nonatomic) DestinationManagedObject *destination;
@property (strong, nonatomic) DirectionRecord *directionRecord;
@property (assign, nonatomic, getter = isMonitoringProximityToTarget) BOOL monitorProximityToTarget;
@property (strong, nonatomic) RouteManagedObject *routeManagedObject;
@property (strong, nonatomic) StopRecord *target;

+ (void)startMonitoringProximityToTargetsInManagedObjectContext:(NSManagedObjectContext *)context;

- (id)initWithDirectionRecord:(DirectionRecord *)directionRecord managedObjectContext:(NSManagedObjectContext *)context;

- (void)replaceDestinationWithDestination:(DestinationManagedObject *)destination;

- (NSArray *)annotations;
- (NSString *)headsign;
- (NSArray *)stops;

- (void)setRegion:(MKCoordinateRegion)region;
- (MKCoordinateRegion)region;

@end

@protocol DirectionManagedObjectDelegate

- (void)directionManagedObject:(DirectionManagedObject *)directionManagedObject didChangeMonitorProximityToTarget:(BOOL)monitorProximityToTarget;

@end
