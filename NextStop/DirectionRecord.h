#import <Foundation/Foundation.h>

typedef enum {
    DirectionRecordRegularDirection,
    DirectionRecordGoofyDirection,
} DirectionRecordDirection;

@class RouteRecord;

@interface DirectionRecord : NSObject

@property (readonly) DirectionRecordDirection direction;
@property (readonly) NSString *headsign;
@property (readonly) NSInteger primaryKey;
@property (readonly) NSArray *stops;

+ (NSArray *)directionsBelongingToRoute:(RouteRecord *)route;
+ (id)directionMatchingPrimaryKey:(NSInteger)primaryKey;

@end
