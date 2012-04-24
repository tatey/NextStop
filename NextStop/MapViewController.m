#import <MapKit/MapKit.h>
#import "MapViewController.h"

@implementation MapViewController

@synthesize mapView = _mapView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.mapView];
}

- (void)viewDidUnload {
    self.mapView = nil;
    [super viewDidUnload];
}

@end
