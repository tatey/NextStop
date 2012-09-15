#import "DestinationAnnotationView.h"

@implementation DestinationAnnotationView

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.animatesDrop = YES;
        self.canShowCallout = YES;
    }
    return self;
}

@end
