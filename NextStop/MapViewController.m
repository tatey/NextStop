#import "MapViewController.h"
#import "Stop.h"
#import "Tracker.h"
#import "Trip.h"
#import "User.h"

@interface MapViewController ()

@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) NSArray *stops;
@property (strong, nonatomic) Tracker *tracker;
@property (strong, nonatomic) User *user;

@end

@implementation MapViewController

// Public
@synthesize route = _route;

// Private
@synthesize mapView = _mapView;
@synthesize stops = _stops;
@synthesize tracker = _tracker;
@synthesize user = _user;

- (id)initWithRoute:(Route *)route {
    self = [self init];
    if (self) {
        self.route = route;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.user = [[User alloc] init];
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    self.mapView.delegate = self;
    [self.mapView addAnnotations:self.stops];
    [self.mapView addAnnotation:self.user];
    [self.view addSubview:self.mapView];
}

- (void)viewDidUnload {
    self.mapView = nil;
    self.stops = nil;
    self.user = nil;
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.user startTracking];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.user stopTracking];
    [super viewWillDisappear:animated];
}

@end
