#import "AppDefaults.h"
#import "DiagnosticsViewController.h"

#define DIAGNOSTIC_SECTION 0

#define DIAGNOSTIC_SECTION_ENABLE_ROW 0
#define DIAGNOSTIC_SECTION_DISABLE_ROW 1

@implementation DiagnosticsViewController {
    __strong NSIndexPath *_selectedIndexPath;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSInteger row = [AppDefaults canSendDiagnostics] ? DIAGNOSTIC_SECTION_ENABLE_ROW : DIAGNOSTIC_SECTION_DISABLE_ROW;
    _selectedIndexPath = [NSIndexPath indexPathForRow:row inSection:DIAGNOSTIC_SECTION];
    [self check:YES rowAtIndexPath:_selectedIndexPath];
}

- (void)check:(BOOL)check rowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (check) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != DIAGNOSTIC_SECTION) return;
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == _selectedIndexPath.row) return;
    [self check:YES rowAtIndexPath:indexPath];
    [self check:NO rowAtIndexPath:_selectedIndexPath];
    [AppDefaults sendDiagnostics:indexPath.row == DIAGNOSTIC_SECTION_ENABLE_ROW];
    _selectedIndexPath = indexPath;
}

@end
