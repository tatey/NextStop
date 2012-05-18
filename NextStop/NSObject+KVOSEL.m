#import "NSObject+KVOSEL.h"

@implementation NSObject (KVOSEL)

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    #if defined (__clang__)
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    #endif
    [self performSelector:(SEL)context];
    #if defined (__clang__)
        #pragma clang diagnostic pop
    #endif
}

@end
