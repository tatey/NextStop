#import "MapViewController.h"
#import "Stop.h"
#import "Trip.h"
#import "User.h"

@interface MapViewController ()

@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) NSArray *stops;
@property (strong, nonatomic) User *user;

@end

@implementation MapViewController

@synthesize trip = _trip;

@synthesize mapView = _mapView;
@synthesize stops = _stops;
@synthesize user = _user;

- (id)initWithTrip:(Trip *)trip {
    self = [self init];
    if (self) {
        self.trip = trip;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.stops = self.trip.stops;
    self.user = [[User alloc] init];
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
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
