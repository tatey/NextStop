#import "MKMapView+Google.h"

@implementation MKMapView (Google)

- (UIImageView *)googleLogo {
    UIImageView *imageView = nil;
    for (UIView *view in self.subviews) {
        if ([view isMemberOfClass:[UIImageView class]]) {
            imageView = (UIImageView *)view;
            break;
        }
    }
    return imageView;
}

@end
