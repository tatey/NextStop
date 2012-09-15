#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ModalSearchDisplayController.h"
#import "StopAnnotationView.h"
#import "TrackButton.h"

@class DirectionManagedObject;
@class RouteViewControllerItem;
@class TrackButton;

@interface DirectionViewController : UIViewController <ModalSearchDisplayControllerDelegate, MKMapViewDelegate, StopAnnotationViewDelegate, TrackButtonDelegate, UISearchBarDelegate>

@property (strong, nonatomic) DirectionManagedObject *directionManagedObject;
@property (strong, nonatomic) CLGeocoder *geocoder;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) ModalSearchDisplayController *modalSearchDisplayController;
@property (strong, nonatomic) RouteViewControllerItem *routeViewControllerItem;
@property (strong, nonatomic) TrackButton *trackButton;

- (id)initWithDirectionManagedObject:(DirectionManagedObject *)directionManagedObject managedObjectContext:(NSManagedObjectContext *)context;

- (void)searchBarButtonItemTapped:(UIBarButtonItem *)searchBarButtonItem;

@end
