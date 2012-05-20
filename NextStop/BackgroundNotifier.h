#import <Foundation/Foundation.h>

@interface BackgroundNotifier : NSObject

@property (weak, nonatomic) UIApplication *application;

- (id)initWithApplication:(UIApplication *)application;

@end
