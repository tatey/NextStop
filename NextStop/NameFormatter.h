#import <Foundation/Foundation.h>

@interface NameFormatter : NSObject

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *subtitle;

- (id)initWithName:(NSString *)name;

@end
