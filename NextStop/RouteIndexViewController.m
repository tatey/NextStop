#import "RouteCell.h"
#import "RouteManagedObject.h"
#import "RouteRecord.h"
#import "RouteIndexViewController.h"
#import "RouteShowViewController.h"

#define ROW_HEIGHT 65

static NSString *const kRouteCellReuseId = @"RouteCell";

static NSString *const kFetchedResultsControllerCacheName = @"me.nextstop.caches.routes";

@implementation RouteIndexViewController {
    __weak RouteManagedObject *_selectedRouteManagedObject;
}

@synthesize addBarButtonItem = _addBarButtonItem;
@synthesize emptyRouteView = _emptyRouteView;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize routes = _routes;
@synthesize tableView = _tableView;

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context {
    self = [self init];
    if (self) {
        self.managedObjectContext = context;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Add bar button item
    self.addBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBarButtonItemTapped:)];
    self.addBarButtonItem.style = UIBarButtonItemStyleBordered;
    self.navigationItem.leftBarButtonItem = self.addBarButtonItem;
    // Toolbar
    UIBarButtonItem *flexibleSpaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *aboutBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"About.png"] style:UIBarButtonItemStylePlain target:self action:@selector(aboutBarButtonItemTapped:)];
    self.navigationController.toolbarHidden = NO;
    self.toolbarItems = @[flexibleSpaceBarButtonItem, flexibleSpaceBarButtonItem, flexibleSpaceBarButtonItem, aboutBarButtonItem];
    // Routes
    self.routes = [RouteManagedObject routesInManagedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:kFetchedResultsControllerCacheName];
    self.routes.delegate = self;
    NSError *error = nil;
    if (![self.routes performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }
    // Table view
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = ROW_HEIGHT;
    [self.tableView registerNib:[UINib nibWithNibName:@"RouteCell" bundle:nil] forCellReuseIdentifier:kRouteCellReuseId];
    [self.view addSubview:self.tableView];
    [self toggleEmptyRoutesView];
}

- (void)viewDidUnload {
    self.addBarButtonItem = nil;
    self.routes = nil;
    [super viewDidUnload];
}

- (void)viewWillLayoutSubviews {
    self.emptyRouteView.frame = self.view.bounds;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if (indexPath) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:animated];
    }
}

- (NSString *)title {
    return NSLocalizedString(@"routes.title", nil);
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    if (self.tableView.editing != editing) {
        [self.tableView setEditing:editing animated:animated];
    }
}

- (void)addEmptyRouteView {
    if (self.emptyRouteView) return;
    self.emptyRouteView = [[[NSBundle mainBundle] loadNibNamed:@"EmptyRouteView" owner:nil options:nil] lastObject];
    [self.view addSubview:self.emptyRouteView];
    self.emptyRouteView.center = self.view.center;
    self.navigationItem.rightBarButtonItem = nil;
    [self setEditing:NO animated:NO];
}

- (void)removeEmptyRouteView {
    if (!self.emptyRouteView) return;
    [self.emptyRouteView removeFromSuperview];
    self.emptyRouteView = nil;
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)toggleEmptyRoutesView {
    if ([[self.routes fetchedObjects] count] == 0) {
        [self addEmptyRouteView];
    } else {
        [self removeEmptyRouteView];
    }
}

#pragma mark - Actions

- (void)aboutBarButtonItemTapped:(UIBarButtonItem *)aboutBarButtonItem {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NextStop" bundle:nil];
    UINavigationController *navigationController = [storyboard instantiateInitialViewController];
    AboutViewController *aboutViewController = (AboutViewController *)navigationController.topViewController;
    aboutViewController.delegate = self;
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)addBarButtonItemTapped:(UIBarButtonItem *)addBarButtonItem {
    RouteNewViewController *routeNewViewController = [[RouteNewViewController alloc] initWithDelegate:self];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:routeNewViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - AboutViewControllerDelegate

- (void)aboutViewControlerDidFinish:(AboutViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    if (type == NSFetchedResultsChangeInsert) {
        [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationTop];
        [self toggleEmptyRoutesView];
    }
    if (type == NSFetchedResultsChangeMove) {
        [self.tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
    }
    if (type == NSFetchedResultsChangeDelete) {
        UITableViewRowAnimation animation;
        if ([self.tableView.visibleCells count] > [[[self.routes sections] objectAtIndex:0] numberOfObjects]) {
            animation = UITableViewRowAnimationLeft;
        } else {
            animation = UITableViewRowAnimationTop;
        }
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
        [self toggleEmptyRoutesView];
    }
}

#pragma mark - RouteNewViewControllerDelegate

- (void)routeNewViewController:(RouteNewViewController *)routeNewViewController didSelectRoute:(RouteRecord *)route {
    RouteManagedObject *routeManagedObject = [RouteManagedObject routeMatchingOrInsertingRouteRecord:route managedObjectContext:self.managedObjectContext];
    [self dismissViewControllerAnimated:YES completion:^{
        NSIndexPath *indexPath = [self.routes indexPathForObject:routeManagedObject];
        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
        [self.tableView.delegate tableView:self.tableView didSelectRowAtIndexPath:indexPath];
    }];
}

- (void)routeNewViewControllerDidFinish:(RouteNewViewController *)routeNewViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        RouteManagedObject *routeManagedObject = [self.routes objectAtIndexPath:indexPath];
        [self.managedObjectContext deleteObject:routeManagedObject];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.routes.sections objectAtIndex:section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RouteCell *cell = [tableView dequeueReusableCellWithIdentifier:kRouteCellReuseId];
    cell.routeManagedObject = [self.routes objectAtIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RouteManagedObject *routeManagedObject = [self.routes objectAtIndexPath:indexPath];
    RouteShowViewController *routeShowViewController = [[RouteShowViewController alloc] initWithRouteMananger:routeManagedObject managedObjectContext:self.managedObjectContext];
    [self.navigationController pushViewController:routeShowViewController animated:YES];
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    [self setEditing:NO animated:YES];
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    [self setEditing:YES animated:YES];
}

@end
