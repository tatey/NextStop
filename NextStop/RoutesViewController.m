#import "MapViewController.h"
#import "Route.h"
#import "RoutesTableViewController.h"
#import "RouteTracker.h"
#import "RoutesViewController.h"

@implementation RoutesViewController

@synthesize routes = _routes;
@synthesize routesController = _routesController;
@synthesize searchBar = _searchBar;
@synthesize searchController = _searchController;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.routesController = [[RoutesTableViewController alloc] initWithDelegate:self];
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    self.searchBar.delegate = self.routesController;
    self.searchBar.placeholder = NSLocalizedString(@"routes.search.placeholder", nil);
    self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.searchController.searchResultsDataSource = self.routesController;
    self.searchController.searchResultsDelegate = self.routesController;
}

- (void)viewDidUnload {
    self.routesController = nil;
    self.searchBar = nil;
    self.searchController = nil;
    [super viewDidUnload];
}

- (NSString *)title {
    return NSLocalizedString(@"routes.title", nil);
}

#pragma mark - RoutesTableViewDelegate

- (void)routesTableViewController:(RoutesTableViewController *)routesTableViewController didSelectRoute:(Route *)route {
    RouteTracker *routeTracker = [[RouteTracker alloc] initWithRoute:route];
    MapViewController *mapViewController = [[MapViewController alloc] initWithRouteTracker:routeTracker];
    [self.navigationController pushViewController:mapViewController animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.routes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ResueID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ResueID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ResueID];
    }
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
    
}

@end
