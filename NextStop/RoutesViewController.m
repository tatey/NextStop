#import "Route.h"
#import "RoutesViewController.h"

@implementation RoutesViewController

@synthesize routes = _routes;
@synthesize searchBar = _searchBar;
@synthesize searchController = _searchController;
@synthesize tableView = _tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    self.searchBar.delegate = self;
    self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.searchController.searchResultsDataSource = self;
    self.searchController.searchResultsDelegate = self;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, 416) style:UITableViewStylePlain];
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.tableView];
}

- (void)viewDidUnload {
    self.searchBar = nil;
    self.searchController = nil;
    self.tableView = nil;
    [super viewDidUnload];
}

- (NSString *)title {
    return NSLocalizedString(@"routes.title", nil);
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.routes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kResueID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kResueID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kResueID];
    }
    Route *route = [self.routes objectAtIndex:indexPath.row];
    cell.textLabel.text = route.code;
    cell.detailTextLabel.text = route.name;
    return cell;
}

#pragma mark - UITableViewDelegate

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.routes = [Route routesMatchingCodeOrName:searchText];
}

@end
