#import "BackgroundNotifier.h"
#import "Journey.h"

@implementation BackgroundNotifier

@synthesize application = _application;

- (id)initWithApplication:(UIApplication *)application {
    self = [self init];
    if (self) {
        self.application = application;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(journeyDidApproach:) name:JourneyDidApproachTargetNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)journeyDidApproach:(id)sender {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertAction = NSLocalizedString(@"local_notification.action.approaching", nil);
    notification.alertBody = NSLocalizedString(@"local_notification.body.approaching", nil);
    [self.application presentLocalNotificationNow:notification];
}

@end
