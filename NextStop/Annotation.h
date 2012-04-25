#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Annotation : NSObject <MKAnnotation> {
@private
    CLLocationCoordinate2D _coordinate;
    NSString *_title;
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title;

- (void)setTitle:(NSString *)title;

@end
