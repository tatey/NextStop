#import "RouteCell.h"
#import "RouteManager.h"
#import "RouteRecord.h"
#import "RouteViewController.h"
#import "RoutesViewController.h"

static NSString *const kRouteCellReuseId = @"RouteCell";

static NSString *const kFetchedResultsControllerCacheName = @"me.nextstop.caches.routes";

@implementation RoutesViewController {
    __weak RouteManager *_selectedRouteManager;
}

@synthesize managedObjectContext = _managedObjectContext;
@synthesize routes = _routes;
@synthesize routesController = _routesController;
@synthesize searchBar = _searchBar;

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
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    self.searchBar.placeholder = NSLocalizedString(@"routes.search.placeholder", nil);
    self.routesController = [[RoutesTableViewController alloc] initWithSearchBar:self.searchBar contentsController:self managedObjectContext:self.managedObjectContext];
    self.routesController.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"RouteCell" bundle:nil] forCellReuseIdentifier:kRouteCellReuseId];
}

- (void)viewDidUnload {
    self.routes = nil;
    self.routesController = nil;
    self.searchBar = nil;
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self expireSelectedRouteManagerAnimated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.routesController setSearchDisplayControllerActive:NO];
    [super viewDidDisappear:animated];
}

- (NSString *)title {
    return NSLocalizedString(@"routes.title", nil);
}

- (void)cacheSelectedRouteManager:(RouteManager *)routeManager {
    _selectedRouteManager = routeManager;
}

- (void)expireSelectedRouteManagerAnimated {
    if (!_selectedRouteManager) return;
    for (RouteCell *cell in self.tableView.visibleCells) {
        if (cell.routeManager == _selectedRouteManager) {
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
            _selectedRouteManager = nil;
            break;
        }
    }
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
    [self cacheSelectedRouteManager:routeManager];
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
