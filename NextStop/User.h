#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

@class Annotation;

@interface User : NSObject

@property (assign, nonatomic) CLLocationCoordinate2D coordinate;
@property (strong, nonatomic) NSString *routeCode;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate routeCode:(NSString *)routeCode;

- (Annotation *)annotation;

@end
