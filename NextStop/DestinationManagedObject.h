#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class DirectionManagedObject;

@interface DestinationManagedObject : NSManagedObject <MKAnnotation>

@property (strong, nonatomic) DirectionManagedObject *direction;
@property (copy, nonatomic) NSString *formattedAddress;
@property (assign, nonatomic) CLLocationDegrees latitude;
@property (assign, nonatomic) CLLocationDegrees longitude;

- (id)initWithPlacemark:(CLPlacemark *)placemark managedObjectContext:(NSManagedObjectContext *)context;

- (void)setPropertiesWithPlacemark:(CLPlacemark *)placemark;

@end
