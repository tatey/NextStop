#import "DestinationAnnotationView.h"

@implementation DestinationAnnotationView

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.animatesDrop = YES;
        self.canShowCallout = YES;
        self.deleteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.deleteButton.frame = CGRectMake(0, 0, 32, 32);
        [self.deleteButton addTarget:self action:@selector(deleteButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        self.leftCalloutAccessoryView = self.deleteButton;
    }
    return self;
}

- (void)deleteButtonTapped:(UIButton *)deleteButton {
    [self.delegate destinationAnnotationView:self deleteButtonTapped:deleteButton];
}

@end
