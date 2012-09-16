#import "RouteCell.h"
#import "RouteManagedObject.h"
#import "RouteRecord.h"
#import "RouteIndexViewController.h"
#import "RouteShowViewController.h"

static NSString *const kRouteCellReuseId = @"RouteCell";

static NSString *const kFetchedResultsControllerCacheName = @"me.nextstop.caches.routes";

@implementation RouteIndexViewController {
    __weak RouteManagedObject *_selectedRouteManagedObject;
}

@synthesize addBarButtonItem = _addBarButtonItem;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize routes = _routes;

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
    self.navigationItem.rightBarButtonItem = self.addBarButtonItem;
    // Edit button item
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    // Routes
    self.routes = [RouteManagedObject routesInManagedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:kFetchedResultsControllerCacheName];
    self.routes.delegate = self;
    NSError *error = nil;
    if (![self.routes performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }
    // Table view
    [self.tableView registerNib:[UINib nibWithNibName:@"RouteCell" bundle:nil] forCellReuseIdentifier:kRouteCellReuseId];
}

- (void)viewDidUnload {
    self.addBarButtonItem = nil;
    self.routes = nil;
    [super viewDidUnload];
}

- (NSString *)title {
    return NSLocalizedString(@"routes.title", nil);
}

#pragma mark - Actions

- (void)addBarButtonItemTapped:(UIBarButtonItem *)addBarButtonItem {
    RouteSearchViewController *routeSearchViewController = [[RouteSearchViewController alloc] initWithDelegate:self];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:routeSearchViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    if (type == NSFetchedResultsChangeInsert) {
        [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationTop];
    }
    if (type == NSFetchedResultsChangeMove) {
        [self.tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
    }
    if (type == NSFetchedResultsChangeDelete) {
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    }
}

#pragma mark - RouteSearchViewControllerDelegate

- (void)routeSearchViewController:(RouteSearchViewController *)routeSearchViewController didSelectRoute:(RouteRecord *)route {
    RouteManagedObject *routeManagedObject = [RouteManagedObject routeMatchingOrInsertingRoute:route managedObjectContext:self.managedObjectContext];
    [self dismissViewControllerAnimated:YES completion:^{
        NSIndexPath *indexPath = [self.routes indexPathForObject:routeManagedObject];
        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
        [self.tableView.delegate tableView:self.tableView didSelectRowAtIndexPath:indexPath];
    }];
}

- (void)routeSearchViewControllerDidFinish:(RouteSearchViewController *)routeSearchViewController {
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

@end
