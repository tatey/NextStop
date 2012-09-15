#import "RouteCell.h"
#import "RouteManagedObject.h"
#import "RouteRecord.h"
#import "RouteShowViewController.h"
#import "RouteIndexViewController.h"

static NSString *const kRouteCellReuseId = @"RouteCell";

static NSString *const kFetchedResultsControllerCacheName = @"me.nextstop.caches.routes";

@implementation RouteIndexViewController {
    __weak RouteManagedObject *_selectedRouteManagedObject;
}

@synthesize managedObjectContext = _managedObjectContext;
@synthesize routes = _routes;
@synthesize routeSearchDisplayController = _routeSearchDisplayController;
@synthesize searchBar = _searchBar;

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context {
    self = [self init];
    if (self) {
        self.managedObjectContext = context;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.routes = [RouteManagedObject routesInManagedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:kFetchedResultsControllerCacheName];
    self.routes.delegate = self;
    NSError *error = nil;
    if (![self.routes performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    self.searchBar.placeholder = NSLocalizedString(@"routes.search.placeholder", nil);
    self.routeSearchDisplayController = [[RouteSearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self managedObjectContext:self.managedObjectContext];
    self.routeSearchDisplayController.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"RouteCell" bundle:nil] forCellReuseIdentifier:kRouteCellReuseId];
}

- (void)viewDidUnload {
    self.routes = nil;
    self.routeSearchDisplayController = nil;
    self.searchBar = nil;
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self expireSelectedRouteManagedObjectAnimated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.routeSearchDisplayController setActive:NO];
    [super viewDidDisappear:animated];
}

- (NSString *)title {
    return NSLocalizedString(@"routes.title", nil);
}

- (void)cacheSelectedRouteManagedObject:(RouteManagedObject *)routeManagedObject {
    _selectedRouteManagedObject = routeManagedObject;
}

- (void)expireSelectedRouteManagedObjectAnimated {
    if (!_selectedRouteManagedObject) return;
    for (RouteCell *cell in self.tableView.visibleCells) {
        if (cell.routeManagedObject == _selectedRouteManagedObject) {
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
            _selectedRouteManagedObject = nil;
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

#pragma mark - RouteSearchDisplayControllerDelegate

- (void)routeSearchDisplayController:(RouteSearchDisplayController *)routeSearchDisplayController didSelectRoute:(RouteRecord *)route {
    RouteManagedObject *routeManagedObject = [RouteManagedObject routeMatchingOrInsertingRoute:route managedObjectContext:self.managedObjectContext];
    RouteShowViewController *routeShowViewController = [[RouteShowViewController alloc] initWithRouteMananger:routeManagedObject managedObjectContext:self.managedObjectContext];
    [self.navigationController pushViewController:routeShowViewController animated:YES];
    [self cacheSelectedRouteManagedObject:routeManagedObject];
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.searchBar;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.searchBar.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RouteManagedObject *routeManagedObject = [self.routes objectAtIndexPath:indexPath];
    RouteShowViewController *routeShowViewController = [[RouteShowViewController alloc] initWithRouteMananger:routeManagedObject managedObjectContext:self.managedObjectContext];
    [self.navigationController pushViewController:routeShowViewController animated:YES];
}

@end
