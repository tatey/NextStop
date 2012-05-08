#import <Foundation/Foundation.h>

@class Route;

@interface Journey : NSObject

@property (readonly) NSArray *headings;
@property (strong, nonatomic) Route *route;
@property (assign, nonatomic) NSInteger selectedHeadingIndex;
@property (readonly) NSArray *stops;

- (id)initWithRoute:(Route *)route;

@end
