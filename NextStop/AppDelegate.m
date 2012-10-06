#import "AppDelegate.h"
#import "BackgroundNotifier.h"
#import "DataManager.h"
#import "Defaults.h"
#import "DirectionManagedObject.h"
#import "ProximityManager.h"
#import "RouteIndexViewController.h"

@interface AppDelegate ()

@property (strong, nonatomic) BackgroundNotifier *backgroundNotifier; 
@property (strong, nonatomic) UIViewController *rootViewController;

@end

@implementation AppDelegate

// Public
@synthesize dataManager = _dataManager;
@synthesize proximityManager = _proximityManager;
@synthesize window = _window;

// Private
@synthesize backgroundNotifier = _backgroundNotifier;
@synthesize rootViewController = _rootViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.backgroundNotifier = [[BackgroundNotifier alloc] initWithApplication:application];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = self.rootViewController;
    [self.window makeKeyAndVisible];
    return YES;
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

- (UIViewController *)rootViewController {
    if (!_rootViewController) {
        RouteIndexViewController *rootViewController = [[RouteIndexViewController alloc] initWithManagedObjectContext:self.dataManager.managedObjectContext];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
        _rootViewController = navigationController;
    }
    return _rootViewController;
}

@end
