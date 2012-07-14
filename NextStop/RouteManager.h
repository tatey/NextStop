#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

@class RouteRecord;
@class TripTracker;

@interface RouteManager : NSManagedObject

@property (readonly) NSArray *directions;
@property (strong, nonatomic) RouteRecord *route;
@property (assign, nonatomic) NSInteger selectedDirectionIndex;
@property (readonly) NSArray *trips;
@property (readonly) NSArray *tripTrackers;
@property (strong, nonatomic) NSDate *updatedAt;

+ (NSFetchedResultsController *)routesInManagedObjectContext:(NSManagedObjectContext *)context sectionNameKeyPath:(NSString *)sectionNameKeyPath cacheName:(NSString *)name;

- (id)initWithRoute:(RouteRecord *)route insertIntoManagedObjectContext:(NSManagedObjectContext *)context;

- (NSString *)name;
- (TripTracker *)selectedTripTracker;

@end
