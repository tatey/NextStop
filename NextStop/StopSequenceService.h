#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

@class DirectionRecord;
@class StopRecord;

@interface StopSequenceService : NSObject

+ (CLLocationDistance)distanceBetweenClosestPreviouStopFromStop:(StopRecord *)stop inDirection:(DirectionRecord *)direction;
+ (CLLocationDistance)notificationDistanceFromRawDistance:(CLLocationDistance)rawDistance;

+ (NSArray *)previousStopsFromStop:(StopRecord *)stop inDirection:(DirectionRecord *)direction;

@end
