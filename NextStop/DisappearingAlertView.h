#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DisappearingAlertView : UIView

@property (assign, nonatomic) NSTimeInterval duration;
@property (copy, nonatomic) NSString *message;

- (id)initWithFrame:(CGRect)frame duration:(NSTimeInterval)duration message:(NSString *)message;

- (void)hideAnimated:(BOOL)animated;
- (void)showAnimated:(BOOL)animated;

@end
