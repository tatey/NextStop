#import <math.h>
#import "DirectionViewController.h"
#import "ModalSearchViewController.h"
#import "RouteManager.h"
#import "RouteViewController.h"
#import "RouteViewControllerItem.h"
#import "Strings.h"

#define TOOLBAR_HEIGHT 44

@implementation RouteViewController

@synthesize directionsControl = _directionsControl;
@synthesize modalSearchViewController = _modalSearchViewController;
@synthesize routeManager = _routeManager;
@synthesize searchBarButtonItem = _searchBarButtonItem;
@synthesize selectedIndex = _selectedIndex;
@synthesize toolbar = _toolbar;

- (id)initWithRouteMananger:(RouteManager *)routeManager {
    self = [self init];
    if (self) {
        self.routeManager = routeManager;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Toolbar
    self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - TOOLBAR_HEIGHT, self.view.bounds.size.width, TOOLBAR_HEIGHT)];
    self.toolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.toolbar];
    // Direction control
    self.directionsControl = [[UISegmentedControl alloc] initWithItems:[self.routeManager headsigns]];
    self.directionsControl.segmentedControlStyle = UISegmentedControlStyleBar;
    self.directionsControl.selectedSegmentIndex = self.routeManager.selectedDirectionIndex;
    self.directionsControl.frame = CGRectMake(round((self.view.frame.size.width - self.directionsControl.frame.size.width) / 2), (self.view.bounds.size.height - self.directionsControl.frame.size.height) - 7, self.directionsControl.frame.size.width, self.directionsControl.frame.size.height);
    self.directionsControl.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self.directionsControl addTarget:self action:@selector(directionsControlDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    // Search bar button item
    self.searchBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchBarButtonItemTapped:)];
    self.searchBarButtonItem.style = UIBarButtonItemStyleBordered;
    self.navigationItem.rightBarButtonItem = self.searchBarButtonItem;
    // Modal search controller
    self.modalSearchViewController = [[ModalSearchViewController alloc] initWithViewController:self];
    self.modalSearchViewController.delegate = self;
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
    self.modalSearchViewController = nil;
    self.searchBarButtonItem = nil;
    self.toolbar = nil;
    [super viewDidUnload];
}

- (void)viewDidLayoutSubviews {
    for (UIViewController *viewController in self.childViewControllers) {
        CGRect frame = self.view.bounds;
        frame.size.height = frame.size.height - TOOLBAR_HEIGHT;
        viewController.view.frame = frame;
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
    return [self.routeManager name];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated {
    DirectionViewController *oldViewController = [self.childViewControllers objectAtIndex:_selectedIndex];
    DirectionViewController *newViewController = [self.childViewControllers objectAtIndex:selectedIndex];
    if (animated) {
        self.navigationController.navigationBar.userInteractionEnabled = NO;
        [self transitionFromViewController:oldViewController toViewController:newViewController duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{

        } completion:^(BOOL finished) {
            self.navigationController.navigationBar.userInteractionEnabled = YES;
        }];
    } else {
        [oldViewController.view removeFromSuperview];
        [self.view addSubview:newViewController.view];
    }
    _selectedIndex = selectedIndex;
    [self setToolbarItemsWithRouteViewControllerItem:newViewController.routeViewControllerItem];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    [self setSelectedIndex:selectedIndex animated:NO];
}

- (void)setToolbarItemsWithRouteViewControllerItem:(RouteViewControllerItem *)routeViewControllerItem {
    UIBarButtonItem *flexibleSpaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *directionControlBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.directionsControl];
    self.toolbar.items = nil;
    self.toolbar.items = @[routeViewControllerItem.leftBarButtonItem, flexibleSpaceBarButtonItem, directionControlBarButtonItem, flexibleSpaceBarButtonItem];
    
}

#pragma mark - Actions

- (void)searchBarButtonItemTapped:(UIBarButtonItem *)searchBarButtonItem {
    [self.modalSearchViewController setActive:YES animated:YES];
}

#pragma mark - Notifications

- (void)applicationDidEnterBackground:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NXDirectionManagedObjectDidApproachTargetNotification object:nil];
}

- (void)applicationWillEnterForeground:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showApproachingTargetAlert:) name:NXDirectionManagedObjectDidApproachTargetNotification object:nil];
}

- (void)directionsControlDidChangeValue:(UISegmentedControl *)directionsControl {
    self.routeManager.selectedDirectionIndex = directionsControl.selectedSegmentIndex;
    [self setSelectedIndex:directionsControl.selectedSegmentIndex animated:YES];
}

- (void)showApproachingTargetAlert:(NSNotification *)notification {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"route.alerts.titles.approaching", nil) message:NSLocalizedString(@"route.alerts.messages.approaching", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"controls.dismiss", nil) otherButtonTitles:nil];
    [alert show];
}

#pragma mark - ModalSearchViewControllerDelegate

- (void)modalSearchViewControllerDelegate:(ModalSearchViewController *)controller didLoadSearchBar:(UISearchBar *)searchBar {
    searchBar.delegate = self;
}

#pragma mark UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.modalSearchViewController setActive:NO animated:YES];
}

@end
