#import "DirectionManagedObject.h"
#import "DirectionViewController.h"
#import "NSObject+MKMapViewDelegate.h"
#import "RouteViewControllerItem.h"
#import "StopRecord.h"

static NSString *const kDirectionManagedObjectMonitorKeyPath = @"directionManagedObject.monitorProximityToTarget";

static NSString *NSStringFromMKCoordinateRegion(MKCoordinateRegion region) {
    return [NSString stringWithFormat:@"{{%f, %f}, {%f, %f}}", region.center.latitude, region.center.longitude, region.span.latitudeDelta, region.span.longitudeDelta];
}

static BOOL MKCoordinateRegionCompare(MKCoordinateRegion a, MKCoordinateRegion b) {
    return a.center.latitude == b.center.latitude && a.center.longitude == b.center.longitude &&
        a.span.latitudeDelta == b.span.latitudeDelta && a.span.longitudeDelta == b.span.longitudeDelta;
}

@implementation DirectionViewController {
    __weak StopAnnotationView *_cachedStopAnnotationView;
    MKCoordinateRegion _targetRegion;
}

@synthesize directionManagedObject = _directionManagedObject;
@synthesize mapView = _mapView;
@synthesize modalSearchDisplayController = _modalSearchDisplayController;
@synthesize trackButton = _trackButton;

- (id)init {
    self = [super init];
    self.routeViewControllerItem = [[RouteViewControllerItem alloc] init];
    return self;
}

- (id)initWithDirectionManagedObject:(DirectionManagedObject *)directionManagedObject {
    self = [self init];
    if (self) {
        self.directionManagedObject = directionManagedObject;
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
    [self.mapView addAnnotations:[self.directionManagedObject stops]];
    [self.view addSubview:self.mapView];
    // Modal search display controller
    self.modalSearchDisplayController = [[ModalSearchDisplayController alloc] initWithViewController:self.parentViewController];
    self.modalSearchDisplayController.delegate = self;
    // Track button
    self.trackButton = [[TrackButton alloc] initWithFrame:CGRectMake(8, (self.view.bounds.size.height - 29) - 8, 29, 29)];
    self.trackButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    self.trackButton.delegate = self;
    self.routeViewControllerItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.trackButton];
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
    self.routeViewControllerItem.leftBarButtonItem = nil;
    self.mapView = nil;
    self.modalSearchDisplayController = nil;
    self.trackButton = nil;
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
    [self.mapView setRegion:region animated:animated];
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

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    if (self.trackButton.state == TrackButtonStopState && MKCoordinateRegionCompare(mapView.region, _targetRegion)) {
        self.trackButton.state = TrackButtonNoneState;
    }
}

- (void)mapView:(MKMapView *)mapView didChangeUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated {
    if (self.trackButton.state == TrackButtonUserState && mode == MKUserTrackingModeNone) {
        self.trackButton.state = TrackButtonNoneState;
    }
}

#pragma mark - modalSearchDisplayControllerDelegate

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

#pragma mark - TrackButtonDelegate

- (void)trackButton:(TrackButton *)trackButton didChangeState:(TrackButtonState)state {
    switch (state) {
        case TrackButtonNoneState:
            self.mapView.userTrackingMode = MKUserTrackingModeNone;
            break;
        case TrackButtonUserState:
            [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
            break;
        case TrackButtonStopState:
            self.mapView.userTrackingMode = MKUserTrackingModeNone;
            if (self.directionManagedObject.target) {
                [self zoomToAnnotation:self.directionManagedObject.target animated:YES];
            } else {
                [self zoomToAnnotations:[self.directionManagedObject stops] animated:YES];
            }
            _targetRegion = self.mapView.region;
            break;
    }
}

#pragma mark UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.modalSearchDisplayController setActive:NO animated:YES];
}

@end
