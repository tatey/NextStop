#import "CoordinateRegion.h"
#import "Defaults.h"
#import "DestinationManagedObject.h"
#import "DirectionManagedObject.h"
#import "DirectionRecord.h"
#import "DisappearingAlertView.h"
#import "DirectionShowViewController.h"
#import "NSObject+MKMapViewDelegate.h"
#import "RouteShowViewControllerItem.h"
#import "StopRecord.h"
#import "StopReordCell.h"

static NSString *const kDirectionManagedObjectMonitorKeyPath = @"directionManagedObject.monitorProximityToTarget";

@implementation DirectionShowViewController {
    __weak StopAnnotationView *_cachedStopAnnotationView;
}

@synthesize directionManagedObject = _directionManagedObject;
@synthesize geocoder = _geocoder;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize mapView = _mapView;
@synthesize locationAuthorizationAlertView = _locationAuthorizationAlertView;
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

- (void)dealloc {
    self.mapView.delegate = nil; // MKMapView is not ARC compliant in iOS 5. Release delegate.
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
    self.modalSearchDisplayController.searchResultsDataSource = self;
    self.modalSearchDisplayController.searchResultsDelegate = self;
    // Tracking bar button item
    self.trackingBarButtonItem = [[MKUserTrackingBarButtonItem alloc] initWithMapView:self.mapView];
    self.trackingBarButtonItem.target = self;
    self.trackingBarButtonItem.action = @selector(trackingBarButtonItemTapped:);
    self.routeShowViewControllerItem.leftBarButtonItem = self.trackingBarButtonItem;
    // Zoom
    if (self.directionManagedObject.target && !self.directionManagedObject.isMonitoringProximityToTarget) {
        [self zoomToAnnotation:self.directionManagedObject.target animated:NO];
    } else {
        [self.mapView setRegion:[self.directionManagedObject region] animated:NO];
    }
    if (self.directionManagedObject.target) {
        [self.mapView selectAnnotation:[self stopRecordMatchingStopRecord:self.directionManagedObject.target] animated:NO];
    }
}

- (void)viewDidUnload {
    self.geocoder = nil;
    self.filteredStops = nil;
    self.mapView = nil;
    self.locationAuthorizationAlertView = nil;
    self.modalSearchDisplayController = nil;
    self.trackingBarButtonItem = nil;
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self applicationWillEnterForeground:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [super viewDidDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addObserver:self forKeyPath:kDirectionManagedObjectMonitorKeyPath options:NSKeyValueObservingOptionNew context:@selector(directionManagedObjectMonitorDidChangeValue)];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self removeObserver:self forKeyPath:kDirectionManagedObjectMonitorKeyPath];
    [self.directionManagedObject setRegion:self.mapView.region];
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
    [self.mapView setRegion:MKCoordinateRegionForAnnotations(annotations) animated:animated];
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
            [self.mapView selectAnnotation:[self stopRecordMatchingStopRecord:self.directionManagedObject.target] animated:YES];
        } else {
            [self zoomToAnnotations:[self.directionManagedObject stops] animated:YES];
        }
    }
}

#pragma mark - Notifications

- (void)applicationWillEnterForeground:(NSNotification *)notification {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusNotDetermined) return;
    if (status != kCLAuthorizationStatusAuthorized) {
        if (!self.locationAuthorizationAlertView) {
            self.locationAuthorizationAlertView = [[DisappearingAlertView alloc] initWithFrame:self.view.bounds message:NSLocalizedString(@"direction_show.alerts.messages.not_authorized", nil)];
            [self.view addSubview:self.locationAuthorizationAlertView];
            [self.locationAuthorizationAlertView showAnimated:YES];
        }
    } else {
        if (self.locationAuthorizationAlertView) {
            [self.locationAuthorizationAlertView hideAnimated:YES];
            self.locationAuthorizationAlertView = nil;
        }
    }
}

- (void)directionManagedObjectMonitorDidChangeValue {
    [_cachedStopAnnotationView setMonitored:self.directionManagedObject.isMonitoringProximityToTarget animated:YES];
}

