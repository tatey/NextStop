#import "RoutesTableViewController.h"
#import "TripsViewController.h"

@implementation TripsViewController

@synthesize routesController = _routesController;
@synthesize searchBar = _searchBar;
@synthesize searchController = _searchController;
@synthesize tableView = _tableView;
@synthesize trips = _trips;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.routesController = [[RoutesTableViewController alloc] init];
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    self.searchBar.delegate = self.routesController;
    self.searchBar.placeholder = NSLocalizedString(@"trips.search.placeholder", nil);
    self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.searchController.searchResultsDataSource = self.routesController;
    self.searchController.searchResultsDelegate = self.routesController;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 416) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}

- (void)viewDidUnload {
    self.routesController = nil;
    self.searchBar = nil;
    self.searchController = nil;
    self.tableView = nil;
    [super viewDidUnload];
}

- (NSString *)title {
    return NSLocalizedString(@"trips.title", nil);
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.trips count];
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
