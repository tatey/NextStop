#import "DirectionManagedObject.h"
#import "DirectionRecord.h"
#import "RouteRecord.h"
#import "RouteManager.h"

static NSString *const kEntityName = @"Route";

@interface RouteManager ()

@property (assign, nonatomic) NSNumber *isMonitoringProximityToTarget;
@property (assign, nonatomic) NSInteger routeId;

@end

@implementation RouteManager

// Public
@dynamic directions;
@dynamic selectedDirectionIndex;
@dynamic updatedAt;

@synthesize isMonitoringProximityToTarget = _isMonitoringProximityToTarget;
@synthesize route = _route;

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

+ (id)routeMatchingRoute:(RouteRecord *)route managedObjectContext:(NSManagedObjectContext *)context {
    NSEntityDescription *entity = [NSEntityDescription entityForName:kEntityName inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"routeId == %d", route.primaryKey];
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

+ (id)routeMatchingOrInsertingRoute:(RouteRecord *)route managedObjectContext:(NSManagedObjectContext *)context {
    RouteManager *routeManager = [self routeMatchingRoute:route managedObjectContext:context];
    if (!routeManager) {
        routeManager = [[self alloc] initWithRoute:route insertIntoManagedObjectContext:context];
    }
    return routeManager;
}

- (id)initWithRoute:(RouteRecord *)route insertIntoManagedObjectContext:(NSManagedObjectContext *)context {
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:kEntityName inManagedObjectContext:context];
    self = [self initWithEntity:entityDescription insertIntoManagedObjectContext:context];
    if (self) {
        self.route = route;
        [self touch];
    }
    return self;
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

- (void)setRoute:(RouteRecord *)route {
    _route = route;
    self.routeId = route.primaryKey;
    [self deleteDirectionsInManagedObjectContext:self.managedObjectContext];
    [self.directions addObjectsFromArray:[self directionsInsertedIntoManagedObjectContext:self.managedObjectContext]];
}

- (RouteRecord *)route {
    if (!_route) {
        _route = [RouteRecord routeMatchingPrimaryKey:self.routeId];
    }
    return _route;
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
    return self.route.shortName;
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
    NSArray *records = [DirectionRecord directionsBelongingToRoute:self.route];
    NSMutableArray *managedObjects = [NSMutableArray arrayWithCapacity:[records count]];
    for (DirectionRecord *record in records) {
        DirectionManagedObject *managedObject = [[DirectionManagedObject alloc] initWithDirection:record managedObjectContext:context];
        managedObject.routeManager = self;
        [managedObjects addObject:managedObject];
    }
    return [managedObjects copy];
}

#pragma mark - DirectionManagedObjectDelegate

- (void)directionManagedObject:(DirectionManagedObject *)directionManagedObject didChangeMonitorProximityToTarget:(BOOL)monitorProximityToTarget {
    self.isMonitoringProximityToTarget = nil; // Clear cache
}

@end
