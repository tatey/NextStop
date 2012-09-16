#include <stdlib.h>
#import "NSArray+Random.h"

@implementation NSArray (Random)

- (id)objectAtRandomIndex {
    NSInteger index = arc4random() % [self count];
    return [self objectAtIndex:index];
}

@end
