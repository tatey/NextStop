#import "AboutViewController.h"

@implementation AboutViewController

- (IBAction)cancelBarButtonItemTapped:(UIBarButtonItem *)cancelBarButtonItem {
    [self.delegate aboutViewControlerDidFinish:self];
}

@end
