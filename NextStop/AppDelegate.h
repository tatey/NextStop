#import <UIKit/UIKit.h>

#define UIAppDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])

@class DataManager;
@class ProximityManager;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) DataManager *dataManager;
@property (strong, nonatomic) ProximityManager *proximityManager;
@property (strong, nonatomic) UIWindow *window;

@end
