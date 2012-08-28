#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface StopAnnotationView : MKPinAnnotationView

@property (assign, nonatomic, getter = isMonitored) BOOL monitored;
@property (assign, nonatomic, getter = isTargeted) BOOL targeted;

- (void)setMonitored:(BOOL)monitored animated:(BOOL)animated;

@end

@end
