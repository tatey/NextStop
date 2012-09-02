#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class DirectionRecord;

@interface StopRecord : NSObject <MKAnnotation>

@property (readonly) NSString *name;
@property (readonly) NSUInteger primaryKey;

+ (NSArray *)stopsBelongingToDirection:(DirectionRecord *)direction;
+ (id)stopMatchingPrimaryKey:(NSInteger)primaryKey;

- (BOOL)isEqualToStop:(StopRecord *)stop;

@end
