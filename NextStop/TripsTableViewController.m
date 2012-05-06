#import "TripsTableViewController.h"

@implementation TripsTableViewController

@synthesize trips = _trips;

- (id)init {
    self = [super init];
    if (self) {
        self.trips = [NSArray array];
    }
    return self;
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
    Trip *trip = [self.trips objectAtIndex:indexPath.row];
    cell.textLabel.text = trip.code;
    cell.detailTextLabel.text = trip.name;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.trips = [Trip tripsMatchingCodeOrName:searchText];
}

@end
