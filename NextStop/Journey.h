#import <Foundation/Foundation.h>

@class Stop;
@class Trip;

@interface Journey : NSObject

@property (strong, nonatomic) Stop *destination;
@property (strong, nonatomic) Trip *trip;
@property (readonly) NSArray *stops;

- (id)initWithTrip:(Trip *)trip;

@end
