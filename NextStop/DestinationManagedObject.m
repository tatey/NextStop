#import "DestinationManagedObject.h"

static NSString *const kEntityName = @"Destination";

@implementation DestinationManagedObject

@dynamic direction;
@dynamic formattedAddress;
@dynamic latitude;
@dynamic longitude;

- (id)initWithPlacemark:(CLPlacemark *)placemark managedObjectContext:(NSManagedObjectContext *)context {
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:kEntityName inManagedObjectContext:context];
    self = [self initWithEntity:entityDescription insertIntoManagedObjectContext:context];
    if (self) {
        [self setPropertiesWithPlacemark:placemark];
    }
    return self;
}

- (void)setPropertiesWithPlacemark:(CLPlacemark *)placemark {
    [self setCoordinate:placemark.location.coordinate];
    self.formattedAddress = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
}

#pragma mark - MKAnnotation

- (CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake(self.latitude, self.longitude);
}

- (void)setCoordinate:(CLLocationCoordinate2D)coordinate {
    self.latitude = coordinate.latitude;
    self.longitude = coordinate.longitude;
}

- (NSString *)title {
    return NSLocalizedString(@"destination_managed_object.title", nil);
}

- (NSString *)subtitle {
    return self.formattedAddress;
}

@end
