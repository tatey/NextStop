#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class DirectionManagedObject;

@interface DestinationManagedObject : NSManagedObject <MKAnnotation>

@property (copy, nonatomic) NSString *addressLine1;
@property (copy, nonatomic) NSString *addressLine2;
@property (strong, nonatomic) DirectionManagedObject *direction;
@property (assign, nonatomic) CLLocationDegrees latitude;
@property (assign, nonatomic) CLLocationDegrees longitude;

- (id)initWithPlacemark:(CLPlacemark *)placemark managedObjectContext:(NSManagedObjectContext *)context;

- (void)setPropertiesWithPlacemark:(CLPlacemark *)placemark;

@end
