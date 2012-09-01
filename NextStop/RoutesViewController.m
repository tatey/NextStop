#import "RouteCell.h"
#import "RouteManager.h"
#import "RouteRecord.h"
#import "RoutesTableViewController.h"
#import "RouteViewController.h"
#import "RoutesViewController.h"

static NSString *const kRouteCellReuseId = @"RouteCell";

static NSString *const kFetchedResultsControllerCacheName = @"me.nextstop.caches.routes";

@implementation RoutesViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize routes = _routes;
@synthesize routesController = _routesController;
@synthesize searchBar = _searchBar;
@synthesize searchController = _searchController;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.routes = [RouteManager routesInManagedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:kFetchedResultsControllerCacheName];
    self.routes.delegate = self;
    NSError *error = nil;
    if (![self.routes performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }
    self.routesController = [[RoutesTableViewController alloc] initWithDelegate:self managedObjectContext:self.managedObjectContext];
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    self.searchBar.delegate = self.routesController;
    self.searchBar.placeholder = NSLocalizedString(@"routes.search.placeholder", nil);
    self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.searchController.searchResultsDataSource = self.routesController;
    self.searchController.searchResultsDelegate = self.routesController;
    [self.tableView registerNib:[UINib nibWithNibName:@"RouteCell" bundle:nil] forCellReuseIdentifier:kRouteCellReuseId];
}

- (void)viewDidUnload {
    self.routes = nil;
    self.routesController = nil;
    self.searchBar = nil;
    self.searchController = nil;
    [super viewDidUnload];
}

- (void)viewDidDisappear:(BOOL)animated {
    self.searchController.active = NO;
}

- (NSString *)title {
    return NSLocalizedString(@"routes.title", nil);
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

#pragma mark - RoutesTableViewDelegate

- (void)routesTableViewController:(RoutesTableViewController *)routesTableViewController didSelectRoute:(RouteRecord *)route {
    RouteManager *routeManager = [RouteManager routeMatchingOrInsertingRoute:route managedObjectContext:self.managedObjectContext];
    RouteViewController *routeViewController = [[RouteViewController alloc] initWithRouteMananger:routeManager];
    [self.navigationController pushViewController:routeViewController animated:YES];
}

#pragma mark - UITableViewDataSource

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        RouteManager *routeManager = [self.routes objectAtIndexPath:indexPath];
        [self.managedObjectContext deleteObject:routeManager];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.routes.sections objectAtIndex:section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RouteCell *cell = [tableView dequeueReusableCellWithIdentifier:kRouteCellReuseId];
    cell.routeManager = [self.routes objectAtIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.searchBar;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.searchBar.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RouteManager *routeManager = [self.routes objectAtIndexPath:indexPath];
    RouteViewController *routeViewController = [[RouteViewController alloc] initWithRouteMananger:routeManager];
    [self.navigationController pushViewController:routeViewController animated:YES];
}

@end
