#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>
#import "DirectionManagedObject.h"

@class RouteRecord;

@interface RouteManagedObject : NSManagedObject <DirectionManagedObjectDelegate>

@property (strong, nonatomic) RouteRecord *route;
@property (readonly, nonatomic) NSNumber *isMonitoringProximityToTarget;
@property (copy, nonatomic) NSMutableOrderedSet *directions;
@property (assign, nonatomic) NSInteger selectedDirectionIndex;
@property (strong, nonatomic) NSDate *updatedAt;

+ (NSFetchedResultsController *)routesInManagedObjectContext:(NSManagedObjectContext *)context sectionNameKeyPath:(NSString *)sectionNameKeyPath cacheName:(NSString *)name;
+ (id)routeMatchingRoute:(RouteRecord *)route managedObjectContext:(NSManagedObjectContext *)context;
+ (id)routeMatchingOrInsertingRoute:(RouteRecord *)route managedObjectContext:(NSManagedObjectContext *)context;

- (id)initWithRoute:(RouteRecord *)route insertIntoManagedObjectContext:(NSManagedObjectContext *)context;

- (NSArray *)headsigns;
- (DirectionManagedObject *)selectedDirection;

- (NSString *)name;

- (void)touch;

@end
