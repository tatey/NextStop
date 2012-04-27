#import "Annotation.h"
#import "MapViewController.h"
#import "NSObject+KVOSEL.h"
#import "User.h"

#define DURATION 0.75

static NSString *const kUserCoordinateKeyPath = @"user.coordinate";

@interface MapViewController ()

@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) Annotation *userAnnotation;

@end

@implementation MapViewController

@synthesize user = _user;

@synthesize mapView = _mapView;
@synthesize userAnnotation = _userAnnotation;

- (id)initWithUser:(User *)user {
    self = [self init];
    if (self) {
        self.user = user;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userAnnotation = [self.user annotation];
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    [self.mapView addAnnotation:self.userAnnotation];
    [self.view addSubview:self.mapView];
}

- (void)viewDidUnload {
    self.mapView = nil;
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [self addObserver:self forKeyPath:kUserCoordinateKeyPath options:NSKeyValueObservingOptionNew context:@selector(user:coordinateDidChange:)];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self removeObserver:self forKeyPath:kUserCoordinateKeyPath];
    [super viewWillDisappear:animated];
}

- (void)user:(id)object coordinateDidChange:(NSDictionary *)change {
    [UIView animateWithDuration:DURATION delay:0 options:UIViewAnimationCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.userAnnotation.coordinate = self.user.coordinate;
    } completion:nil];
}

@end
