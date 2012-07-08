#import <Foundation/Foundation.h>

@class RouteRecord;
@class TripTracker;

@interface RouteManager : NSObject

@property (readonly) NSArray *directions;
@property (strong, nonatomic) RouteRecord *route;
@property (assign, nonatomic) NSInteger selectedDirectionIndex;
@property (readonly) NSArray *trips;
@property (readonly) NSArray *tripTrackers;

- (id)initWithRoute:(RouteRecord *)route;

- (NSString *)name;
- (TripTracker *)selectedTripTracker;

@end
