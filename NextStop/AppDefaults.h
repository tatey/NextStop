#import <Foundation/Foundation.h>

@interface AppDefaults : NSObject

+ (void)didShowFirstTimeTargetNotification;
+ (BOOL)shouldShowFirstTimeTargetNotification;

+ (BOOL)syncronize;

@end
