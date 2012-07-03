#import "Journey.h"
#import "MapViewController.h"
#import "Stop.h"

#define TOOLBAR_HEIGHT 44

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

@property (strong, nonatomic) UISegmentedControl *headingsControl;
@property (strong, nonatomic) UIToolbar *headingsToolbar;
@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) UISwitch *proximitySwitch;

- (void)zoomToFitStops:(BOOL)animated;

@end

@implementation MapViewController

// Public
@synthesize journey = _journey;

// Private
@synthesize headingsControl = _headingsControl;
@synthesize headingsToolbar = _toolbar;
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
    // Headings toolbar.
    self.headingsToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.size.height - TOOLBAR_HEIGHT, self.view.bounds.size.width, TOOLBAR_HEIGHT)];
    self.headingsToolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.headingsToolbar];
    // Headings control.
    self.headingsControl = [[UISegmentedControl alloc] initWithItems:self.journey.headings];
    self.headingsControl.segmentedControlStyle = UISegmentedControlStyleBar;    
    self.headingsControl.selectedSegmentIndex = self.journey.selectedHeadingIndex;
    [self.headingsControl addTarget:self action:@selector(headingControlValueDidChange:) forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *segmentedControl = [[UIBarButtonItem alloc] initWithCustomView:self.headingsControl];
    self.headingsToolbar.items = [NSArray arrayWithObjects:flexibleSpace, segmentedControl, flexibleSpace, nil];
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
    self.headingsControl = nil;
    self.headingsToolbar = nil;
    self.mapView = nil;
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showApproachingTargetAlert:) name:JourneyDidApproachTargetNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewWillDisappear:animated];
}

- (NSString *)title {
    return self.journey.name;
}

- (void)zoomToFitStops:(BOOL)animated {
    [self.mapView setRegion:CoordinateRegionMakeWithAnnotations(self.journey.stops) animated:animated];
}
     
#pragma mark - Actions
     
- (void)headingControlValueDidChange:(UISegmentedControl *)segmentedControl {
    [self.mapView removeAnnotations:self.journey.stops];
    self.journey.selectedHeadingIndex = segmentedControl.selectedSegmentIndex;
    [self.mapView addAnnotations:self.journey.stops];
}

- (void)proximitySwitchValueDidChange:(UISwitch *)aSwitch {    
    self.journey.monitorProximityToTarget = aSwitch.on;
}

#pragma mark - Notifications

- (void)showApproachingTargetAlert:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alerts.titles.approaching", nil) message:NSLocalizedString(@"alerts.messages.approaching", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"controls.dismiss", nil) otherButtonTitles:nil];
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
