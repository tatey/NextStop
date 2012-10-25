#import "ErrorFormatter.h"

@implementation ErrorFormatter

- (id)initWithError:(NSError *)error {
    self = [self init];
    if (self) {
        self.error = error;
    }
    return self;
}

- (UIAlertView *)alert {
    return [[UIAlertView alloc] initWithTitle:[self title]
                                      message:[self message]
                                     delegate:nil
                            cancelButtonTitle:NSLocalizedString(@"controls.ok", nil)
                            otherButtonTitles:nil];
}

- (NSString *)message {
    return [[NSBundle mainBundle] localizedStringForKey:[self keyWithType:@"message"]
                                                  value:[self defaultMessage]
                                                  table:nil];
}

- (NSString *)title {
    return [[NSBundle mainBundle] localizedStringForKey:[self keyWithType:@"title"]
                                                  value:[self defaultTitle]
                                                  table:nil];
}

- (NSString *)defaultMessage {
    if ([self.error localizedRecoverySuggestion]) {
        return [self.error localizedRecoverySuggestion];
    } else {
        return [self.error localizedDescription];
    }
}


- (NSString *)defaultTitle {
    if ([self.error localizedFailureReason]) {
        return [self.error localizedFailureReason];
    } else {
        return NSLocalizedString(@"errors.title", nil);
    }
}

- (NSString *)keyWithType:(NSString *)type {
    return [NSString stringWithFormat:@"errors.%@.%d.%@", self.error.domain, self.error.code, type];
}

@end
