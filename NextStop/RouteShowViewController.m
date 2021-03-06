#import <math.h>
#import "DirectionShowViewController.h"
#import "RouteManagedObject.h"
#import "RouteShowViewController.h"
#import "RouteShowViewControllerItem.h"
#import "Strings.h"

#define TOOLBAR_HEIGHT 44

@implementation RouteShowViewController

@synthesize directionsControl = _directionsControl;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize routeManagedObject = _routeManagedObject;
@synthesize searchBarButtonItem = _searchBarButtonItem;
@synthesize selectedIndex = _selectedIndex;

- (id)initWithRouteMananger:(RouteManagedObject *)routeManagedObject managedObjectContext:(NSManagedObjectContext *)context {
    self = [self init];
    if (self) {
        self.routeManagedObject = routeManagedObject;
        self.managedObjectContext = context;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Toolbar
    self.navigationController.toolbarHidden = NO;
    // Direction control
    self.directionsControl = [[UISegmentedControl alloc] initWithItems:[self.routeManagedObject headsigns]];
    self.directionsControl.segmentedControlStyle = UISegmentedControlStyleBar;
    self.directionsControl.selectedSegmentIndex = self.routeManagedObject.selectedDirectionIndex;
    self.directionsControl.frame = CGRectMake(round((self.view.frame.size.width - self.directionsControl.frame.size.width) / 2), (self.view.bounds.size.height - self.directionsControl.frame.size.height) - 7, self.directionsControl.frame.size.width, self.directionsControl.frame.size.height);
    self.directionsControl.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self.directionsControl addTarget:self action:@selector(directionsControlDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    // Search bar button item
    self.searchBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchBarButtonItemTapped:)];
    self.searchBarButtonItem.style = UIBarButtonItemStyleBordered;
    self.navigationItem.rightBarButtonItem = self.searchBarButtonItem;
    // Direction controllers
    for (DirectionManagedObject *directionManagedObject in self.routeManagedObject.directions) {
        DirectionShowViewController *directionShowViewController = [[DirectionShowViewController alloc] initWithDirectionManagedObject:directionManagedObject managedObjectContext:self.managedObjectContext];
        [self addChildViewController:directionShowViewController];
        [directionShowViewController didMoveToParentViewController:self];
        directionShowViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
    // Selected index
    self.selectedIndex = self.routeManagedObject.selectedDirectionIndex;
}

- (void)viewDidUnload {
    for (UIViewController *childViewController in self.childViewControllers) {
        [childViewController willMoveToParentViewController:nil];
        [childViewController removeFromParentViewController];
    }
    self.directionsControl = nil;
    self.searchBarButtonItem = nil;
    [super viewDidUnload];
}

- (void)viewDidLayoutSubviews {
    for (UIViewController *viewController in self.childViewControllers) {
        viewController.view.frame = self.view.bounds;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self applicationWillEnterForeground:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self applicationDidEnterBackground:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [super viewWillDisappear:animated];
}

- (NSString *)title {
    return [self.routeManagedObject name];
}

- (DirectionShowViewController *)selectedDirectionShowViewController {
    return [self.childViewControllers objectAtIndex:self.selectedIndex];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated {
    DirectionShowViewController *oldViewController = [self.childViewControllers objectAtIndex:_selectedIndex];
    DirectionShowViewController *newViewController = [self.childViewControllers objectAtIndex:selectedIndex];
    if (animated) {
        self.navigationController.navigationBar.userInteractionEnabled = NO;
        self.navigationController.toolbar.userInteractionEnabled = NO;
        [self transitionFromViewController:oldViewController toViewController:newViewController duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        } completion:^(BOOL finished) {
            self.navigationController.navigationBar.userInteractionEnabled = YES;
            self.navigationController.toolbar.userInteractionEnabled = YES;
        }];
    } else {
        [oldViewController.view removeFromSuperview];
        [self.view addSubview:newViewController.view];
        [self.view sendSubviewToBack:newViewController.view];
    }
    oldViewController.selected = NO;
    newViewController.selected = YES;
    _selectedIndex = selectedIndex;
    [self setToolbarItemsWithRouteShowViewControllerItem:newViewController.routeShowViewControllerItem];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    [self setSelectedIndex:selectedIndex animated:NO];
}

- (void)setToolbarItemsWithRouteShowViewControllerItem:(RouteShowViewControllerItem *)routeShowViewControllerItem {
    UIBarButtonItem *flexibleSpaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *directionControlBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.directionsControl];
    BOOL animate = !self.toolbarItems;
    if (!animate) {
        self.toolbarItems = nil;
    }
    [self setToolbarItems:@[routeShowViewControllerItem.leftBarButtonItem, flexibleSpaceBarButtonItem, directionControlBarButtonItem, flexibleSpaceBarButtonItem] animated:animate];
}

#pragma mark - Actions

- (void)searchBarButtonItemTapped:(UIBarButtonItem *)searchBarButtonItem {
    [[self selectedDirectionShowViewController] searchBarButtonItemTapped:searchBarButtonItem];
}

#pragma mark - Notifications

- (void)applicationDidEnterBackground:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NXDirectionManagedObjectDidApproachTargetNotification object:nil];
}

- (void)applicationWillEnterForeground:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showApproachingTargetAlert:) name:NXDirectionManagedObjectDidApproachTargetNotification object:nil];
}

- (void)directionsControlDidChangeValue:(UISegmentedControl *)directionsControl {
    self.routeManagedObject.selectedDirectionIndex = directionsControl.selectedSegmentIndex;
    [self setSelectedIndex:directionsControl.selectedSegmentIndex animated:YES];
}

- (void)showApproachingTargetAlert:(NSNotification *)notification {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"route.alerts.titles.approaching", nil) message:NSLocalizedString(@"route.alerts.messages.approaching", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"controls.ok", nil) otherButtonTitles:nil];
    [alert show];
}

@end
