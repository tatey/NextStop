#import "RoutesTableViewController.h"
#import "TripsViewController.h"

@implementation TripsViewController

@synthesize direction = _direction;
@synthesize directionControl = _directionControl;
@synthesize routesController = _routesController;
@synthesize searchBar = _searchBar;
@synthesize searchController = _searchController;
@synthesize tableView = _tableView;
@synthesize trips = _trips;

- (id)initWithDirection:(RouteDirection)direction {
    self = [super init];
    if (self) {
        self.direction = direction;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.directionControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:NSLocalizedString(RouteDirectionToString(RouteInboundDirection), nil), NSLocalizedString(RouteDirectionToString(RouteOutboundDirection), nil), nil]];
    self.directionControl.segmentedControlStyle = UISegmentedControlStyleBar;
    self.directionControl.selectedSegmentIndex = self.direction;
    [self.directionControl addTarget:self action:@selector(directionControlValueDidChange:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = self.directionControl;
    self.routesController = [[RoutesTableViewController alloc] init];
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    self.searchBar.delegate = self.routesController;
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

#pragma mark - Actions

- (void)directionControlValueDidChange:(UISegmentedControl *)control {
    RouteDirection direction = control.selectedSegmentIndex;
    self.direction = direction;
    self.routesController.direction = direction;
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
