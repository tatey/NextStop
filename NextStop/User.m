#import "Annotation.h"
#import "User.h"

@implementation User

@synthesize coordinate = _coordinate;
@synthesize routeCode = _routeCode;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate routeCode:(NSString *)routeCode {
    self = [self init];
    if (self) {
        self.coordinate = coordinate;
        self.routeCode = routeCode;
    }
    return self;
}

- (Annotation *)annotation {
    return [[Annotation alloc] initWithCoordinate:self.coordinate title:self.routeCode];
}

@end
