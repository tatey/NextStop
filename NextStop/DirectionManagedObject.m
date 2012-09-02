#import "DirectionManagedObject.h"
#import "DirectionRecord.h"
#import "ProximityCenter.h"
#import "RouteManager.h"
#import "StopRecord.h"

#define RADIUS 500 // Meters

NSString *const DirectionManagedObjectDidApproachTargetNotification = @"me.nextstop.notifications.direction_managed_object.approach";

static NSString *const kEntityName = @"Direction";

static NSString *const kMonitorProximityToTargetKey = @"monitorProximityToTarget";

@interface DirectionManagedObject () {
@private
    __strong NSArray *_stops;
}

@property (strong, nonatomic) Proximity *proximity;

@property (assign, nonatomic) NSInteger directionId;
@property (assign, nonatomic) NSInteger targetId;

- (ProximityCenter *)proximityCenter;

- (void)startMonitoringProximityToTarget;
- (void)stopMonitoringProximityToTarget;

@end

@implementation DirectionManagedObject

// Public
@dynamic monitorProximityToTarget;
@dynamic routeManager;

@synthesize direction = _direction;
@synthesize target = _target;

// Private
@dynamic directionId;
@dynamic targetId;

@synthesize proximity = _proximity;

+ (void)startMonitoringProximityToTargetsInManagedObjectContext:(NSManagedObjectContext *)context {
    NSArray *directions = [self directionsMonitoringProximityToTargetInManagedObjectContext:context];
    for (DirectionManagedObject *direction in directions) {
        [direction startMonitoringProximityToTarget];
    }
}

+ (NSArray *)directionsMonitoringProximityToTargetInManagedObjectContext:(NSManagedObjectContext *)context {
    NSEntityDescription *entity = [NSEntityDescription entityForName:kEntityName inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"monitorProximityToTarget == %@", [NSNumber numberWithBool:YES]];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = entity;
    request.predicate = predicate;
    NSArray *directions = nil;
    NSError *error = nil;
    directions = [context executeFetchRequest:request error:&error];
    if (!directions) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return directions;
}

- (id)initWithDirection:(DirectionRecord *)direction managedObjectContext:(NSManagedObjectContext *)context {
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:kEntityName inManagedObjectContext:context];
    self = [self initWithEntity:entityDescription insertIntoManagedObjectContext:context];
    if (self) {
        self.direction = direction;
    }
    return self;
}

- (void)prepareForDeletion {
    self.monitorProximityToTarget = NO;
}

- (DirectionRecord *)direction {
    if (!_direction) {
        if (self.directionId) {
            _direction = [DirectionRecord directionMatchingPrimaryKey:self.directionId];
        }
    }
    return _direction;
}

- (void)setDirection:(DirectionRecord *)direction {
    _direction = direction;
    self.directionId = direction.primaryKey;
}

- (BOOL)isMonitoringProximityToTarget {
    [self willAccessValueForKey:kMonitorProximityToTargetKey];
    BOOL monitorProximityToTarget = [[self primitiveValueForKey:kMonitorProximityToTargetKey] boolValue];
    [self didAccessValueForKey:kMonitorProximityToTargetKey];
    return monitorProximityToTarget;
}

- (void)setMonitorProximityToTarget:(BOOL)monitorProximityToTarget {
    if (self.isMonitoringProximityToTarget == monitorProximityToTarget) return;
    [self willChangeValueForKey:kMonitorProximityToTargetKey];
    [self setPrimitiveValue:[NSNumber numberWithBool:monitorProximityToTarget] forKey:kMonitorProximityToTargetKey];
    [self.routeManager directionManagedObject:self didChangeMonitorProximityToTarget:monitorProximityToTarget];
    [self didChangeValueForKey:kMonitorProximityToTargetKey];
    if (monitorProximityToTarget) {
        [self startMonitoringProximityToTarget];
    } else {
        [self stopMonitoringProximityToTarget];
    }
}

- (StopRecord *)target {
    if (!_target) {
        if (self.targetId) {
            _target = [StopRecord stopMatchingPrimaryKey:self.targetId];
        }
    }
    return _target;
}

- (void)setTarget:(StopRecord *)target {
    _target = target;
    self.targetId = target.primaryKey;
    [self stopMonitoringProximityToTarget];
    [self startMonitoringProximityToTarget];
}

- (NSString *)headsign {
    return [self.direction localizedHeadsign];
}

- (NSArray *)stops {
    return self.direction.stops;
}

- (ProximityCenter *)proximityCenter {
    return [ProximityCenter defaultCenter];
}

- (void)startMonitoringProximityToTarget {
    if (!self.isMonitoringProximityToTarget || !self.target) return;
    self.proximity = [[Proximity alloc] initWithDelegate:self radius:RADIUS target:self.target.coordinate];
    [self.proximityCenter addProximity:self.proximity];
}

- (void)stopMonitoringProximityToTarget {
    [self.proximityCenter removeProximity:self.proximity];
    self.proximity = nil;
}

#pragma mark - ProximityDelegate

- (void)proximityDidApproachTarget:(Proximity *)proximity {
    self.monitorProximityToTarget = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:DirectionManagedObjectDidApproachTargetNotification object:self];
}

@end
