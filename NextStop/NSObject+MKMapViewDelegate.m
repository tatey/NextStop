#import "NSObject+MKMapViewDelegate.h"

@implementation NSObject (MKMapViewDelegate)

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"mapView:viewFor%@:", [annotation class]]);
    if ([self respondsToSelector:selector]) {
        #if defined (__clang__)
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        #endif
        return [self performSelector:selector withObject:mapView withObject:annotation];
        #if defined (__clang__)
            #pragma clang diagnostic pop
        #endif
    } else {
        return nil;
    }
}

@end
