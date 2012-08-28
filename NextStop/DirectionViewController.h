#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "StopAnnotationView.h"

@class DirectionManagedObject;

@interface DirectionViewController : UIViewController <MKMapViewDelegate, StopAnnotationViewDelegate>

@property (strong, nonatomic) DirectionManagedObject *directionManagedObject;
@property (strong, nonatomic) MKMapView *mapView;

- (id)initWithDirectionManagedObject:(DirectionManagedObject *)directionManagedObject;

@end
