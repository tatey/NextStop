#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol ModalSearchDisplayControllerDelegate;

@interface ModalSearchDisplayController : UIViewController

@property (assign, nonatomic, getter=isActive) BOOL active;
@property (weak, nonatomic) id <ModalSearchDisplayControllerDelegate> delegate;
@property (weak, nonatomic) id <UITableViewDataSource> searchResultsDataSource;
@property (weak, nonatomic) id <UITableViewDelegate> searchResultsDelegate;
@property (weak, nonatomic) UIViewController *viewController;

@property (strong, nonatomic) UIButton *dimmingButton;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UITableView *tableView;

- (id)initWithViewController:(UIViewController *)viewController;

- (void)setActive:(BOOL)active animated:(BOOL)animated;

@end

@protocol ModalSearchDisplayControllerDelegate <NSObject>

- (void)modalSearchDisplayController:(ModalSearchDisplayController *)controller didLoadSearchBar:(UISearchBar *)searchBar;

@end
