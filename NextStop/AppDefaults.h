#import <Foundation/Foundation.h>

@interface AppDefaults : NSObject

+ (void)didShowFirstTimeTargetNotification;
+ (BOOL)shouldShowFirstTimeTargetNotification;

+ (void)sendDiagnostics:(BOOL)send;
+ (BOOL)canSendDiagnostics;

+ (BOOL)syncronize;

@end
