#import "AppDelegate.h"
#import "BackgroundNotifier.h"
#import "DataManager.h"
#import "DirectionManagedObject.h"
#import "ProximityCenter.h"
#import "RoutesViewController.h"

@interface AppDelegate ()

@property (strong, nonatomic) BackgroundNotifier *backgroundNotifier; 
@property (strong, nonatomic) DataManager *dataManager;
@property (weak, nonatomic) ProximityCenter *proximityCenter;
@property (strong, nonatomic) UIViewController *rootViewController;

@end

@implementation AppDelegate

// Public
@synthesize window = _window;

// Private
@synthesize backgroundNotifier = _backgroundNotifier;
@synthesize dataManager = _dataManager;
@synthesize proximityCenter = _proximityCenter;
@synthesize rootViewController = _rootViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.backgroundNotifier = [[BackgroundNotifier alloc] initWithApplication:application];
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
    [self.dataManager save];
    self.proximityCenter.mode = ProximityPowerBestMode;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    self.proximityCenter.mode = ProximityAccuracyBestMode;
}

- (DataManager *)dataManager {
    if (!_dataManager) {
        _dataManager = [[DataManager alloc] init];
    }
    return _dataManager;
}

- (ProximityCenter *)proximityCenter {
    if (!_proximityCenter) {
        _proximityCenter = [ProximityCenter defaultCenter];
        [DirectionManagedObject startMonitoringProximityToTargetsInManagedObjectContext:self.dataManager.managedObjectContext];
    }
    return _proximityCenter;
}

- (UIViewController *)rootViewController {
    if (!_rootViewController) {
        RoutesViewController *rootViewController = [[RoutesViewController alloc] init];
        rootViewController.managedObjectContext = self.dataManager.managedObjectContext;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
        _rootViewController = navigationController;
    }
    return _rootViewController;
}

@end
