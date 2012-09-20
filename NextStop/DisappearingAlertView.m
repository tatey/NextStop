#import "DisappearingAlertView.h"

#define BORDER_WIDTH 1
#define DURATION 0.3
#define FONT_SIZE 14
#define MAX_HEIGHT 999
#define PADDING 7

@interface DisappearingAlertView ()

@property (strong, nonatomic) UIView *borderBottom;
@property (strong, nonatomic) UILabel *messageLabel;

@end

@implementation DisappearingAlertView

// Public
@synthesize duration = _duration;
@synthesize message = _message;

// Private
@synthesize borderBottom = _borderBottom;
@synthesize messageLabel = _messageLabel;

- (id)initWithFrame:(CGRect)frame duration:(NSTimeInterval)duration message:(NSString *)message {
    self = [self initWithFrame:frame];
    if (self) {
        // Border bottom
        self.borderBottom = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - BORDER_WIDTH, frame.size.width, BORDER_WIDTH)];
        self.borderBottom.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        self.borderBottom.backgroundColor = [UIColor colorWithRed:0.2275 green:0.2667 blue:0.3176 alpha:1.0000];
        [self addSubview:self.borderBottom];
        // Message label
        self.messageLabel = [[UILabel alloc] initWithFrame:frame];
        self.messageLabel.backgroundColor = [UIColor clearColor];
        self.messageLabel.numberOfLines = 0;
        self.messageLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
        self.messageLabel.textAlignment = UITextAlignmentCenter;
        self.messageLabel.textColor = [UIColor whiteColor];
        self.messageLabel.shadowColor = [UIColor colorWithRed:0.2275 green:0.2667 blue:0.3176 alpha:1.0000];
        self.messageLabel.shadowOffset = CGSizeMake(0, -1);
        [self addSubview:self.messageLabel];
        // Properties
        self.backgroundColor = [UIColor colorWithRed:0.2863 green:0.4275 blue:0.6000 alpha:0.8];
        self.duration = duration;
        self.message = message;
        // Hide, ready to roll
        [self hideWillStart];
    }
    return self;
}

- (void)sizeToFit {
    CGSize size = [_message sizeWithFont:self.messageLabel.font constrainedToSize:CGSizeMake(self.bounds.size.width, MAX_HEIGHT)];
    self.messageLabel.frame = CGRectMake(0, PADDING, self.bounds.size.width, size.height);
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, size.height + (PADDING * 2));
}

- (void)setMessage:(NSString *)message {
    _message = message;
    self.messageLabel.text = message;
    [self sizeToFit];
}

- (void)hideAnimated:(BOOL)animated {
    if (animated) {
        [DisappearingAlertView animateWithDuration:DURATION delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self hideWillStart];
        } completion:^(BOOL finished) {
            [self hideWillComplete];
        }];
    } else {
        [self hideWillStart];
        [self hideWillComplete];
    }
}

- (void)showAnimated:(BOOL)animated {
    if (animated) {
        [DisappearingAlertView animateWithDuration:DURATION delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self showWillStart];
        } completion:^(BOOL finished) {
            [self showWillComplete];
        }];
    } else {
        [self showWillStart];
        [self showWillComplete];
    }
}

- (void)hideWillStart {
    CGRect frame = self.frame;
    frame.origin.y = -frame.size.height;
    self.frame = frame;
}

- (void)hideWillComplete {
    [self removeFromSuperview];
}

- (void)showWillStart {
    CGRect frame = self.frame;
    frame.origin.y = 0;
    self.frame = frame;
}

- (void)showWillComplete {
    [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(timerDidFire:) userInfo:nil repeats:NO];
}

- (void)timerDidFire:(NSTimer *)timer {
    [self hideAnimated:YES];
}

@end
