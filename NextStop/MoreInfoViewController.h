#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import <UIKit/UIKit.h>

@protocol MoreInfoViewControllerDelegate;

@interface MoreInfoViewController : UITableViewController <MFMailComposeViewControllerDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) id <MoreInfoViewControllerDelegate> delegate;

- (IBAction)cancelBarButtonItemTapped:(UIBarButtonItem *)cancelBarButtonItem;

@end

@protocol MoreInfoViewControllerDelegate

- (void)moreInfoViewControlerDidFinish:(MoreInfoViewController *)controller;

@end
