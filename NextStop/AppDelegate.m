#import "AppDelegate.h"
#import "MapViewController.h"
#import "ProximityCenter.h"
#import "RoutesViewController.h"

@interface AppDelegate ()

@property (weak, nonatomic) ProximityCenter *proximityCenter;
@property (strong, nonatomic) UIViewController *rootViewController;

@end

@implementation AppDelegate

// Public
@synthesize window = _window;

// Private
@synthesize proximityCenter = _proximityCenter;
@synthesize rootViewController = _rootViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if ([launchOptions objectForKey:UIApplicationLaunchOptionsLocationKey]) {
        self.proximityCenter.mode = ProximityPowerBestMode;
    } else {
        self.proximityCenter.mode = ProximityAccuracyBestMode;
    }
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = self.rootViewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    self.proximityCenter.mode = ProximityPowerBestMode;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    self.proximityCenter.mode = ProximityAccuracyBestMode;
}

- (ProximityCenter *)proximityCenter {
    if (!_proximityCenter) {
        _proximityCenter = [ProximityCenter defaultCenter];
    }
    return _proximityCenter;
}

- (UIViewController *)rootViewController {
    if (!_rootViewController) {
        UIViewController *rootViewController = [[RoutesViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
        _rootViewController = navigationController;
    }
    return _rootViewController;
}

@end
