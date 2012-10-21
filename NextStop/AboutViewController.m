#import "AboutViewController.h"

#define APP_STORE_URL @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=<APP_ID>"
#define RECIPIENT @"support@nextstop.me"

@implementation AboutViewController

- (void)viewDidLoad {
    self.versionLabel.text = [NSString stringWithFormat:@"v%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
}

- (void)contactUs {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] init];
        composeViewController.mailComposeDelegate = self;
        [composeViewController setToRecipients:@[RECIPIENT]];
        [self presentViewController:composeViewController animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:NSLocalizedString(@"about.alerts.titles.contact_us", nil), RECIPIENT] message:NSLocalizedString(@"about.alerts.messages.contact_us", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"controls.ok", nil) otherButtonTitles:nil];
        [alert show];
    }
}

- (void)leaveAReview {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APP_STORE_URL]];
}

#pragma mark - Actions

- (IBAction)cancelBarButtonItemTapped:(UIBarButtonItem *)cancelBarButtonItem {
    [self.delegate aboutViewControlerDidFinish:self];
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 0) {
        [self contactUs];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        [self leaveAReview];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

@end
