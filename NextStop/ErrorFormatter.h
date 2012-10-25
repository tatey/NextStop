#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ErrorFormatter : NSObject

@property (strong, nonatomic) NSError *error;

- (id)initWithError:(NSError *)error;

- (UIAlertView *)alert;

- (NSString *)message;
- (NSString *)title;

@end
