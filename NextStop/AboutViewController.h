#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol AboutViewControllerDelegate;

@interface AboutViewController : UITableViewController

@property (weak, nonatomic) id <AboutViewControllerDelegate> delegate;

- (IBAction)cancelBarButtonItemTapped:(UIBarButtonItem *)cancelBarButtonItem;

@end

@protocol AboutViewControllerDelegate

- (void)aboutViewControlerDidFinish:(AboutViewController *)controller;

@end
