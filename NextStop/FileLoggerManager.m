#import "DDFileLogger.h"
#import "FileLoggerManager.h"

@implementation FileLoggerManager

+ (id)sharedInstance {
    static dispatch_once_t predicate;
	static FileLoggerManager *_sharedInstance = nil;
	dispatch_once(&predicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        self.fileLogger = [[DDFileLogger alloc] init];
    }
    return self;
}

@end
