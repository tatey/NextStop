#import <Foundation/Foundation.h>
#import "Proximity.h"

extern NSString *const JourneyDidApproachTargetNotification;

@class Route;
@class Stop;

@interface Journey : NSObject <NSCoding, ProximityDelegate>

@property (readonly) NSArray *directions;
@property (assign, nonatomic) BOOL monitorProximityToTarget;
@property (strong, nonatomic) Route *route;
@property (assign, nonatomic) NSInteger selectedDirectionIndex;
@property (readonly) NSArray *stops;
@property (strong, nonatomic) Stop *target;

- (id)initWithRoute:(Route *)route;

- (NSString *)name;

@end
