#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class Trip;

@interface Stop : NSObject <MKAnnotation, NSCoding>

@property (readonly) NSString *name;
@property (readonly) NSUInteger primaryKey;

+ (NSArray *)stopsBelongingToTrip:(Trip *)trip;

@end
