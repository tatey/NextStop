#import "RouteRecord.h"
#import "RouteRecordCell.h"
#import "RoutesTableViewController.h"
#import "RoutesTableViewControllerDelegate.h"

static NSString *kRouteRecordCellReuseId = @"RouteRecordCell";

@implementation RoutesTableViewController

@synthesize delegate = _delegate;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize routes = _routes;
@synthesize searchDisplayController = _searchDisplayController;

- (id)init {
    self = [super init];
    if (self) {
        self.routes = [NSArray array];
    }
    return self;
}

- (id)initWithSearchBar:(UISearchBar *)searchBar contentsController:(UIViewController *)viewController managedObjectContext:(NSManagedObjectContext *)context {
    self = [self init];
    if (self) {
        searchBar.delegate = self;
        self.managedObjectContext = context;
        self.searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:viewController];
        self.searchDisplayController.delegate = self;
        self.searchDisplayController.searchResultsDataSource = self;
        self.searchDisplayController.searchResultsDelegate = self;
    }
    return self;
}

- (void)setSearchDisplayControllerActive:(BOOL)active {
    self.searchDisplayController.active = active;
}

#pragma mark - UISearchDisplayDelegate

- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView {
    [tableView registerNib:[UINib nibWithNibName:kRouteRecordCellReuseId bundle:nil] forCellReuseIdentifier:kRouteRecordCellReuseId];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.routes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RouteRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:kRouteRecordCellReuseId];
    cell.routeRecord = [self.routes objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RouteRecord *route = [self.routes objectAtIndex:indexPath.row];
    [self.delegate routesTableViewController:self didSelectRoute:route];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.routes = [RouteRecord routesMatchingShortNameOrLongName:searchText];
}

@end
