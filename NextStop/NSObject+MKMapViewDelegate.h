#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface NSObject (MKMapViewDelegate)

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation;
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view;

@end
