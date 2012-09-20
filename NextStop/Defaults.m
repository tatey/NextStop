#import "Defaults.h"

static NSString *const kFirstTimeTargetNotificationKey = @"FirstTimeTargetNotification";

@implementation Defaults

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

+ (BOOL)syncronize {
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
