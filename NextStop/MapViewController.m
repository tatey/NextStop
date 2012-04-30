#import "MapViewController.h"
#import "Stop.h"
#import "Tracker.h"
#import "Trip.h"
#import "User.h"

static NSString *kTripDestinationKeyPath = @"trip.destination";

@interface MapViewController ()

@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) NSArray *stops;
@property (strong, nonatomic) Tracker *tracker;
@property (strong, nonatomic) User *user;

@end

@implementation MapViewController

@synthesize trip = _trip;

@synthesize mapView = _mapView;
@synthesize stops = _stops;
@synthesize tracker = _tracker;
@synthesize user = _user;

- (id)init {
    self = [super init];
    if (self) {
        [self addObserver:self forKeyPath:kTripDestinationKeyPath options:0 context:@selector(tripDestinationDidChange:)];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willApproachDestination:) name:TrackerWillApproachDestinationNotification object:nil];
    }
    return self;
}

- (id)initWithTrip:(Trip *)trip {
    self = [self init];
    if (self) {
        self.trip = trip;
    }
    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:kTripDestinationKeyPath];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.stops = self.trip.stops;
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

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    #if defined (__clang__)
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    #endif
    [self performSelector:(SEL)context withObject:change];
    #if defined (__clang__)
        #pragma clang diagnostic pop
    #endif
}

- (void)tripDestinationDidChange:(NSDictionary *)change {
    if (self.trip.destination) {
        self.tracker = [[Tracker alloc] initWithDestination:self.trip.destination.coordinate];
        [self.tracker start];
    } else {
        self.tracker = nil;
    }
}

- (void)willApproachDestination:(id)sender {
    [self.tracker stop];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"maps.alerts.titles.approaching", nil) message:NSLocalizedString(@"maps.alerts.messages.approaching", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"controls.dismiss", nil) otherButtonTitles:nil];
    [alert show];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    for (Stop *stop in self.stops) {
        if (stop == view.annotation) {
            self.trip.destination = stop;
            break;
        }
    }
}

@end
