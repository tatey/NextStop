#import "NSArray+Random.h"
#import "RouteRecord.h"
#import "RouteRecordCell.h"
#import "RouteNewViewController.h"

#define SEARCH_BAR_HEIGHT 44
#define ROW_HEIGHT 65

static NSString *kRouteRecordCellReuseId = @"RouteRecordCell";

@implementation RouteNewViewController

@synthesize cancelBarButtonItem = _cancelBarButtonItem;
@synthesize delegate = _delegate;
@synthesize routes = _routes;
@synthesize filteredRoutes = _filteredRoutes;
@synthesize searchBar = _searchBar;
@synthesize searchController = _searchController;

- (id)initWithDelegate:(id <RouteNewViewControllerDelegate>)delegate {
    self = [self init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Cancel bar button item
    self.cancelBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelBarButtonItemTapped:)];
    self.cancelBarButtonItem.style = UIBarButtonItemStyleBordered;
    self.navigationItem.rightBarButtonItem = self.cancelBarButtonItem;
    // Routes
    self.routes = [RouteRecord routes];
    // Search bar
    RouteRecord *routeRecord = [self.routes objectAtRandomIndex];
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, SEARCH_BAR_HEIGHT)];
    self.searchBar.delegate = self;
    self.searchBar.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.searchBar.placeholder = [NSString stringWithFormat:NSLocalizedString(@"route_search.search.placeholder", nil), routeRecord.shortName, [routeRecord mediumName]];
    // Search controller
    self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.searchController.delegate = self;
    self.searchController.searchResultsDataSource = self;
    self.searchController.searchResultsDelegate = self;
    // Table view
    [self.tableView registerNib:[UINib nibWithNibName:kRouteRecordCellReuseId bundle:nil] forCellReuseIdentifier:kRouteRecordCellReuseId];
    self.tableView.tableHeaderView = self.searchBar;
    self.tableView.tableHeaderView.backgroundColor = [UIColor blackColor];
    self.tableView.rowHeight = ROW_HEIGHT;
    CGRect frame = self.view.bounds;
    frame.origin.y = -frame.size.height;
    UIView *bounceView = [[UIView alloc] initWithFrame:frame];
    bounceView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    bounceView.backgroundColor = [UIColor colorWithRed:0.8588 green:0.8824 blue:0.9098 alpha:1.0000];
    [self.tableView addSubview:bounceView];
    [self.tableView sendSubviewToBack:bounceView];
}

- (void)viewDidUnload {
    self.cancelBarButtonItem = nil;
    self.routes = nil;
    self.searchBar = nil;
    self.searchController = nil;
    [super viewDidUnload];
}

- (NSString *)title {
    return NSLocalizedString(@"route_search.title", nil);
}

#pragma mark - Actions

- (void)cancelBarButtonItemTapped:(UIBarButtonItem *)cancelBarButtomItem {
    [self.delegate routeNewViewControllerDidFinish:self];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.filteredRoutes = [RouteRecord routesMatchingShortNameOrLongName:searchText];
}

#pragma mark - UISearchDisplayDelegate

- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView {
    [tableView registerNib:[UINib nibWithNibName:kRouteRecordCellReuseId bundle:nil] forCellReuseIdentifier:kRouteRecordCellReuseId];
    tableView.rowHeight = ROW_HEIGHT;
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

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RouteRecord *routeRecord = nil;
    if (tableView == self.searchController.searchResultsTableView) {
        routeRecord = [self.filteredRoutes objectAtIndex:indexPath.row];
    } else {
        routeRecord = [self.routes objectAtIndex:indexPath.row];
    }
    [self.delegate routeNewViewController:self didSelectRoute:routeRecord];
}

@end
