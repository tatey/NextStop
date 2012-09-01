#import "TrackButton.h"

static TrackButtonState TrackButtonStateNext(TrackButtonState state) {
    if (state == TrackButtonStopState) {
        return TrackButtonNoneState;
    } else {
        return state + 1;
    }
}

@implementation TrackButton

@synthesize button = _button;
@synthesize delegate = _delegate;
@synthesize state = _state;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.button.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        self.button.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self.button addTarget:self action:@selector(buttonDidTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.button];
        self.state = TrackButtonNoneState;
    }
    return self;
}

- (void)setState:(TrackButtonState)state {
    _state = state;
    switch (state) {
        case TrackButtonNoneState:
            self.button.backgroundColor = [UIColor colorWithRed:0.2902 green:0.4235 blue:0.6078 alpha:1.0000];
            [self.button setImage:[UIImage imageNamed:@"LocationArrow"] forState:UIControlStateNormal];
            break;
        case TrackButtonUserState:
            self.button.backgroundColor = [UIColor colorWithRed:0.5843 green:0.6510 blue:0.7373 alpha:1.0000];
            [self.button setImage:[UIImage imageNamed:@"LocationArrow"] forState:UIControlStateNormal];
            break;
        case TrackButtonStopState:
            self.button.backgroundColor = [UIColor colorWithRed:0.5843 green:0.6510 blue:0.7373 alpha:1.0000];
            [self.button setImage:[UIImage imageNamed:@"Pin"] forState:UIControlStateNormal];
            break;
    }
}

- (void)buttonDidTouchUpInside:(UIButton *)button {
    self.state = TrackButtonStateNext(self.state);
    [self.delegate trackButton:self didChangeState:self.state];
}

@end
