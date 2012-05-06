#import <Foundation/Foundation.h>
#import <sqlite3.h>

typedef enum {
    TripInboundDirection,
    TripOutboundDirection,
} TripDirection;

static inline NSString * RouteDirectionToString(TripDirection direction) {
    switch (direction) {
        case TripInboundDirection:
            return @"trip.directions.inbound";
        case TripOutboundDirection:
            return @"trip.directions.outbound";
    }
}

@interface Trip : NSObject {
@private
    NSString *_code;
    NSString *_name;
    NSUInteger _primaryKey;
}

@property (readonly) NSString *code;
@property (readonly) NSString *name;
@property (readonly) NSUInteger primaryKey;

+ (NSArray *)tripsMatchingCodeOrName:(NSString *)codeOrName;

- (id)initWithStatement:(sqlite3_stmt *)stmt;

@end
