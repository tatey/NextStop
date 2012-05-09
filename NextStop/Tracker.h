#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

typedef enum {
    TrackerAccuracyBestLocationMode,
    TrackerPowerConservationLocationMode,
} TrackerLocationMode;

@protocol TrackerDelegate;

@interface Tracker : NSObject <CLLocationManagerDelegate, NSCoding>

@property (weak, nonatomic) id <TrackerDelegate> delegate;

@property (assign, nonatomic) CLLocationCoordinate2D current;
@property (assign, nonatomic) CLLocationCoordinate2D target;

@property (readonly) BOOL isMonitoringProximityToTarget;
@property (readonly) BOOL isUpdatingCurrent;

- (id)initWithDelegate:(id <TrackerDelegate>)delegate;

- (void)startMonitoringProximityToTarget;
- (void)stopMonitoringProximityToTarget;

- (void)startUpdatingCurrent:(TrackerLocationMode)mode;
- (void)stopUpdatingCurrent;

@end
