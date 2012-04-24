#import <MapKit/MapKit.h>
#import "Annotation.h"
#import "MapViewController.h"

@interface MapViewController () {
    NSUInteger _count;
}

@end

@implementation MapViewController

@synthesize mapView = _mapView;

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *button = [UIButton buttonWithType:UIBarStyleBlack];
    [button addTarget:self action:@selector(didTouchButton:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 10, 10);
    
    
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    
    Annotation *annotation = [[Annotation alloc] init];
    [annotation setTitle:@"he"];
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
    [self.mapView addAnnotation:annotation];
    
    [self.view addSubview:button];
    [self.view addSubview:self.mapView];
}

- (void)viewDidUnload {
    self.mapView = nil;
    [super viewDidUnload];
}

- (void)didTouchButton:(id)sender {
    Annotation *annotation = [[self.mapView annotations] lastObject];
    
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = 37.786996 + _count++;
    coordinate.longitude = -122.419281;
    
    [UIView animateWithDuration:0.5 animations:^{
        [annotation setCoordinate:coordinate];
    }];
    [annotation setTitle:[@"hello" stringByAppendingFormat:@" %d", _count]];
}

@end
