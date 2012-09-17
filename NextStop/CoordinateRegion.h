#import <MapKit/MapKit.h>

static NSString *NSStringFromMKCoordinateRegion(MKCoordinateRegion region) {
    return [NSString stringWithFormat:@"{{%f, %f}, {%f, %f}}", region.center.latitude, region.center.longitude, region.span.latitudeDelta, region.span.longitudeDelta];
}

static MKCoordinateRegion MKCoordinateRegionForAnnotations(NSArray *annotations) {
    NSInteger count = 0;
    MKMapPoint points[[annotations count]];
    for (id <MKAnnotation> annotation in annotations) {
        points[count++] = MKMapPointForCoordinate(annotation.coordinate);
    }
    MKPolygon *polygon = [MKPolygon polygonWithPoints:points count:count];
    MKCoordinateRegion region = MKCoordinateRegionForMapRect([polygon boundingMapRect]);
    MKCoordinateSpan minimumSpan = MKCoordinateSpanMake(0.01, 0.01);
    if (region.span.latitudeDelta < minimumSpan.latitudeDelta && region.span.longitudeDelta < minimumSpan.longitudeDelta) {
        region.span = minimumSpan;
    }
    return region;
}
