#import "JourneysViewController.h"
#import "TripsTableViewController.h"

@implementation JourneysViewController

@synthesize journeys = _journeys;
@synthesize searchBar = _searchBar;
@synthesize searchController = _searchController;
@synthesize tableView = _tableView;
@synthesize tripsController = _tripsController;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tripsController = [[TripsTableViewController alloc] init];
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    self.searchBar.delegate = self.tripsController;
    self.searchBar.placeholder = NSLocalizedString(@"journeys.search.placeholder", nil);
    self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.searchController.searchResultsDataSource = self.tripsController;
    self.searchController.searchResultsDelegate = self.tripsController;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 416) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}

- (void)viewDidUnload {
    self.tripsController = nil;
    self.searchBar = nil;
    self.searchController = nil;
    self.tableView = nil;
    [super viewDidUnload];
}

- (NSString *)title {
    return NSLocalizedString(@"journeys.title", nil);
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.journeys count];
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
