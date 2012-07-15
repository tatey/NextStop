#import "RouteRecord.h"
#import "RouteManager.h"
#import "TripRecord.h"
#import "TripTracker.h"

static NSString *const kDirectionsKey = @"directions";
static NSString *const kEntityName = @"Route";
static NSString *const kTripsKey = @"trips";
static NSString *const kTripTrackers = @"tripTrackers";

@interface RouteManager () {
@private
    __strong NSArray *_directions;
    __strong NSArray *_trips;
    __strong NSArray *_tripTrackers;
}

@property (assign, nonatomic) NSInteger routeId;

@end

@implementation RouteManager

@dynamic routeId;
@dynamic selectedDirectionIndex;
@dynamic updatedAt;

@synthesize directions = _directions;
@synthesize route = _route;
@synthesize trips = _trips;
@synthesize tripTrackers = _tripTrackers;

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

- (NSArray *)directions {
    if (!_directions) {
        NSMutableArray *directions = [NSMutableArray arrayWithCapacity:[self.trips count]];
        for (TripRecord *trip in self.trips) {
            NSString *direction = NSLocalizedString(TripRecordDirectionToLocalizableString(trip.direction), nil);
            [directions addObject:direction];
        }
        _directions = [directions copy];
    }
    return _directions;
}

- (NSArray *)trips {
    if (!_trips) {
        _trips = [self.route trips];
    }
    return _trips;
}

- (NSArray *)tripTrackers {
    if (!_tripTrackers) {
        NSMutableArray *tripTrackers = [NSMutableArray arrayWithCapacity:[self.trips count]];
        for (TripRecord *trip in self.trips) {
            TripTracker *tripTracker = [[TripTracker alloc] initWithTrip:trip];
            [tripTrackers addObject:tripTracker];
        }
        _tripTrackers = [tripTrackers copy];
    }
    return _tripTrackers;
}

- (RouteRecord *)route {
    if (!_route) {
        _route = [RouteRecord routeMatchingPrimaryKey:self.routeId];
    }
    return _route;
}

- (void)setRoute:(RouteRecord *)route {
    _route = route;
    self.routeId = route.primaryKey;
    [self willChangeValueForKey:kDirectionsKey];
    [self willChangeValueForKey:kTripsKey];
    [self willChangeValueForKey:kTripTrackers];
    _directions = nil; // Clear cache
    _trips = nil; // Clear cache
    _tripTrackers = nil; // Clear cache
    [self didChangeValueForKey:kDirectionsKey];
    [self didChangeValueForKey:kTripsKey];
    [self didChangeValueForKey:kTripTrackers];
}

- (NSString *)name {
    return self.route.shortName;
}

- (TripTracker *)selectedTripTracker {
    return [self.tripTrackers objectAtIndex:self.selectedDirectionIndex];
}

- (void)touch {
    self.updatedAt = [NSDate date];
}

@end
