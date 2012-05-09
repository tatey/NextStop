#import <Foundation/Foundation.h>

@class Tracker;

@protocol TrackerDelegate <NSObject>

- (void)trackerCurrentDidBecomeInProximityToTarget:(Tracker *)tracker;

@end
