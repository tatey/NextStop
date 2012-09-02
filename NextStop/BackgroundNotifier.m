#import "BackgroundNotifier.h"
#import "Strings.h"

@implementation BackgroundNotifier

@synthesize application = _application;

- (id)initWithApplication:(UIApplication *)application {
    self = [self init];
    if (self) {
        self.application = application;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(directionManagedObjectDidApproachTarget:) name:NXDirectionManagedObjectDidApproachTargetNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)directionManagedObjectDidApproachTarget:(id)sender {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertAction = NSLocalizedString(@"notifications.action.approaching", nil);
    notification.alertBody = NSLocalizedString(@"notifications.body.approaching", nil);
    notification.soundName = UILocalNotificationDefaultSoundName;
    [self.application presentLocalNotificationNow:notification];
}

@end
