#import <math.h>
#import "DirectionManagedObject.h"
#import "DirectionViewController.h"
#import "RouteManager.h"
#import "RouteViewController.h"

@implementation RouteViewController

@synthesize directionsControl = _directionsControl;
@synthesize routeManager = _routeManager;
@synthesize selectedIndex = _selectedIndex;

- (id)initWithRouteMananger:(RouteManager *)routeManager {
    self = [self init];
    if (self) {
        self.routeManager = routeManager;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Direction control
    self.directionsControl = [[UISegmentedControl alloc] initWithItems:[self.routeManager headsigns]];
    self.directionsControl.segmentedControlStyle = UISegmentedControlStyleBar;
    self.directionsControl.selectedSegmentIndex = self.routeManager.selectedDirectionIndex;
    self.directionsControl.frame = CGRectMake(round((self.view.frame.size.width - self.directionsControl.frame.size.width) / 2), (self.view.bounds.size.height - self.directionsControl.frame.size.height) - 7, self.directionsControl.frame.size.width, self.directionsControl.frame.size.height);
    self.directionsControl.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self.directionsControl addTarget:self action:@selector(directionsControlDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.directionsControl];
    // Direction controllers
    for (DirectionManagedObject *directionManagedObject in self.routeManager.directions) {
        DirectionViewController *directionViewController = [[DirectionViewController alloc] initWithDirectionManagedObject:directionManagedObject];
        [self addChildViewController:directionViewController];
        [directionViewController didMoveToParentViewController:self];
        directionViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
    // Selected index
    self.selectedIndex = self.routeManager.selectedDirectionIndex;
}

- (void)viewDidUnload {
    self.directionsControl = nil;
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Layout children view controllers
    for (UIViewController *viewController in self.childViewControllers) {
        viewController.view.frame = self.view.bounds;
    }
    // Configure notifications
    [self applicationWillEnterForeground:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    // Configure notifications
    [self applicationDidEnterBackground:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [super viewWillDisappear:animated];
}

- (NSString *)title {
    return [self.routeManager name];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated {
    UIViewController *oldViewController = [self.childViewControllers objectAtIndex:_selectedIndex];
    UIViewController *newViewController = [self.childViewControllers objectAtIndex:selectedIndex];
    if (animated) {
        UIViewAnimationOptions options;
        if (selectedIndex < _selectedIndex) {
            options = UIViewAnimationOptionTransitionFlipFromRight;
        } else {
            options = UIViewAnimationOptionTransitionFlipFromLeft;
        }
        self.navigationController.navigationBar.userInteractionEnabled = NO;
        [self transitionFromViewController:oldViewController toViewController:newViewController duration:1.0 options:options animations:^{

        } completion:^(BOOL finished) {
            self.navigationController.navigationBar.userInteractionEnabled = YES;
        }];
    } else {
        [oldViewController.view removeFromSuperview];
        [self.view addSubview:newViewController.view];
    }
    _selectedIndex = selectedIndex;
    [self.view bringSubviewToFront:self.directionsControl];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    [self setSelectedIndex:selectedIndex animated:NO];
}

#pragma mark - Notifications

- (void)applicationDidEnterBackground:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DirectionManagedObjectDidApproachTargetNotification object:nil];
}

- (void)applicationWillEnterForeground:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showApproachingTargetAlert:) name:DirectionManagedObjectDidApproachTargetNotification object:nil];
}

- (void)directionsControlDidChangeValue:(UISegmentedControl *)directionsControl {
    self.routeManager.selectedDirectionIndex = directionsControl.selectedSegmentIndex;
    [self setSelectedIndex:directionsControl.selectedSegmentIndex animated:YES];
}

- (void)showApproachingTargetAlert:(NSNotification *)notification {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"route.alerts.titles.approaching", nil) message:NSLocalizedString(@"route.alerts.messages.approaching", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"controls.dismiss", nil) otherButtonTitles:nil];
    [alert show];
}

@end
