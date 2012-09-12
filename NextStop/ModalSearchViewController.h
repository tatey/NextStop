#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol ModalSearchViewControllerDelegate;

@interface ModalSearchViewController : UIViewController

@property (assign, nonatomic, getter=isActive) BOOL active;
@property (weak, nonatomic) id <ModalSearchViewControllerDelegate> delegate;
@property (weak, nonatomic) UIViewController *viewController;

@property (strong, nonatomic) UIButton *dimmingButton;
@property (strong, nonatomic) UISearchBar *searchBar;

- (id)initWithViewController:(UIViewController *)viewController;

- (void)setActive:(BOOL)active animated:(BOOL)animated;

@end

@protocol ModalSearchViewControllerDelegate <NSObject>

- (void)modalSearchViewControllerDelegate:(ModalSearchViewController *)controller didLoadSearchBar:(UISearchBar *)searchBar;

@end
