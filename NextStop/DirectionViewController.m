#import "DirectionManagedObject.h"
#import "DirectionViewController.h"
#import "NSObject+MKMapViewDelegate.h"
#import "StopRecord.h"

static NSString *const kDirectionManagedObjectMonitorKeyPath = @"directionManagedObject.monitorProximityToTarget";

static MKCoordinateRegion CoordinateRegionMakeWithAnnotations(NSArray *annotations) {
    NSInteger count = 0;
    MKMapPoint points[[annotations count]];
    for (id <MKAnnotation> annotation in annotations) {
        points[count++] = MKMapPointForCoordinate(annotation.coordinate);
    }
    MKPolygon *polygon = [MKPolygon polygonWithPoints:points count:count];
    return MKCoordinateRegionForMapRect([polygon boundingMapRect]);
}

@implementation DirectionViewController {
    __weak StopAnnotationView *_cachedStopAnnotationView;
}

@synthesize directionManagedObject = _directionManagedObject;
@synthesize mapView = _mapView;

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
    // Zoom
    if (self.directionManagedObject.target) {
        [self.mapView setRegion:MKCoordinateRegionMake(self.directionManagedObject.target.coordinate, MKCoordinateSpanMake(0.05, 0.05))];
        [self.mapView selectAnnotation:self.directionManagedObject.target animated:NO];
    } else {
        [self.mapView setRegion:CoordinateRegionMakeWithAnnotations([self.directionManagedObject stops])];
    }
}

- (void)viewDidUnload {
    self.mapView = nil;
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

@end
