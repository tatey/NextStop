#import <UIKit/UIKit.h>

typedef enum {
    TrackButtonNoneState,
    TrackButtonUserState,
    TrackButtonStopState
} TrackButtonState;

@protocol TrackButtonDelegate;

@interface TrackButton : UIView

@property (strong, nonatomic) UIButton *button;
@property (weak, nonatomic) id <TrackButtonDelegate> delegate;
@property (assign, nonatomic) TrackButtonState state;

@end

@protocol TrackButtonDelegate <NSObject>

- (void)trackButton:(TrackButton *)trackButton didChangeState:(TrackButtonState)state;

@end
