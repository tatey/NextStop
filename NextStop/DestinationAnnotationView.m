#import "DestinationAnnotationView.h"

@implementation DestinationAnnotationView

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.animatesDrop = YES;
        self.canShowCallout = YES;
        self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.deleteButton setImage:[UIImage imageNamed:@"Close.png"] forState:UIControlStateNormal];
        [self.deleteButton addTarget:self action:@selector(deleteButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.deleteButton sizeToFit];
        self.rightCalloutAccessoryView = self.deleteButton;
    }
    return self;
}

- (void)deleteButtonTapped:(UIButton *)deleteButton {
    [self.delegate destinationAnnotationView:self deleteButtonTapped:deleteButton];
}

@end
