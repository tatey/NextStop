#import "AppDelegate.h"
#import "CoordinateRegion.h"
#import "DestinationManagedObject.h"
#import "DirectionManagedObject.h"
#import "DirectionRecord.h"
#import "RouteManagedObject.h"
#import "ProximityManager.h"
#import "ProximityManagedObject.h"
#import "Strings.h"
#import "StopRecord.h"

#define NOTIFICATION_RADIUS 500 // Meters
#define PRECISION_RADIUS 5000 // Meters

static NSString *const kEntityName = @"Direction";

static NSString *const kMonitorProximityToTargetKey = @"monitorProximityToTarget";

@interface DirectionManagedObject () {
@private
    __strong NSArray *_stops;
}

@property (strong, nonatomic) ProximityManagedObject *proximity;

@property (assign, nonatomic) NSNumber *direction;
@property (assign, nonatomic) CLLocationDegrees latitude;
@property (assign, nonatomic) CLLocationDegrees longitude;
@property (assign, nonatomic) CLLocationDegrees latitudeDelta;
@property (assign, nonatomic) CLLocationDegrees longitudeDelta;
@property (copy, nonatomic) NSString *routeId;
@property (copy, nonatomic) NSString *targetId;

- (void)startMonitoringProximityToTarget;
- (void)stopMonitoringProximityToTarget;

@end

@implementation DirectionManagedObject

// Public
@dynamic destination;
@dynamic monitorProximityToTarget;
@dynamic routeManagedObject;

@synthesize directionRecord = _directionRecord;
@synthesize target = _target;

// Private
@dynamic direction;
@dynamic latitude;
@dynamic longitude;
@dynamic latitudeDelta;
@dynamic longitudeDelta;
@dynamic proximity;
@dynamic routeId;
@dynamic targetId;

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

- (id)initWithDirectionRecord:(DirectionRecord *)directionRecord managedObjectContext:(NSManagedObjectContext *)context {
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:kEntityName inManagedObjectContext:context];
    self = [self initWithEntity:entityDescription insertIntoManagedObjectContext:context];
    if (self) {
        self.directionRecord = directionRecord;
    }
    return self;
}

- (void)prepareForDeletion {
    self.monitorProximityToTarget = NO;
}

- (DirectionRecord *)directionRecord {
    if (!_directionRecord) {
        if (self.direction && self.routeId) {
            _directionRecord = [DirectionRecord directionMatchingDirection:[self.direction integerValue] routeId:self.routeId];
        }
    }
    return _directionRecord;
}

- (void)setDirectionRecord:(DirectionRecord *)directionRecord {
    _directionRecord = directionRecord;
    self.direction = [NSNumber numberWithInteger:directionRecord.direction];
    self.routeId = directionRecord.routeId;
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
    [self.routeManagedObject directionManagedObject:self didChangeMonitorProximityToTarget:monitorProximityToTarget];
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
            _target = [StopRecord stopMatchingStopId:self.targetId];
        }
    }
    return _target;
}

- (void)setTarget:(StopRecord *)target {
    _target = target;
    self.targetId = target.stopId;
    if (self.monitorProximityToTarget) {
        [self stopMonitoringProximityToTarget];
        [self startMonitoringProximityToTarget];
    }
}

- (void)replaceDestinationWithDestination:(DestinationManagedObject *)destination {
    if (self.destination) {
        [self.managedObjectContext deleteObject:self.destination];
    }
    destination.direction = self;
    self.destination = destination;
}

- (NSArray *)annotations {
    NSArray *annotations = [self stops];
    if (self.destination) {
        annotations = [annotations arrayByAddingObject:self.destination];
    }
    return annotations;
}

- (NSString *)headsign {
    return [self.directionRecord localizedHeadsign];
}

- (NSArray *)stops {
    return self.directionRecord.stops;
}

- (void)setRegion:(MKCoordinateRegion)region {
    self.latitude = region.center.latitude;
    self.longitude = region.center.longitude;
    self.latitudeDelta = region.span.latitudeDelta;
    self.longitudeDelta = region.span.longitudeDelta;
}

- (MKCoordinateRegion)region {
    if (!self.latitude || !self.longitude || !self.latitudeDelta || !self.longitudeDelta) {
        [self setRegion:MKCoordinateRegionForAnnotations([self stops])];
    }
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    MKCoordinateSpan span = MKCoordinateSpanMake(self.latitudeDelta, self.longitudeDelta);
    return MKCoordinateRegionMake(centerCoordinate, span);
}

- (void)startMonitoringProximityToTarget {
    if (!self.isMonitoringProximityToTarget || !self.target) return;
    self.proximity = [[ProximityManagedObject alloc] initWithDirectionManagedObject:self target:self.target.coordinate notificationRadius:NOTIFICATION_RADIUS precisionRadius:PRECISION_RADIUS identifier:[self identifier] managedObjectContext:self.managedObjectContext];
    [UIAppDelegate.proximityManager startMonitoringProximity:self.proximity];
}

- (void)stopMonitoringProximityToTarget {
    [UIAppDelegate.proximityManager stopMonitoringProximity:self.proximity];
    [self.managedObjectContext deleteObject:self.proximity];
    self.proximity = nil;
}

- (void)proximityDidApproachTarget {
    self.monitorProximityToTarget = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:NXDirectionManagedObjectDidApproachTargetNotification object:self];
}

- (NSString *)identifier {
    return [NSString stringWithFormat:@"me.nextstop.direction.%@.%@", self.directionRecord.headsign, self.directionRecord.routeId];
}

@end
