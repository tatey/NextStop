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
    // Search bar
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, SEARCHBAR_HEIGHT)];
    self.searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.searchBar.showsCancelButton = YES;
    [self.view addSubview:self.searchBar];
    [self.delegate modalSearchDisplayController:self didLoadSearchBar:self.searchBar];
}

- (void)viewDidUnload {
    self.dimmingButton = nil;
    self.searchBar = nil;
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
    CGRect visibleFrame = self.searchBar.frame;
    visibleFrame.origin.y = 0;
    self.searchBar.frame = visibleFrame;
    self.dimmingButton.alpha = 1.0;
}

- (void)disappear {
    CGRect hiddenFrame = self.searchBar.frame;
    hiddenFrame.origin.y = -hiddenFrame.size.height;
    self.searchBar.frame = hiddenFrame;
    self.dimmingButton.alpha = 0.0;
}

#pragma mark - Actions

- (void)dimmingButtonTouched:(UIButton *)dimmingButton {
    [self setActive:NO animated:YES];
}

#pragma mark - Notifications

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
