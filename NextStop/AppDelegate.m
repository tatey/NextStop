#import "AppDelegate.h"
#import "MapViewController.h"
#import "RoutesViewController.h"

@interface AppDelegate ()

@property (strong, nonatomic) UIViewController *rootViewController;

@end

@implementation AppDelegate

// Public
@synthesize window = _window;

// Private
@synthesize rootViewController = _rootViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = self.rootViewController;
    [self.window makeKeyAndVisible];
    return YES;
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
