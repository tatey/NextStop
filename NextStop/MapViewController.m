#import "Annotation.h"
#import "MapViewController.h"
#import "Stop.h"
#import "Tracker.h"
#import "Trip.h"

#define DURATION 0.75

static NSString *const kTrackerCurrentKeyPath = @"tracker.current";

@interface MapViewController ()

@property (strong, nonatomic) Annotation *currentAnnotation;
@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) NSArray *stopAnnotations;
@property (strong, nonatomic) Tracker *tracker;

@end

@implementation MapViewController

@synthesize trip = _trip;

@synthesize currentAnnotation = _currentAnnotation;
@synthesize mapView = _mapView;
@synthesize stopAnnotations = _stopAnnotations;
@synthesize tracker = _tracker;

- (id)initWithTrip:(Trip *)trip {
    self = [self init];
    if (self) {
        self.trip = trip;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tracker = [[Tracker alloc] init];
    [self.tracker start];
    NSMutableArray *stopAnnotations = [NSMutableArray arrayWithCapacity:[self.trip numberOfStops]];
    for (Stop *stop in self.trip.stops) {
        [stopAnnotations addObject:[stop annotation]];
    }
    self.currentAnnotation = [[Annotation alloc] initWithCoordinate:self.tracker.current title:NSLocalizedString(@"maps.you", nil)];
    self.stopAnnotations = stopAnnotations;
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    for (Annotation *annotation in self.stopAnnotations) {
        [self.mapView addAnnotation:annotation];
    }
    [self.mapView addAnnotation:self.currentAnnotation];
    [self.view addSubview:self.mapView];
}

- (void)viewDidUnload {
    self.currentAnnotation = nil;
    self.mapView = nil;
    self.stopAnnotations = nil;
    self.tracker = nil;
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addObserver:self forKeyPath:kTrackerCurrentKeyPath options:NSKeyValueObservingOptionNew context:@selector(trackerDidChangeCurrent:)];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self removeObserver:self forKeyPath:kTrackerCurrentKeyPath];
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

- (void)trackerDidChangeCurrent:(NSDictionary *)change {
    [UIView animateWithDuration:DURATION delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
        self.currentAnnotation.coordinate = self.tracker.current;
    } completion:nil];    
}

@end
