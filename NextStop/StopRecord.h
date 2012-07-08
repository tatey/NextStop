#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class TripRecord;

@interface StopRecord : NSObject <MKAnnotation, NSCoding>

@property (readonly) NSString *name;
@property (readonly) NSUInteger primaryKey;

+ (NSArray *)stopsBelongingToTrip:(TripRecord *)trip;

@end
