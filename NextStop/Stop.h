#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <sqlite3.h>

@class Route;

@interface Stop : NSObject <MKAnnotation> {
@private 
    CLLocationDegrees _latitude;
    CLLocationDegrees _longitude;
    NSString *_name;
    NSUInteger _primaryKey;
}

@property (readonly) NSString *name;
@property (readonly) NSUInteger primaryKey;

+ (NSArray *)stopsMatchingRoute:(Route *)route;

- (id)initWithStatement:(sqlite3_stmt *)stmt;

@end
