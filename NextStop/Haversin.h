#import <math.h>
#import <CoreLocation/CoreLocation.h>

#define EQUATOR 6378100.0 // Meters

typedef double Radians;

static Radians DegreesToRadians(CLLocationDegrees degrees) {
    return degrees * M_PI / 180.0;
}

static CLLocationDistance Haversin(CLLocationCoordinate2D c1, CLLocationCoordinate2D c2) {
    Radians lat1rad = DegreesToRadians(c1.latitude);
    Radians lat2rad = DegreesToRadians(c2.latitude);
    return acos(sin(lat1rad) * sin(lat2rad) + cos(lat1rad) * cos(lat2rad) * cos(DegreesToRadians(c2.longitude) - DegreesToRadians(c1.longitude))) * EQUATOR;
}
