#import "ProximityManagedObject.h"
#import "ProximitySetManagedObject.h"

static NSString *const kEntityName = @"ProximitySet";

@implementation ProximitySetManagedObject

@dynamic proximities;

+ (id)proximitySetInManagedObjectContext:(NSManagedObjectContext *)context {
    NSEntityDescription *entity = [NSEntityDescription entityForName:kEntityName inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = entity;
    NSError *error = nil;
    NSArray *proximitySets = [context executeFetchRequest:request error:&error];
    if (!proximitySets) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    } else {
        if ([proximitySets count] > 0) {
            return [proximitySets lastObject];
        } else {
            return [[self alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
        }
    }
}

- (void)addProximity:(ProximityManagedObject *)proximity {
    proximity.proximitySet = self;
    [self.proximities addObject:proximity];
}

- (void)removeProximity:(ProximityManagedObject *)proximity {
    proximity.proximitySet = nil;
    [self.proximities removeObject:proximity];
}

- (NSInteger)count {
    return [self.proximities count];
}

@end
