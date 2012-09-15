#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@protocol DestionationAnnotationViewDelegate;

@interface DestinationAnnotationView : MKPinAnnotationView

@property (weak, nonatomic) id <DestionationAnnotationViewDelegate> delegate;
@property (strong, nonatomic) UIButton *deleteButton;

@end

@protocol DestionationAnnotationViewDelegate <NSObject>

- (void)destinationAnnotationView:(DestinationAnnotationView *)destinationAnnotationView deleteButtonTapped:(UIButton *)deleteButton;

@end
