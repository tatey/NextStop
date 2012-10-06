#import "DirectionManagedObject.h"
#import "Haversin.h"
#import "ProximityManagedObject.h"

static NSString *const kEntityName = @"Proximity";

static NSString *const kDirectionKey = @"direction";
static NSString *const kIdentifierKey = @"identifier";
static NSString *const kLatitudeKey = @"latitude";
static NSString *const kLongitudeKey = @"longitude";
static NSString *const kNotificationRadiusKey = @"notificationRadius";
static NSString *const kPrecisionRadiusKey = @"precisionRadius";

@implementation ProximityManagedObject

@dynamic direction;
@dynamic identifier;
@dynamic notificationRadius;
@dynamic precisionRadius;
@dynamic proximitySet;

+ (id)proximityMatchingIdentifier:(NSString *)identifier managedObjectContext:(NSManagedObjectContext *)context {
    NSEntityDescription *entity = [NSEntityDescription entityForName:kEntityName inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier == %@", identifier];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = entity;
    request.predicate = predicate;
    request.includesPendingChanges = YES;
    NSError *error = nil;
    NSArray *proximities = [context executeFetchRequest:request error:&error];
    if (!proximities) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return [proximities lastObject];
}

- (id)initWithDirectionManagedObject:(DirectionManagedObject *)direction target:(CLLocationCoordinate2D)target notificationRadius:(CLLocationDistance)notificationRadius precisionRadius:(CLLocationDistance)precisionRadius identifier:(NSString *)identifier managedObjectContext:(NSManagedObjectContext *)context {
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:kEntityName inManagedObjectContext:context];
    self = [self initWithEntity:entityDescription insertIntoManagedObjectContext:context];
    if (self) {
        [self setValue:direction forKey:kDirectionKey];
        [self setValue:identifier forKey:kIdentifierKey];
        [self setValue:[NSNumber numberWithDouble:target.latitude] forKey:kLatitudeKey];
        [self setValue:[NSNumber numberWithDouble:target.longitude] forKey:kLongitudeKey];
        [self setValue:[NSNumber numberWithDouble:notificationRadius] forKey:kNotificationRadiusKey];
        [self setValue:[NSNumber numberWithDouble:precisionRadius] forKey:kPrecisionRadiusKey];
    }
    return self;
}

- (CLLocationCoordinate2D)target {
    CLLocationDegrees latitude = [[self valueForKey:kLatitudeKey] doubleValue];
    CLLocationDegrees longitude = [[self valueForKey:kLongitudeKey] doubleValue];
    return CLLocationCoordinate2DMake(latitude, longitude);
}

- (void)setTarget:(CLLocationCoordinate2D)target {
    [self setPrimitiveValue:[NSNumber numberWithDouble:target.latitude] forKey:kLatitudeKey];
    [self setPrimitiveValue:[NSNumber numberWithDouble:target.longitude] forKey:kLongitudeKey];
}

- (BOOL)notificationRadiusContainsCoordinate:(CLLocationCoordinate2D)coordinate {
    return Haversin(coordinate, self.target) <= self.notificationRadius;
}

- (BOOL)precisionRadiusContainsCoordinate:(CLLocationCoordinate2D)coordinate {
    return Haversin(coordinate, self.target) <= self.precisionRadius;
}

- (CLRegion *)precisionRegion {
    return [[CLRegion alloc] initCircularRegionWithCenter:self.target radius:self.precisionRadius identifier:self.identifier];
}

- (void)targetContainedWithinNotificationRadius {
    [self.direction proximityDidApproachTarget];
}

@end
