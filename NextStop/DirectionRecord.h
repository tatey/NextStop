#import <Foundation/Foundation.h>

#define DIRECTION_RECORD_MAX_STOP_DISTANCE_METERS 10000

typedef enum {
    DirectionRecordRegularDirection,
    DirectionRecordGoofyDirection,
} DirectionRecordDirection;

@class StopRecord;
@class RouteRecord;

@interface DirectionRecord : NSObject

@property (readonly) DirectionRecordDirection direction;
@property (readonly) NSString *headsign;
@property (readonly) NSInteger primaryKey;
@property (readonly) NSArray *stops;

+ (NSArray *)directionsBelongingToRoute:(RouteRecord *)route;
+ (id)directionMatchingPrimaryKey:(NSInteger)primaryKey;

- (StopRecord *)stopClosestByLineOfSightToCoordinate:(CLLocationCoordinate2D)coordinate;
- (NSString *)localizedHeadsign;

@end
