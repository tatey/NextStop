#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>
#import "DirectionManagedObject.h"

@class RouteRecord;

@interface RouteManagedObject : NSManagedObject <DirectionManagedObjectDelegate>

@property (strong, nonatomic) RouteRecord *routeRecord;
@property (readonly, nonatomic) NSNumber *isMonitoringProximityToTarget;
@property (copy, nonatomic) NSMutableOrderedSet *directions;
@property (assign, nonatomic) NSInteger selectedDirectionIndex;
@property (strong, nonatomic) NSDate *updatedAt;

+ (NSFetchedResultsController *)routesInManagedObjectContext:(NSManagedObjectContext *)context sectionNameKeyPath:(NSString *)sectionNameKeyPath cacheName:(NSString *)name;
+ (id)routeMatchingRouteId:(NSString *)routeId managedObjectContext:(NSManagedObjectContext *)context;
+ (id)routeMatchingRouteRecord:(RouteRecord *)routeRecord managedObjectContext:(NSManagedObjectContext *)context;
+ (id)routeMatchingOrInsertingRouteRecord:(RouteRecord *)routeRecord managedObjectContext:(NSManagedObjectContext *)context;

- (id)initWithRouteRecord:(RouteRecord *)routeRecord insertIntoManagedObjectContext:(NSManagedObjectContext *)context;

- (NSArray *)headsigns;
- (DirectionManagedObject *)selectedDirection;

- (NSString *)name;

- (void)touch;

@end
