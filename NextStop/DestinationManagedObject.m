#import "DestinationManagedObject.h"

static NSString *const kEntityName = @"Destination";

@implementation DestinationManagedObject

@dynamic addressLine1;
@dynamic addressLine2;
@dynamic direction;
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
    NSArray *addressLines = [placemark.addressDictionary valueForKey:@"FormattedAddressLines"];
    self.addressLine1 = [addressLines objectAtIndex:0];
    self.addressLine2 = [addressLines objectAtIndex:1];
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
    return self.addressLine1;
}

- (NSString *)subtitle {
    return self.addressLine2;
}

@end
