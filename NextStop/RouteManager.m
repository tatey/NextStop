#import "DirectionManagedObject.h"
#import "DirectionRecord.h"
#import "RouteRecord.h"
#import "RouteManager.h"

static NSString *const kEntityName = @"Route";

static NSString *const kDirectionsKey = @"directions";
static NSString *const kSelectedDirectionKey = @"selectedDirection";

@interface RouteManager ()

@property (assign, nonatomic) NSInteger routeId;

@end

@implementation RouteManager

// Public
@dynamic directions;
@dynamic selectedDirection;
@dynamic updatedAt;

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

- (NSMutableOrderedSet *)directions {
    [self willAccessValueForKey:kDirectionsKey];
    NSMutableOrderedSet *directions = [self mutableOrderedSetValueForKey:kDirectionsKey];
    [self didAccessValueForKey:kDirectionsKey];
    if ([directions count] == 0) {
        NSArray *records = [DirectionRecord directionsBelongingToRoute:self.route];
        for (DirectionRecord *record in records) {
            DirectionManagedObject *managedObject = [[DirectionManagedObject alloc] initWithDirection:record managedObjectContext:self.managedObjectContext];
            [directions addObject:managedObject];
        }
    }
    return directions;
}

- (void)buildDirections:(NSManagedObjectContext *)context {
    NSArray *records = [DirectionRecord directionsBelongingToRoute:self.route];
    for (DirectionRecord *record in records) {
        DirectionManagedObject *managedObject = [[DirectionManagedObject alloc] initWithDirection:record managedObjectContext:self.managedObjectContext];
        [self.directions addObject:managedObject];
    }
}

- (void)setRoute:(RouteRecord *)route {
    _route = route;
    self.routeId = route.primaryKey;
    // TODO: Delete directions
}

- (RouteRecord *)route {
    if (!_route) {
        _route = [RouteRecord routeMatchingPrimaryKey:self.routeId];
    }
    return _route;
}

- (DirectionManagedObject *)selectedDirection {
    [self willAccessValueForKey:kSelectedDirectionKey];
    DirectionManagedObject *selectedDirection = [self primitiveValueForKey:kSelectedDirectionKey];
    [self didAccessValueForKey:kSelectedDirectionKey];
    if (!selectedDirection) {
        selectedDirection = [self.directions lastObject];
        [self setPrimitiveValue:selectedDirection forKey:kSelectedDirectionKey];
    }
    return selectedDirection;
}

- (NSArray *)headsigns {
    NSMutableArray *headsigns = [NSMutableArray arrayWithCapacity:[self.directions count]];
    for (DirectionManagedObject *direction in self.directions) {
        [headsigns addObject:[direction headsign]];
    }
    return [headsigns copy];
}

- (NSUInteger)indexOfDirection:(DirectionManagedObject *)direction {
    return [self.directions indexOfObject:direction];
}

- (NSUInteger)indexOfSelectedDirection {
    return [self indexOfDirection:self.selectedDirection];
}

- (void)setDirectionAtIndex:(NSUInteger)index {
    self.selectedDirection = [self.directions objectAtIndex:index];
}

- (NSString *)name {
    return self.route.shortName;
}

- (void)touch {
    self.updatedAt = [NSDate date];
}

@end
