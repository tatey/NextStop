#import "AppDefaults.h"
#import "AppDelegate.h"
#import "BackgroundNotifier.h"
#import "DataManager.h"
#import "DDFileLogger.h"
#import "DDTTYLogger.h"
#import "ProximityManager.h"
#import "RouteIndexViewController.h"
#import "RouteShowViewController.h"
#import "RouteManagedObject.h"

@interface AppDelegate ()

@property (strong, nonatomic) BackgroundNotifier *backgroundNotifier; 

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if (application.applicationState == UIApplicationStateBackground) {
        self.backgroundNotifier = [[BackgroundNotifier alloc] initWithApplication:application];
    }
    self.fileLogger = [[DDFileLogger alloc] init];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [DDLog addLogger:self.fileLogger];
    self.dataManager = [[DataManager alloc] init];
    self.proximityManager = [[ProximityManager alloc] initWithDataManager:self.dataManager];
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
    self.backgroundNotifier = [[BackgroundNotifier alloc] initWithApplication:application];
    [self.dataManager save];
    [AppDefaults syncronize];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    self.backgroundNotifier = nil;
}

@end
