#import <Foundation/Foundation.h>

@class Route;

@interface RouteTracker : NSObject

@property (readonly) NSArray *directions;
@property (strong, nonatomic) Route *route;
@property (assign, nonatomic) NSInteger selectedDirectionIndex;
@property (readonly) NSArray *trips;

- (id)initWithRoute:(Route *)route;

- (NSString *)name;

@end
