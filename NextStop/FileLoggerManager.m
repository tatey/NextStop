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
        self.fileLogger.rollingFrequency = -1; // Do not roll based on time
        self.fileLogger.maximumFileSize = (1024 * 10); // 10kb
        self.fileLogger.logFileManager.maximumNumberOfLogFiles = 2;
    }
    return self;
}

@end
