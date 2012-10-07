#import "AppDelegate.h"
#import "BackgroundNotifier.h"
#import "DataManager.h"
#import "Defaults.h"
#import "ProximityManager.h"
#import "RouteIndexViewController.h"
#import "RouteShowViewController.h"
#import "RouteManagedObject.h"

@interface AppDelegate ()

@property (strong, nonatomic) BackgroundNotifier *backgroundNotifier; 

@end

@implementation AppDelegate

// Public
@synthesize dataManager = _dataManager;
@synthesize proximityManager = _proximityManager;
@synthesize window = _window;

// Private
@synthesize backgroundNotifier = _backgroundNotifier;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.backgroundNotifier = [[BackgroundNotifier alloc] initWithApplication:application];
    [self.proximityManager resume];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    if (![launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey]) {
        RouteIndexViewController *routeIndexViewController = [[RouteIndexViewController alloc] initWithManagedObjectContext:self.dataManager.managedObjectContext];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:routeIndexViewController];
        self.window.rootViewController = navigationController;
    }
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)localNotification {
    NSString *routeId = [localNotification.userInfo objectForKey:@"routeId"];
    RouteManagedObject *routeManagedObject = [RouteManagedObject routeMatchingRouteId:routeId managedObjectContext:self.dataManager.managedObjectContext];
    RouteShowViewController *routeShowViewController = [[RouteShowViewController alloc] initWithRouteMananger:routeManagedObject managedObjectContext:self.dataManager.managedObjectContext];
    RouteIndexViewController *routeIndexViewController = [[RouteIndexViewController alloc] initWithManagedObjectContext:self.dataManager.managedObjectContext];
    UINavigationController *navigationController = [[UINavigationController alloc] init];
    navigationController.viewControllers = @[routeIndexViewController, routeShowViewController];
    self.window.rootViewController = navigationController;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self.dataManager save];
    [Defaults syncronize];
}

- (DataManager *)dataManager {
    if (!_dataManager) {
        _dataManager = [[DataManager alloc] init];
    }
    return _dataManager;
}

- (ProximityManager *)proximityManager {
    if (!_proximityManager) {
        _proximityManager = [[ProximityManager alloc] initWithManagedObjectContext:self.dataManager.managedObjectContext];
    }
    return _proximityManager;
}

@end
