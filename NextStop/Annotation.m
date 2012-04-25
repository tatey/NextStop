#import "Annotation.h"

static NSString *const kCoordinateKey = @"coordinate";
static NSString *const kTitleKey = @"title";

@implementation Annotation

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title {
    self = [self init];
    if (self) {
        self.coordinate = coordinate;
        self.title = title;
    }
    return self;
}

- (CLLocationCoordinate2D)coordinate {
    return _coordinate;
}

- (void)setCoordinate:(CLLocationCoordinate2D)coordinate {
    [self willChangeValueForKey:kCoordinateKey];
    _coordinate = coordinate;
    [self didChangeValueForKey:kCoordinateKey];
}

- (NSString *)title {
    return _title;
}

- (void)setTitle:(NSString *)title {
    [self willChangeValueForKey:kTitleKey];
    _title = title;
    [self didChangeValueForKey:kTitleKey];
}

@end
