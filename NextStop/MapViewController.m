#import "Journey.h"
#import "MapViewController.h"
#import "Stop.h"

#define TOOLBAR_HEIGHT 44

static inline MKCoordinateRegion CoordinateRegionMakeWithAnnotations(NSArray *annotations) {
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

- (void)zoomToFitStops:(BOOL)animated;

@end

@implementation MapViewController

// Public
@synthesize journey = _journey;

// Private
@synthesize headingsControl = _headingsControl;
@synthesize headingsToolbar = _toolbar;
@synthesize mapView = _mapView;

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
    [self.mapView addAnnotations:self.journey.stops];
    [self.view addSubview:self.mapView];
    // Default zoom.
    [self zoomToFitStops:NO];
}

- (void)viewDidUnload {
    self.headingsControl = nil;
    self.mapView = nil;
    self.headingsToolbar = nil;
    [super viewDidUnload];
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

@end
