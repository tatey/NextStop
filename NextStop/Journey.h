#import <Foundation/Foundation.h>

@class Route;
@class Stop;

@interface Journey : NSObject <NSCoding>

@property (readonly) NSArray *headings;
@property (assign, nonatomic, getter = isMonitoringProximityToTarget) BOOL monitorProximityToTarget;
@property (strong, nonatomic) Route *route;
@property (assign, nonatomic) NSInteger selectedHeadingIndex;
@property (readonly) NSArray *stops;
@property (strong, nonatomic) Stop *target;

- (id)initWithRoute:(Route *)route;

- (NSString *)name;

@end
