#import "AboutViewController.h"
#import "Strings.h"

#define WEB_URL @"http://nextstop.me"
#define TWITTER_URL @"http://twitter.com/nxstop"

#define LINK_SECTION 1
#define LINK_SECTION_TWITTER_ROW 0
#define LINK_SECTION_WEB_ROW 1

@implementation AboutViewController

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != LINK_SECTION) return;
    if (indexPath.row == LINK_SECTION_TWITTER_ROW) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:TWITTER_URL]];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else if (indexPath.row == LINK_SECTION_WEB_ROW) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:WEB_URL]];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return APP_VERSION;
    } else {
        return nil;
    }
}

@end
