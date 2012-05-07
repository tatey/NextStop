#import "AppDelegate.h"
#import "MapViewController.h"
#import "RoutesViewController.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [self rootViewController];
    [self.window makeKeyAndVisible];
    return YES;
}

- (UIViewController *)rootViewController {
    UIViewController *rootViewController = [[RoutesViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    return navigationController;
}

@end
