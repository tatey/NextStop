#import "StopAnnotationView.h"

@implementation StopAnnotationView

@synthesize targeted = _targeted;

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.canShowCallout = YES;
        self.targeted = NO;
    }
    return self;
}

- (void)setTargeted:(BOOL)targeted {
    _targeted = targeted;
    if (_targeted) {
        self.pinColor = MKPinAnnotationColorGreen;
    } else {
        self.pinColor = MKPinAnnotationColorRed;
    }
}

@end
