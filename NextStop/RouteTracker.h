#import <Foundation/Foundation.h>

@class Route;
@class TripTracker;

@interface RouteTracker : NSObject

@property (readonly) NSArray *directions;
@property (strong, nonatomic) Route *route;
@property (assign, nonatomic) NSInteger selectedDirectionIndex;
@property (readonly) NSArray *trips;
@property (readonly) NSArray *tripTrackers;

- (id)initWithRoute:(Route *)route;

- (NSString *)name;
- (TripTracker *)selectedTripTracker;

@end