- (StopRecord *)stopRecordMatchingStopRecord:(StopRecord *)other {
    for (id <MKAnnotation> annotation in self.mapView.annotations) {
        if ([annotation isKindOfClass:[StopRecord class]]) {
            StopRecord *stop = annotation;
            if ([stop isEqualToStop:other]) {
                return stop;
            }
        }
    }
    return nil;
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error {
    if (error.domain == kCLErrorDomain && error.code == kCLErrorDenied) {
        [self applicationWillEnterForeground:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alerts.title.error", nil)
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"controls.ok", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alerts.title.error", nil)
                                                    message:[error localizedDescription]
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"controls.ok", nil)
                                          otherButtonTitles:nil];
    [alert show];
}

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

- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView {
    UIApplication *application = [UIApplication sharedApplication];
    application.networkActivityIndicatorVisible = YES;
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
    UIApplication *application = [UIApplication sharedApplication];
    application.networkActivityIndicatorVisible = NO;
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
    [destinationAnnotationView hideAnimated:^(BOOL finished) {
        [self.mapView removeAnnotation:self.directionManagedObject.destination];
        [self.managedObjectContext deleteObject:self.directionManagedObject.destination];
        self.directionManagedObject.destination = nil;
    }];
}

#pragma mark - ModalSearchDisplayControllerDelegate

- (void)modalSearchDisplayController:(ModalSearchDisplayController *)controller didLoadSearchBar:(UISearchBar *)searchBar {
    searchBar.delegate = self;
    searchBar.placeholder = NSLocalizedString(@"direction_show.search.placeholder", nil);
}

#pragma mark - StopAnnotationViewDelegate

- (void)stopAnnotationView:(StopAnnotationView *)stopAnnotationView monitoredDidChangeValue:(BOOL)monitored {
    if (stopAnnotationView.monitored && [Defaults shouldShowFirstTimeTargetNotification]) {
        DisappearingAlertView *disappearingAlertView = [[DisappearingAlertView alloc] initWithFrame:self.view.bounds duration:15.0 message:NSLocalizedString(@"direction_show.alerts.messages.targeted", nil)];
        [self.view addSubview:disappearingAlertView];
        [disappearingAlertView showAnimated:YES];
        [Defaults didShowFirstTimeTargetNotification];
    }
    if (!stopAnnotationView.targeted) {
        _cachedStopAnnotationView.monitored = NO;
        _cachedStopAnnotationView.targeted = NO;
        _cachedStopAnnotationView = stopAnnotationView;
        stopAnnotationView.targeted = YES;
        self.directionManagedObject.target = (StopRecord *)stopAnnotationView.annotation;
    }
    self.directionManagedObject.monitorProximityToTarget = stopAnnotationView.monitored;
}

#pragma mark UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.filteredStops = [StopRecord stopsBelongingToDirection:self.directionManagedObject.directionRecord likeName:searchText];
}

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
            StopRecord *stop = [self.directionManagedObject.directionRecord stopClosestByLineOfSightToCoordinate:destination.coordinate];
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
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:NSLocalizedString(@"direction_show.alerts.titles.found_no_stop", nil), DIRECTION_RECORD_MAX_STOP_DISTANCE_METERS / 1000]
                                                                    message:NSLocalizedString(@"direction_show.alerts.messages.found_no_stop", nil)
                                                                   delegate:nil
                                                          cancelButtonTitle:NSLocalizedString(@"controls.ok", nil)
                                                          otherButtonTitles:nil];
                [alertView show];
            }
        } else {
            UIAlertView *alertView = nil;
            if ([error code] == 8 || [error code] == 9) {
                alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:NSLocalizedString(@"direction_show.alerts.titles.found_no_result", nil)]
                                                       message:nil
                                                      delegate:nil
                                             cancelButtonTitle:NSLocalizedString(@"controls.ok", nil)
                                             otherButtonTitles:nil];
            } else {
                alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alerts.title.error", nil)
                                                       message:[error localizedDescription]
                                                      delegate:nil
                                             cancelButtonTitle:NSLocalizedString(@"controls.ok", nil)
                                             otherButtonTitles:nil];
            }
            [alertView show];
        }
        application.networkActivityIndicatorVisible = NO;
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.filteredStops count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *StopRecordCellReuseId = @"StopRecordCell";
    StopReordCell *cell = [tableView dequeueReusableCellWithIdentifier:StopRecordCellReuseId];
    if (!cell) {
        cell = [[StopReordCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:StopRecordCellReuseId];
    }
    cell.stopRecord = [self.filteredStops objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    StopRecord *stopRecord = [self.filteredStops objectAtIndex:indexPath.row];
    [self.modalSearchDisplayController setActive:NO animated:YES];
    [self zoomToAnnotation:stopRecord animated:YES];
    [self.mapView selectAnnotation:stopRecord animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
