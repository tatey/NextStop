#import "RouteRecord.h"
#import "RouteRecordCell.h"
#import "RouteSearchViewController.h"

#define SEARCH_BAR_HEIGHT 44

static NSString *kRouteRecordCellReuseId = @"RouteRecordCell";

@implementation RouteSearchViewController

@synthesize cancelBarButtonItem = _cancelBarButtonItem;
@synthesize delegate = _delegate;
@synthesize routes = _routes;
@synthesize filteredRoutes = _filteredRoutes;
@synthesize searchBar = _searchBar;
@synthesize searchController = _searchController;

- (id)initWithDelegate:(id <RouteSearchViewControllerDelegate>)delegate {
    self = [self init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (void)viewDidLoad {
    // Cancel bar button item
    self.cancelBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelBarButtonItemTapped:)];
    self.cancelBarButtonItem.style = UIBarButtonItemStyleBordered;
    self.navigationItem.rightBarButtonItem = self.cancelBarButtonItem;
    // Routes
    self.routes = [RouteRecord routes];
    // Search bar
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, SEARCH_BAR_HEIGHT)];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = NSLocalizedString(@"route_search.search.placeholder", nil);
    // Search controller
    self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.searchController.delegate = self;
    self.searchController.searchResultsDataSource = self;
    self.searchController.searchResultsDelegate = self;
    // Table view
    [self.tableView registerNib:[UINib nibWithNibName:kRouteRecordCellReuseId bundle:nil] forCellReuseIdentifier:kRouteRecordCellReuseId];
}

- (void)viewDidUnload {
    self.cancelBarButtonItem = nil;
    self.searchBar = nil;
    self.searchController = nil;
}

- (NSString *)title {
    return NSLocalizedString(@"route_search.title", nil);
}

#pragma mark - Actions

- (void)cancelBarButtonItemTapped:(UIBarButtonItem *)cancelBarButtomItem {
    [self.delegate routeSearchViewControllerDidFinish:self];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.filteredRoutes = [RouteRecord routesMatchingShortNameOrLongName:searchText];
}

#pragma mark - UISearchDisplayDelegate

- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView {
    [tableView registerNib:[UINib nibWithNibName:kRouteRecordCellReuseId bundle:nil] forCellReuseIdentifier:kRouteRecordCellReuseId];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchController.searchResultsTableView) {
        return [self.filteredRoutes count];
    } else {
        return [self.routes count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RouteRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:kRouteRecordCellReuseId];
    if (tableView == self.searchController.searchResultsTableView) {
        cell.routeRecord = [self.filteredRoutes objectAtIndex:indexPath.row];
    } else {
        cell.routeRecord = [self.routes objectAtIndex:indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RouteRecord *routeRecord = nil;
    if (tableView == self.searchController.searchResultsTableView) {
        routeRecord = [self.filteredRoutes objectAtIndex:indexPath.row];
    } else {
        routeRecord = [self.routes objectAtIndex:indexPath.row];
    }
    [self.delegate routeSearchViewController:self didSelectRoute:routeRecord];
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self.searchController.searchResultsTableView) {
        return nil;
    } else {
        return self.searchBar;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.searchController.searchResultsTableView) {
        return 0;
    } else {
        return self.searchBar.frame.size.height;
    }
}

@end
