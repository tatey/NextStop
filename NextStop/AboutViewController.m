#import "AboutViewController.h"

#define WEB_URL @"http://nextstop.me"
#define TWITTER_URL @"http://twitter.com/nxstop"

@implementation AboutViewController

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:TWITTER_URL]];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:WEB_URL]];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

@end
