#import "BackgroundNotifier.h"
#import "TripTracker.h"

@implementation BackgroundNotifier

@synthesize application = _application;

- (id)initWithApplication:(UIApplication *)application {
    self = [self init];
    if (self) {
        self.application = application;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tripTrackerDidApproachTarget:) name:TripTrackerDidApproachTargetNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)tripTrackerDidApproachTarget:(id)sender {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertAction = NSLocalizedString(@"notifications.action.approaching", nil);
    notification.alertBody = NSLocalizedString(@"notifications.body.approaching", nil);
    notification.soundName = UILocalNotificationDefaultSoundName;
    [self.application presentLocalNotificationNow:notification];
}

@end
