#import "DestinationManagedObject.h"
#import "DirectionManagedObject.h"
#import "DirectionRecord.h"
#import "DirectionShowViewController.h"
#import "NSObject+MKMapViewDelegate.h"
#import "RouteShowViewControllerItem.h"
#import "StopRecord.h"

static NSString *const kDirectionManagedObjectMonitorKeyPath = @"directionManagedObject.monitorProximityToTarget";

static NSString *NSStringFromMKCoordinateRegion(MKCoordinateRegion region) {
    return [NSString stringWithFormat:@"{{%f, %f}, {%f, %f}}", region.center.latitude, region.center.longitude, region.span.latitudeDelta, region.span.longitudeDelta];
}

@implementation DirectionShowViewController {
    __weak StopAnnotationView *_cachedStopAnnotationView;
}

@synthesize directionManagedObject = _directionManagedObject;
@synthesize geocoder = _geocoder;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize mapView = _mapView;
@synthesize modalSearchDisplayController = _modalSearchDisplayController;
@synthesize trackingBarButtonItem = _trackingBarButtonItem;

- (id)init {
    self = [super init];
    self.routeShowViewControllerItem = [[RouteShowViewControllerItem alloc] init];
    return self;
}

- (id)initWithDirectionManagedObject:(DirectionManagedObject *)directionManagedObject managedObjectContext:(NSManagedObjectContext *)context {
    self = [self init];
    if (self) {
        self.directionManagedObject = directionManagedObject;
        self.managedObjectContext = context;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Map view
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    [self.mapView addAnnotations:[self.directionManagedObject annotations]];
    [self.view addSubview:self.mapView];
    // Modal search display controller
    self.modalSearchDisplayController = [[ModalSearchDisplayController alloc] initWithViewController:self.parentViewController];
    self.modalSearchDisplayController.delegate = self;
    // Tracking bar button item
    self.trackingBarButtonItem = [[MKUserTrackingBarButtonItem alloc] initWithMapView:self.mapView];
    self.trackingBarButtonItem.target = self;
    self.trackingBarButtonItem.action = @selector(trackingBarButtonItemTapped:);
    self.routeShowViewControllerItem.leftBarButtonItem = self.trackingBarButtonItem;
    // Zoom
    if (self.directionManagedObject.target) {
        [self zoomToAnnotation:self.directionManagedObject.target animated:NO];
        if (!self.directionManagedObject.monitorProximityToTarget) {
            [self.mapView selectAnnotation:self.directionManagedObject.target animated:NO];
        }
    } else {
        [self zoomToAnnotations:[self.directionManagedObject stops] animated:NO];
    }
}

- (void)viewDidUnload {
    self.geocoder = nil;
    self.mapView = nil;
    self.modalSearchDisplayController = nil;
    self.trackingBarButtonItem = nil;
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addObserver:self forKeyPath:kDirectionManagedObjectMonitorKeyPath options:NSKeyValueObservingOptionNew context:@selector(directionManagedObjectMonitorDidChangeValue)];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self removeObserver:self forKeyPath:kDirectionManagedObjectMonitorKeyPath];
    [super viewWillDisappear:animated];
}

