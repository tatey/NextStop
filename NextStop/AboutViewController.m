#import <Twitter/Twitter.h>
#ifdef SOCIAL_EXTERN
    #import <Social/Social.h>
#endif
#import "AboutViewController.h"

#define VERSION [NSString stringWithFormat:@"v%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]

#define CONTACT_US_MAIL_RECIPIENT @"support@nextstop.me"
#define CONTACT_US_MAIL_SUBJECT [NSString stringWithFormat:@"Next Stop %@ Feedback", VERSION]

#define TELL_A_FRIEND_MAIL_SUBJECT @"Check out Next Stop"
#define TELL_A_FRIEND_TEXT @"I am never going to miss my bus stop again."
#define TELL_A_FRIEND_URL @"http://nextstop.me"

#define APP_STORE_URL @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=<APP_ID>"

@implementation AboutViewController

- (void)contactUs {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] init];
        composeViewController.mailComposeDelegate = self;
        [composeViewController setToRecipients:@[CONTACT_US_MAIL_RECIPIENT]];
        [composeViewController setSubject:CONTACT_US_MAIL_SUBJECT];
        [self presentViewController:composeViewController animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:NSLocalizedString(@"about.alerts.titles.no_contact_us", nil), CONTACT_US_MAIL_RECIPIENT]
                                                        message:NSLocalizedString(@"about.alerts.messages.no_contact_us", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"controls.ok", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)tellAFriend {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"about.actions.titles.tell_a_friend", nil)
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"controls.cancel", nil)
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:NSLocalizedString(@"about.actions.buttons.email", nil), NSLocalizedString(@"about.actions.buttons.twitter", nil), NSLocalizedString(@"about.actions.buttons.facebook", nil), nil];
    [sheet showInView:self.view];
}

- (void)tellAFriendEmail {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] init];
        composeViewController.mailComposeDelegate = self;
        [composeViewController setSubject:TELL_A_FRIEND_MAIL_SUBJECT];
        [composeViewController setMessageBody:[NSString stringWithFormat:@"%@ %@", TELL_A_FRIEND_TEXT, TELL_A_FRIEND_URL] isHTML:NO];
        [self presentViewController:composeViewController animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"about.alerts.titles.no_tell_a_friend_email", nil)
                                                        message:NSLocalizedString(@"about.alerts.messages.no_tell_a_friend_email", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"controls.ok", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)tellAFriendFacebook {
    if ([SLComposeViewController class]) {
        SLComposeViewController *composeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [composeViewController setInitialText:TELL_A_FRIEND_TEXT];
        [composeViewController addURL:[NSURL URLWithString:TELL_A_FRIEND_URL]];
        [self presentViewController:composeViewController animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"about.alerts.titles.facebook", nil)
                                                        message:NSLocalizedString(@"about.alerts.messages.facebook", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"controls.ok", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)tellAFriendTwitter {
    TWTweetComposeViewController *composeViewController = [[TWTweetComposeViewController alloc] init];
    [composeViewController setInitialText:TELL_A_FRIEND_TEXT];
    [composeViewController addURL:[NSURL URLWithString:TELL_A_FRIEND_URL]];
    [self presentViewController:composeViewController animated:YES completion:nil];
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

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self tellAFriendEmail];
            break;
        case 1:
            [self tellAFriendTwitter];
            break;
        case 2:
            [self tellAFriendFacebook];
            break;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 0) {
        [self contactUs];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        [self tellAFriend];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else if (indexPath.section == 1 && indexPath.row == 2) {
        [self leaveAReview];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return VERSION;
    } else {
        return nil;
    }
}

@end
