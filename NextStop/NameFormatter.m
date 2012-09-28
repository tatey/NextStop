#import "NameFormatter.h"

@implementation NameFormatter

- (id)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        NSRange range;
        range = [name rangeOfString:@" at "];
        if (range.location != NSNotFound) {
            self.title = [name substringToIndex:range.location];
            self.subtitle = [NSString stringWithFormat:@"At %@", [name substringFromIndex:range.location + range.length]];
            return self;
        }
        range = [name rangeOfString:@" near "];
        if (range.location != NSNotFound) {
            self.title = [name substringToIndex:range.location];
            self.subtitle = [NSString stringWithFormat:@"Near %@", [name substringFromIndex:range.location + range.length]];
            return self;
        }
        range = [name rangeOfString:@", "];
        if (range.location != NSNotFound) {
            self.title = [name substringToIndex:range.location];
            self.subtitle = [NSString stringWithFormat:@"%@%@", [name substringToIndex:range.location + range.length], [[name substringToIndex:range.location + range.length +1] uppercaseString]];
            return self;
        }
        self.title = name;
        self.subtitle = nil;
    }
    return self;
}

@end