- (CLGeocoder *)geocoder {
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

- (void)searchBarButtonItemTapped:(UIBarButtonItem *)searchBarButtonItem {
    [self.modalSearchDisplayController setActive:YES animated:YES];
}

- (void)zoomToAnnotation:(id <MKAnnotation>)annotation animated:(BOOL)animated {
    MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
    MKCoordinateRegion region = MKCoordinateRegionMake(annotation.coordinate, span);
    [self.mapView setRegion:region animated:animated];
}

- (void)zoomToAnnotations:(NSArray *)annotations animated:(BOOL)animated {
    NSInteger count = 0;
    MKMapPoint points[[annotations count]];
    for (id <MKAnnotation> annotation in annotations) {
        points[count++] = MKMapPointForCoordinate(annotation.coordinate);
    }
    MKPolygon *polygon = [MKPolygon polygonWithPoints:points count:count];
    MKCoordinateRegion region = MKCoordinateRegionForMapRect([polygon boundingMapRect]);
    MKCoordinateSpan minimumSpan = MKCoordinateSpanMake(0.01, 0.01);
    if (region.span.latitudeDelta < minimumSpan.latitudeDelta && region.span.longitudeDelta < minimumSpan.longitudeDelta) {
        region.span = minimumSpan;
    }
    [self.mapView setRegion:region animated:animated];
}

#pragma mark - Actions

- (void)trackingBarButtonItemTapped:(MKUserTrackingBarButtonItem *)trackingBarButtonItem {
    if (self.mapView.userTrackingMode == MKUserTrackingModeNone) {
        [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    } else if (self.mapView.userTrackingMode == MKUserTrackingModeFollow) {
        [self.mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:YES];
    } else if (self.mapView.userTrackingMode == MKUserTrackingModeFollowWithHeading) {
        [self.mapView setUserTrackingMode:MKUserTrackingModeNone animated:NO];
        if (self.directionManagedObject.target) {
            [self zoomToAnnotation:self.directionManagedObject.target animated:YES];
        } else {
            [self zoomToAnnotations:[self.directionManagedObject stops] animated:YES];
        }
    }
}

#pragma mark - Notifications

- (void)directionManagedObjectMonitorDidChangeValue {
    [_cachedStopAnnotationView setMonitored:self.directionManagedObject.isMonitoringProximityToTarget animated:YES];
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didDeselectStopAnnotationView:(StopAnnotationView *)stopAnnotationView {
    [_cachedStopAnnotationView.superview bringSubviewToFront:_cachedStopAnnotationView];
}

- (void)mapView:(MKMapView *)mapView didSelectStopAnnotationView:(StopAnnotationView *)stopAnnotationView {
    if (_cachedStopAnnotationView == stopAnnotationView) return;
    [_cachedStopAnnotationView.superview sendSubviewToBack:_cachedStopAnnotationView];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForDestinationManagedObject:(DestinationManagedObject *)destination {
    static NSString *DestinationAnnotationViewReuseId = @"DestinationAnnotationView";
    DestinationAnnotationView *destinationAnnotationView = (DestinationAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:DestinationAnnotationViewReuseId];
    if (!destinationAnnotationView) {
        destinationAnnotationView = [[DestinationAnnotationView alloc] initWithAnnotation:destination reuseIdentifier:DestinationAnnotationViewReuseId];
        destinationAnnotationView.delegate = self;
    }
    return destinationAnnotationView;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForStopRecord:(StopRecord *)stopRecord {
    static NSString *ReuseId = @"StopAnnotationView";
    StopAnnotationView *stopAnnotationView = (StopAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ReuseId];
    if (!stopAnnotationView) {
        stopAnnotationView = [[StopAnnotationView alloc] initWithAnnotation:stopRecord reuseIdentifier:ReuseId];
        stopAnnotationView.delegate = self;
    }
    if ([stopRecord isEqualToStop:self.directionManagedObject.target]) {
        stopAnnotationView.targeted = YES;
        stopAnnotationView.monitored = self.directionManagedObject.isMonitoringProximityToTarget;
        _cachedStopAnnotationView = stopAnnotationView;
    } else {
        stopAnnotationView.monitored = NO;
        stopAnnotationView.targeted = NO;
    }
    return stopAnnotationView;
}

#pragma mark - DestinationAnnotationViewDelegate

- (void)destinationAnnotationView:(DestinationAnnotationView *)destinationAnnotationView deleteButtonTapped:(UIButton *)deleteButton {
    [self.mapView removeAnnotation:self.directionManagedObject.destination];
    [self.managedObjectContext deleteObject:self.directionManagedObject.destination];
    self.directionManagedObject.destination = nil;
}

#pragma mark - ModalSearchDisplayControllerDelegate

- (void)modalSearchDisplayController:(ModalSearchDisplayController *)controller didLoadSearchBar:(UISearchBar *)searchBar {
    searchBar.delegate = self;
    searchBar.placeholder = NSLocalizedString(@"direction.search.placeholder", nil);
}

#pragma mark - StopAnnotationViewDelegate

- (void)stopAnnotationView:(StopAnnotationView *)stopAnnotationView monitoredDidChangeValue:(BOOL)monitored {
    if (!stopAnnotationView.targeted) {
        _cachedStopAnnotationView.monitored = NO;
        _cachedStopAnnotationView.targeted = NO;
        _cachedStopAnnotationView = stopAnnotationView;
        stopAnnotationView.targeted = YES;
        self.directionManagedObject.target = (StopRecord *)stopAnnotationView.annotation;
    }
    self.directionManagedObject.monitorProximityToTarget = monitored;
}

#pragma mark UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.modalSearchDisplayController setActive:NO animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    UIApplication *application = [UIApplication sharedApplication];
    application.networkActivityIndicatorVisible = YES;
    [self.modalSearchDisplayController setActive:NO animated:YES];
    [self.geocoder geocodeAddressString:searchBar.text completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks lastObject];
        if (placemark) {
            DestinationManagedObject *destination = [[DestinationManagedObject alloc] initWithPlacemark:placemark managedObjectContext:self.managedObjectContext];
            StopRecord *stop = [self.directionManagedObject.direction stopClosestByLineOfSightToCoordinate:destination.coordinate];
            if (stop) {
                if (self.directionManagedObject.destination) {
                    [self.mapView removeAnnotation:self.directionManagedObject.destination];
                }
                [self.directionManagedObject replaceDestinationWithDestination:destination];
                [self.mapView addAnnotation:destination];
                [self zoomToAnnotations:@[destination, stop] animated:YES];
                [self.mapView selectAnnotation:stop animated:YES];
            } else {
                [self.managedObjectContext deleteObject:destination];
                NSLog(@"No stop");
            }
        } else {
            NSLog(@"%@", [error localizedDescription]);
        }
        application.networkActivityIndicatorVisible = NO;
    }];
}

@end
