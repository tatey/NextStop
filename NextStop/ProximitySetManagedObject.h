#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

@class ProximityManagedObject;

@interface ProximitySetManagedObject : NSManagedObject

@property (copy, nonatomic) NSMutableSet *proximities;

+ (id)proximitySetInManagedObjectContext:(NSManagedObjectContext *)context;

- (void)addProximity:(ProximityManagedObject *)proximity;
- (void)removeProximity:(ProximityManagedObject *)proximity;

- (NSInteger)count;

@end
