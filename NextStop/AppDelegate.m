#import "AppDelegate.h"
#import "MapViewController.h"
#import "User.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(37.786996, -122.419281);
    User *user = [[User alloc] initWithCoordinate:coordinate routeCode:@"133"];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[MapViewController alloc] initWithUser:user];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
