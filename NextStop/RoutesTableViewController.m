#import "RoutesTableViewController.h"
#import "RoutesTableViewControllerDelegate.h"

@implementation RoutesTableViewController

@synthesize delegate = _delegate;
@synthesize routes = _routes;

- (id)init {
    self = [super init];
    if (self) {
        self.routes = [NSArray array];
    }
    return self;
}

- (id)initWithDelegate:(id <RoutesTableViewDelegate>)delegate {
    self = [self init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.routes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ResueID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ResueID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ResueID];
    }
    Route *route = [self.routes objectAtIndex:indexPath.row];
    cell.textLabel.text = route.shortName;
    cell.detailTextLabel.text = route.longName;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Route *route = [self.routes objectAtIndex:indexPath.row];
    [self.delegate routesTableViewController:self didSelectRoute:route];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.routes = [Route routesMatchingShortNameOrLongName:searchText];
}

@end
