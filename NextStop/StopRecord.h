#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class DirectionRecord;

@interface StopRecord : NSObject <MKAnnotation>

@property (readonly) NSString *name;
@property (readonly) NSString *stopId;

+ (NSArray *)stopsBelongingToDirection:(DirectionRecord *)direction;
+ (NSArray *)stopsBelongingToDirection:(DirectionRecord *)direction likeName:(NSString *)name;
+ (id)stopMatchingStopId:(NSString *)stopId;

- (BOOL)isEqualToStop:(StopRecord *)stop;

@end
