#import "Journey.h"
#import "MapViewController.h"
#import "NSObject+KVOSEL.h"
#import "Stop.h"

#define TOOLBAR_HEIGHT 44

static NSString *const kJourneyMonitorProximityToTargetKeyPath = @"journey.monitorProximityToTarget";

static MKCoordinateRegion CoordinateRegionMakeWithAnnotations(NSArray *annotations) {
    NSInteger count = 0;
    MKMapPoint points[[annotations count]];
    for (id <MKAnnotation> annotation in annotations) {
        points[count++] = MKMapPointForCoordinate(annotation.coordinate);
    }
    MKPolygon *polygon = [MKPolygon polygonWithPoints:points count:count];
    return MKCoordinateRegionForMapRect([polygon boundingMapRect]);
}

@interface MapViewController ()

@property (strong, nonatomic) UISegmentedControl *directionsControl;
@property (strong, nonatomic) UIToolbar *directionsToolbar;
@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) UISwitch *proximitySwitch;

- (void)zoomToFitStops:(BOOL)animated;

@end

@implementation MapViewController

// Public
@synthesize journey = _journey;

// Private
@synthesize directionsControl = _directionsControl;
@synthesize directionsToolbar = _directionsToolbar;
@synthesize mapView = _mapView;
@synthesize proximitySwitch = _proximitySwitch;

- (id)initWithJourney:(Journey *)journey {
    self = [self init];
    if (self) {
        self.journey = journey;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];    
    // Directions toolbar.
    self.directionsToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.size.height - TOOLBAR_HEIGHT, self.view.bounds.size.width, TOOLBAR_HEIGHT)];
    self.directionsToolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.directionsToolbar];
    // Directions control.
    self.directionsControl = [[UISegmentedControl alloc] initWithItems:self.journey.directions];
    self.directionsControl.segmentedControlStyle = UISegmentedControlStyleBar;
    self.directionsControl.selectedSegmentIndex = self.journey.selectedDirectionIndex;
    [self.directionsControl addTarget:self action:@selector(directionControlValueDidChange:) forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *segmentedControl = [[UIBarButtonItem alloc] initWithCustomView:self.directionsControl];
    self.directionsToolbar.items = [NSArray arrayWithObjects:flexibleSpace, segmentedControl, flexibleSpace, nil];
    // MapView and annotations.
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height - TOOLBAR_HEIGHT)];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    [self.mapView addAnnotations:self.journey.stops];
    [self.view addSubview:self.mapView];
    // Proximity switch.
    self.proximitySwitch = [[UISwitch alloc] init];
    [self.proximitySwitch addTarget:self action:@selector(proximitySwitchValueDidChange:) forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *proximitySwitchBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.proximitySwitch];
    self.navigationItem.rightBarButtonItem = proximitySwitchBarButtonItem;
    // Default zoom.
    [self zoomToFitStops:NO];
}

- (void)viewDidUnload {
    self.directionsControl = nil;
    self.directionsToolbar = nil;
    self.mapView = nil;
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addObserver:self forKeyPath:kJourneyMonitorProximityToTargetKeyPath options:NSKeyValueObservingOptionNew context:@selector(journeyProximityToTargetDidChange)];
    [self applicationWillEnterForeground:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self removeObserver:self forKeyPath:kJourneyMonitorProximityToTargetKeyPath];
    [self applicationDidEnterBackground:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [super viewWillDisappear:animated];
}

- (NSString *)title {
    return self.journey.name;
}

- (void)zoomToFitStops:(BOOL)animated {
    [self.mapView setRegion:CoordinateRegionMakeWithAnnotations(self.journey.stops) animated:animated];
}
     
#pragma mark - Actions
     
- (void)directionControlValueDidChange:(UISegmentedControl *)segmentedControl {
    [self.mapView removeAnnotations:self.journey.stops];
    self.journey.selectedDirectionIndex = segmentedControl.selectedSegmentIndex;
    [self.mapView addAnnotations:self.journey.stops];
}

- (void)proximitySwitchValueDidChange:(UISwitch *)aSwitch {
    self.journey.monitorProximityToTarget = aSwitch.on;
}

#pragma mark - Notifications

- (void)applicationDidEnterBackground:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:JourneyDidApproachTargetNotification object:nil];
}

- (void)applicationWillEnterForeground:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showApproachingTargetAlert:) name:JourneyDidApproachTargetNotification object:nil];
}

- (void)journeyProximityToTargetDidChange {
    [self.proximitySwitch setOn:self.journey.monitorProximityToTarget animated:YES];
}

- (void)showApproachingTargetAlert:(NSNotification *)notification {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"maps.alerts.titles.approaching", nil) message:NSLocalizedString(@"maps.alerts.messages.approaching", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"controls.dismiss", nil) otherButtonTitles:nil];
    [alert show];
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    for (Stop *stop in self.journey.stops) {
        if (stop == view.annotation) {
            self.journey.target = stop;
            break;
        }
    }
}

@end
