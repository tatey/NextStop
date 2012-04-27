#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import <sqlite3.h>

@class Annotation;
@class Route;

@interface Stop : NSObject {
@private 
    CLLocationDegrees _latitude;
    CLLocationDegrees _longitude;
    NSString *_name;
    NSUInteger _primaryKey;
}

@property (readonly) CLLocationCoordinate2D coordinate;
@property (readonly) NSString *name;
@property (readonly) NSUInteger primaryKey;

+ (NSArray *)stopsMatchingRoute:(Route *)route;

- (id)initWithStatement:(sqlite3_stmt *)stmt;

- (Annotation *)annotation;

@end
