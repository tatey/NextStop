#import <Foundation/Foundation.h>

@class Route;
@class Stop;

@interface Journey : NSObject

@property (strong, nonatomic) Stop *destination;
@property (strong, nonatomic) Route *route;
@property (readonly) NSArray *stops;

- (id)initWithRoute:(Route *)route;

@end