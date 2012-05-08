#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <sqlite3.h>

@class Trip;

@interface Stop : NSObject <MKAnnotation>

@property (readonly) NSString *name;
@property (readonly) NSUInteger primaryKey;

+ (NSArray *)stopsBelongingToTrip:(Trip *)trip;

@end
