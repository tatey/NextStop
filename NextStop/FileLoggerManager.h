#import <Foundation/Foundation.h>

@class DDFileLogger;

@interface FileLoggerManager : NSObject

@property (strong, nonatomic) DDFileLogger *fileLogger;

+ (id)sharedInstance;

@end
