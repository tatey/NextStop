#import <Foundation/Foundation.h>
#import "Proximity.h"

extern NSString *const JourneyDidApproachTargetNotification;

@class Route;
@class Stop;

@interface Journey : NSObject <NSCoding, ProximityDelegate>

@property (readonly) NSArray *headings;
@property (assign, nonatomic) BOOL monitorProximityToTarget;
@property (strong, nonatomic) Route *route;
@property (assign, nonatomic) NSInteger selectedHeadingIndex;
@property (readonly) NSArray *stops;
@property (strong, nonatomic) Stop *target;

- (id)initWithRoute:(Route *)route;

- (NSString *)name;

@end
