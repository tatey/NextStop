#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@protocol StopAnnotationViewDelegate;

@interface StopAnnotationView : MKAnnotationView

@property (weak, nonatomic) id <StopAnnotationViewDelegate> delegate;
@property (assign, nonatomic, getter = isMonitored) BOOL monitored;
@property (assign, nonatomic, getter = isTargeted) BOOL targeted;

- (void)setMonitored:(BOOL)monitored animated:(BOOL)animated;

@end

@protocol StopAnnotationViewDelegate <NSObject>

- (void)stopAnnotationView:(StopAnnotationView *)stopAnnotationView monitoredDidChangeValue:(BOOL)monitored;

@end
