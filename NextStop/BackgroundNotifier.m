#import "BackgroundNotifier.h"
#import "DirectionManagedObject.h"
#import "RouteManagedObject.h"
#import "RouteRecord.h"
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

#pragma mark - Notifications

- (void)directionManagedObjectDidApproachTarget:(NSNotification *)notification {
    DirectionManagedObject *directionManagedObject = notification.object;
    RouteManagedObject *routeManagedObject = directionManagedObject.routeManagedObject;
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.userInfo = @{@"routeId": routeManagedObject.routeRecord.routeId};
    localNotification.alertAction = NSLocalizedString(@"notifications.action.approaching", nil);
    localNotification.alertBody = NSLocalizedString(@"notifications.body.approaching", nil);
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    [self.application presentLocalNotificationNow:localNotification];
}

@end
