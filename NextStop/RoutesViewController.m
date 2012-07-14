#import "MapViewController.h"
#import "RouteManager.h"
#import "RouteRecord.h"
#import "RoutesTableViewController.h"
#import "RouteManager.h"
#import "RoutesViewController.h"

static NSString *const kFetchedResultsControllerCacheName = @"me.nextstop.caches.routes";

@implementation RoutesViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize routes = _routes;
@synthesize routesController = _routesController;
@synthesize searchBar = _searchBar;
@synthesize searchController = _searchController;

- (void)viewDidLoad {
    [super viewDidLoad];
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
}

- (void)viewDidUnload {
    self.routes = nil;
    self.routesController = nil;
    self.searchBar = nil;
    self.searchController = nil;
    [super viewDidUnload];
}

- (NSString *)title {
    return NSLocalizedString(@"routes.title", nil);
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    if (type == NSFetchedResultsChangeInsert) {
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationTop];
    }
}

#pragma mark - RoutesTableViewDelegate

- (void)routesTableViewController:(RoutesTableViewController *)routesTableViewController didSelectRoute:(RouteRecord *)route {
    RouteManager *routeManager = [RouteManager routeMatchingOrInsertingRoute:route managedObjectContext:self.managedObjectContext];
    MapViewController *mapViewController = [[MapViewController alloc] initWithRouteManager:routeManager];
    [self.navigationController pushViewController:mapViewController animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.routes.sections objectAtIndex:section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ResueID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ResueID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ResueID];
    }
    RouteManager *routeManager = [self.routes objectAtIndexPath:indexPath];
    RouteRecord *routeRecord = routeManager.route;
    cell.textLabel.text = routeRecord.shortName;
    cell.detailTextLabel.text = routeRecord.longName;
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
    MapViewController *mapViewController = [[MapViewController alloc] initWithRouteManager:routeManager];
    [self.navigationController pushViewController:mapViewController animated:YES];
}

@end
