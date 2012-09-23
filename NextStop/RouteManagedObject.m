#import "DirectionManagedObject.h"
#import "DirectionRecord.h"
#import "RouteRecord.h"
#import "RouteManagedObject.h"

static NSString *const kEntityName = @"Route";

@interface RouteManagedObject ()

@property (assign, nonatomic) NSNumber *isMonitoringProximityToTarget;
@property (copy, nonatomic) NSString *routeId;

@end

@implementation RouteManagedObject

// Public
@dynamic directions;
@dynamic selectedDirectionIndex;
@dynamic updatedAt;

@synthesize isMonitoringProximityToTarget = _isMonitoringProximityToTarget;
@synthesize routeRecord = _routeRecord;

// Private
@dynamic routeId;

+ (NSFetchedResultsController *)routesInManagedObjectContext:(NSManagedObjectContext *)context sectionNameKeyPath:(NSString *)sectionNameKeyPath cacheName:(NSString *)name {
    NSEntityDescription *entity = [NSEntityDescription entityForName:kEntityName inManagedObjectContext:context];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"updatedAt" ascending:NO];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = entity;
    request.sortDescriptors = [NSArray arrayWithObject:sort];
    return [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:sectionNameKeyPath cacheName:name];
}

+ (id)routeMatchingRouteRecord:(RouteRecord *)routeRecord managedObjectContext:(NSManagedObjectContext *)context {
    NSEntityDescription *entity = [NSEntityDescription entityForName:kEntityName inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"routeId == %@", routeRecord.routeId];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = entity;
    request.predicate = predicate;
    NSError *error = nil;
    NSArray *routes = [context executeFetchRequest:request error:&error];
    if (!routes) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return [routes lastObject];
}

+ (id)routeMatchingOrInsertingRouteRecord:(RouteRecord *)routeRecord managedObjectContext:(NSManagedObjectContext *)context {
    RouteManagedObject *routeManagedObject = [self routeMatchingRouteRecord:routeRecord managedObjectContext:context];
    if (!routeManagedObject) {
        routeManagedObject = [[self alloc] initWithRouteRecord:routeRecord insertIntoManagedObjectContext:context];
    }
    return routeManagedObject;
}

- (id)initWithRouteRecord:(RouteRecord *)routeRecord insertIntoManagedObjectContext:(NSManagedObjectContext *)context {
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:kEntityName inManagedObjectContext:context];
    self = [self initWithEntity:entityDescription insertIntoManagedObjectContext:context];
    if (self) {
        self.routeRecord = routeRecord;
        [self touch];
    }
    return self;
}

- (void)awakeFromInsert {
    [super awakeFromInsert];
    [self touch];
}

- (NSNumber *)isMonitoringProximityToTarget {
    if (!_isMonitoringProximityToTarget) {
        BOOL test = NO;
        for (DirectionManagedObject *direction in self.directions) {
            test = direction.monitorProximityToTarget;
            if (test) break;
        }
        _isMonitoringProximityToTarget = [NSNumber numberWithBool:test];
    }
    return _isMonitoringProximityToTarget;
}

- (void)setRouteRecord:(RouteRecord *)routeRecord {
    _routeRecord = routeRecord;
    self.routeId = routeRecord.routeId;
    [self deleteDirectionsInManagedObjectContext:self.managedObjectContext];
    [self.directions addObjectsFromArray:[self directionsInsertedIntoManagedObjectContext:self.managedObjectContext]];
}

- (RouteRecord *)routeRecord {
    if (!_routeRecord) {
        _routeRecord = [RouteRecord routeMatchingRouteId:self.routeId];
    }
    return _routeRecord;
}

- (DirectionManagedObject *)selectedDirection {
    return [self.directions objectAtIndex:self.selectedDirectionIndex];
}

- (NSArray *)headsigns {
    NSMutableArray *headsigns = [NSMutableArray arrayWithCapacity:[self.directions count]];
    for (DirectionManagedObject *direction in self.directions) {
        [headsigns addObject:[direction headsign]];
    }
    return [headsigns copy];
}

- (NSString *)name {
    return self.routeRecord.shortName;
}

- (void)touch {
    self.updatedAt = [NSDate date];
}

- (void)deleteDirectionsInManagedObjectContext:(NSManagedObjectContext *)context {
    for (DirectionManagedObject *managedObject in self.directions) {
        [context deleteObject:managedObject];
    }
}

- (NSArray *)directionsInsertedIntoManagedObjectContext:(NSManagedObjectContext *)context {
    NSArray *records = [DirectionRecord directionsBelongingToRoute:self.routeRecord];
    NSMutableArray *managedObjects = [NSMutableArray arrayWithCapacity:[records count]];
    for (DirectionRecord *record in records) {
        DirectionManagedObject *managedObject = [[DirectionManagedObject alloc] initWithDirectionRecord:record managedObjectContext:context];
        managedObject.routeManagedObject = self;
        [managedObjects addObject:managedObject];
    }
    return [managedObjects copy];
}

#pragma mark - DirectionManagedObjectDelegate

- (void)directionManagedObject:(DirectionManagedObject *)directionManagedObject didChangeMonitorProximityToTarget:(BOOL)monitorProximityToTarget {
    if (monitorProximityToTarget) [self touch];
    self.isMonitoringProximityToTarget = nil; // Clear cache
}

@end
