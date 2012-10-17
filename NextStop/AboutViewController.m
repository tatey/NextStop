#import "AboutViewController.h"

@implementation AboutViewController

- (void)viewDidLoad {
    self.versionLabel.text = [NSString stringWithFormat:@"v%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
}

- (IBAction)cancelBarButtonItemTapped:(UIBarButtonItem *)cancelBarButtonItem {
    [self.delegate aboutViewControlerDidFinish:self];
}

@end
