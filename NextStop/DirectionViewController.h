#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "DestinationAnnotationView.h"
#import "ModalSearchDisplayController.h"
#import "StopAnnotationView.h"
#import "TrackButton.h"

@class DirectionManagedObject;
@class RouteShowViewControllerItem;
@class TrackButton;

@interface DirectionViewController : UIViewController <DestionationAnnotationViewDelegate, ModalSearchDisplayControllerDelegate, MKMapViewDelegate, StopAnnotationViewDelegate, TrackButtonDelegate, UISearchBarDelegate>

@property (strong, nonatomic) DirectionManagedObject *directionManagedObject;
@property (strong, nonatomic) CLGeocoder *geocoder;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) ModalSearchDisplayController *modalSearchDisplayController;
@property (strong, nonatomic) RouteShowViewControllerItem *routeShowViewControllerItem;
@property (strong, nonatomic) TrackButton *trackButton;

- (id)initWithDirectionManagedObject:(DirectionManagedObject *)directionManagedObject managedObjectContext:(NSManagedObjectContext *)context;

- (void)searchBarButtonItemTapped:(UIBarButtonItem *)searchBarButtonItem;

@end
