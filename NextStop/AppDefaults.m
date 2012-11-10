#import "AppDefaults.h"

static NSString *const kFirstTimeTargetNotificationKey = @"FirstTimeTargetNotification";
static NSString *const kDiagnosticsKey = @"Diagnostics";

@implementation AppDefaults

+ (void)didShowFirstTimeTargetNotification {
    [[NSUserDefaults standardUserDefaults] setValue:@NO forKey:kFirstTimeTargetNotificationKey];
}

+ (BOOL)shouldShowFirstTimeTargetNotification {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kFirstTimeTargetNotificationKey] == nil) {
        return YES;
    } else {
        return [[NSUserDefaults standardUserDefaults] boolForKey:kFirstTimeTargetNotificationKey];
    }
}

+ (void)sendDiagnostics:(BOOL)send {
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:send] forKey:kDiagnosticsKey];
}

+ (BOOL)canSendDiagnostics {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kDiagnosticsKey] == nil) {
        return YES;
    } else {
        return [[NSUserDefaults standardUserDefaults] boolForKey:kDiagnosticsKey];
    }
}

+ (BOOL)syncronize {
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
