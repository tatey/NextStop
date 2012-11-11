#import "AppDefaults.h"
#import "DDFileLogger.h"
#import "FileLoggerManager.h"
#import "MoreInfoViewController.h"
#import <Twitter/Twitter.h>
#ifdef SOCIAL_EXTERN
    #import <Social/Social.h>
#endif
#import "Strings.h"

#import <sys/utsname.h>

static NSString* machineName() {
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}

#define APP_URL @"http://nextstop.me"
#define APP_STORE_URL @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=<APP_ID>"
#define SUPPORT_EMAIL @"support@nextstop.me"

@implementation MoreInfoViewController

- (void)contactUs {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] init];
        composeViewController.mailComposeDelegate = self;
        [composeViewController setToRecipients:@[SUPPORT_EMAIL]];
        [composeViewController setSubject:[NSString stringWithFormat:NSLocalizedString(@"more_info.contact_us.subject", nil), APP_VERSION]];
        [composeViewController setMessageBody:[NSString stringWithFormat:@"\n\n\n-----\n%@\n%@\n-----", [[UIDevice currentDevice] systemVersion], machineName()] isHTML:NO];
        if ([AppDefaults canSendDiagnostics]) {
            NSArray *paths = [[[[FileLoggerManager sharedInstance] fileLogger] logFileManager] sortedLogFilePaths];
            if ([paths count] > 0) {
                NSMutableData *data = [NSMutableData data];
                for (NSString *path in paths) {
                    [data appendData:[NSData dataWithContentsOfFile:path]];
                }
                [composeViewController addAttachmentData:data mimeType:@"text/plain" fileName:@"diagnostics.txt"];
            }
        }
        [self presentViewController:composeViewController animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:NSLocalizedString(@"more_info.alerts.titles.no_contact_us", nil), SUPPORT_EMAIL]
                                                        message:NSLocalizedString(@"more_info.alerts.messages.no_contact_us", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"controls.ok", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)tellAFriend {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"more_info.actions.titles.tell_a_friend", nil)
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"controls.cancel", nil)
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:NSLocalizedString(@"more_info.actions.buttons.email", nil), NSLocalizedString(@"more_info.actions.buttons.twitter", nil), NSLocalizedString(@"more_info.actions.buttons.facebook", nil), nil];
    [sheet showInView:self.view];
}

- (void)tellAFriendEmail {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] init];
        composeViewController.mailComposeDelegate = self;
        [composeViewController setSubject:NSLocalizedString(@"more_info.tell_a_friend.subject", nil)];
        [composeViewController setMessageBody:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"more_info.tell_a_friend.message", nil), APP_URL] isHTML:NO];
        [self presentViewController:composeViewController animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"more_info.alerts.titles.no_tell_a_friend_email", nil)
                                                        message:NSLocalizedString(@"more_info.alerts.messages.no_tell_a_friend_email", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"controls.ok", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)tellAFriendFacebook {
    if ([SLComposeViewController class]) {
        SLComposeViewController *composeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [composeViewController setInitialText:NSLocalizedString(@"more_info.tell_a_friend.message", nil)];
        [composeViewController addURL:[NSURL URLWithString:APP_URL]];
        [self presentViewController:composeViewController animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"more_info.alerts.titles.facebook", nil)
                                                        message:NSLocalizedString(@"more_info.alerts.messages.facebook", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"controls.ok", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)tellAFriendTwitter {
    TWTweetComposeViewController *composeViewController = [[TWTweetComposeViewController alloc] init];
    [composeViewController setInitialText:NSLocalizedString(@"more_info.tell_a_friend.message", nil)];
    [composeViewController addURL:[NSURL URLWithString:APP_URL]];
    [self presentViewController:composeViewController animated:YES completion:nil];
}

- (void)leaveAReview {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APP_STORE_URL]];
}

#pragma mark - Actions

- (IBAction)cancelBarButtonItemTapped:(UIBarButtonItem *)cancelBarButtonItem {
    [self.delegate moreInfoViewControlerDidFinish:self];
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

@end
