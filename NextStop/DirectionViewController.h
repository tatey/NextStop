#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "StopAnnotationView.h"
#import "TrackButton.h"

@class DirectionManagedObject;
@class RouteViewControllerItem;
@class TrackButton;

@interface DirectionViewController : UIViewController <MKMapViewDelegate, StopAnnotationViewDelegate, TrackButtonDelegate>

@property (strong, nonatomic) DirectionManagedObject *directionManagedObject;
@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) RouteViewControllerItem *routeViewControllerItem;
@property (strong, nonatomic) TrackButton *trackButton;

- (id)initWithDirectionManagedObject:(DirectionManagedObject *)directionManagedObject;

@end
