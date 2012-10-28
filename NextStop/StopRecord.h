#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "SQLiteDB.h"

@class DirectionRecord;

@interface StopRecord : NSObject <MKAnnotation>

@property (readonly) NSString *name;
@property (readonly) NSString *stopId;

+ (NSArray *)stopsBelongingToDirection:(DirectionRecord *)direction;
+ (NSArray *)stopsBelongingToDirection:(DirectionRecord *)direction likeName:(NSString *)name;
+ (id)stopMatchingStopId:(NSString *)stopId;

- (id)initWithStatement:(sqlite3_stmt *)stmt;

- (BOOL)isEqualToStop:(StopRecord *)stop;

@end
