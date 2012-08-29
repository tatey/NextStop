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

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"mapView:didDeselect%@:", [view class]]);
    if ([self respondsToSelector:selector]) {
    #if defined (__clang__)
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    #endif
    [self performSelector:selector withObject:mapView withObject:view];
    #if defined (__clang__)
        #pragma clang diagnostic pop
    #endif
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"mapView:didSelect%@:", [view class]]);
    if ([self respondsToSelector:selector]) {
        #if defined (__clang__)
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        #endif
        [self performSelector:selector withObject:mapView withObject:view];
        #if defined (__clang__)
            #pragma clang diagnostic pop
        #endif
    }
}

@end
