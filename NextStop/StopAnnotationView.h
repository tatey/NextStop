#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface StopAnnotationView : MKPinAnnotationView

@property (assign, nonatomic, getter = isTargeted) BOOL targeted;

@end
