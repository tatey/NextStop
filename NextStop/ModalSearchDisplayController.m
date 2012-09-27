#import <QuartzCore/QuartzCore.h>
#import "ModalSearchDisplayController.h"

#define SEARCHBAR_HEIGHT 44

@implementation ModalSearchDisplayController {
    UIModalPresentationStyle _originalModalPresentationStyle;
}

- (id)initWithViewController:(UIViewController *)viewController {
    self = [self init];
    if (self) {
        self.viewController = viewController;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = nil;
    // Dimming button
    self.dimmingButton = [[UIButton alloc] initWithFrame:self.view.bounds];
    self.dimmingButton.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.dimmingButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
    [self.dimmingButton addTarget:self action:@selector(dimmingButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.dimmingButton];
    // Table view
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SEARCHBAR_HEIGHT, self.view.bounds.size.width, self.view.bounds.size.height - SEARCHBAR_HEIGHT)];
    self.tableView.autoresizesSubviews = UIViewAutoresizingNone;
    self.tableView.dataSource = self.searchResultsDataSource;
    self.tableView.delegate = self.searchResultsDelegate;
    self.tableView.hidden = YES;
    [self.view addSubview:self.tableView];
    // Search bar
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, SEARCHBAR_HEIGHT)];
    self.searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.searchBar.backgroundImage = [UIImage imageNamed:@"SearchBarBackground.png"];
    self.searchBar.clipsToBounds = YES;
    self.searchBar.showsCancelButton = YES;
    self.searchBar.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.searchBar.layer.shadowOffset = CGSizeMake(0, 1);
    self.searchBar.layer.shadowRadius = 1.0;
    self.searchBar.layer.shadowOpacity = 0.275;
    for (id view in self.searchBar.subviews) {
        if ([view isKindOfClass:[UITextField class]]) {
            [view addTarget:self action:@selector(searchBarTextDidChange:) forControlEvents:UIControlEventEditingChanged];
            break;
        }
    }
    [self.view addSubview:self.searchBar];
    [self.delegate modalSearchDisplayController:self didLoadSearchBar:self.searchBar];
}

- (void)viewDidUnload {
    self.dimmingButton = nil;
    self.searchBar = nil;
    self.tableView = nil;
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setActive:(BOOL)active {
    [self setActive:active animated:NO];
}

- (void)setActive:(BOOL)active animated:(BOOL)animated {
    _active = active;
    [UIView setAnimationsEnabled:animated];
    if (_active) {
        _originalModalPresentationStyle = self.viewController.parentViewController.modalTransitionStyle;
        self.viewController.parentViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self.viewController presentViewController:self animated:NO completion:nil];
        [self.searchBar becomeFirstResponder];
    } else {
        self.viewController.parentViewController.modalPresentationStyle = _originalModalPresentationStyle;
        [self.searchBar resignFirstResponder];
    }
}

- (void)appear {
    CGRect visibleSearchBarFrame = self.searchBar.frame;
    visibleSearchBarFrame.origin.y = 0;
    self.searchBar.frame = visibleSearchBarFrame;
    self.dimmingButton.alpha = 1.0;
    CGRect visibleTableViewFrame = self.tableView.frame;
    visibleTableViewFrame.origin.y = SEARCHBAR_HEIGHT;
    self.tableView.frame = visibleTableViewFrame;
    self.tableView.alpha = 1.0;
}

- (void)disappear {
    CGRect hiddenSearchBarFrame = self.searchBar.frame;
    hiddenSearchBarFrame.origin.y = -hiddenSearchBarFrame.size.height;
    self.searchBar.frame = hiddenSearchBarFrame;
    self.dimmingButton.alpha = 0.0;
    CGRect hiddenTableViewFrame = self.tableView.frame;
    hiddenTableViewFrame.origin.y = -SEARCHBAR_HEIGHT;
    self.tableView.frame = hiddenTableViewFrame;
    self.tableView.alpha = 0.0;
}

#pragma mark - Actions

- (void)dimmingButtonTouched:(UIButton *)dimmingButton {
    [self setActive:NO animated:YES];
}

- (void)searchBarTextDidChange:(UITextField *)textField {
    [self.tableView reloadData];
    BOOL hidden = [textField.text length] <= 0 || [self.tableView.visibleCells count] <= 0;
    self.searchBar.clipsToBounds = hidden;
    self.tableView.hidden = hidden;
}

#pragma mark - Notifications

- (void)keyboardDidShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    CGFloat height = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, height, 0);
    self.tableView.contentInset = insets;
    self.tableView.scrollIndicatorInsets = insets;    
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    UIViewAnimationCurve curve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGFloat duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [self disappear];
    [UIView animateWithDuration:duration delay:0 options:curve animations:^{
        [self appear];
    } completion:^(BOOL finished) {
        [UIView setAnimationsEnabled:YES];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    UIViewAnimationCurve curve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGFloat duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration delay:0 options:curve animations:^{
        [self disappear];
    } completion:^(BOOL finished) {
        [UIView setAnimationsEnabled:YES];
        [self.viewController dismissModalViewControllerAnimated:NO];
    }];
}

@end
