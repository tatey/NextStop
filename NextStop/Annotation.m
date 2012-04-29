#import "Annotation.h"

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
    _coordinate = coordinate;
}

- (NSString *)title {
    return _title;
}

- (void)setTitle:(NSString *)title {
    _title = title;
}

@end
