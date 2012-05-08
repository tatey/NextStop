#import <Foundation/Foundation.h>
#import <sqlite3.h>

typedef enum {
    TripInboundHeading,
    TripOutboundHeading,
    TripUnknownHeading,
} TripHeading;

static inline NSString * TripHeadingToLocalizableString(TripHeading heading) {
    switch (heading) {
        case TripInboundHeading:
            return @"trip.headings.inbound";
        case TripOutboundHeading:
            return @"trip.headings.outbound";
        case TripUnknownHeading:
            return @"trip.headings.unknown";
    }
}

@class Route;

@interface Trip : NSObject

@property (readonly) NSString *longName;
@property (readonly) NSUInteger primaryKey;
@property (readonly) NSString *shortName;
@property (readonly) TripHeading heading;

+ (NSArray *)tripsBelongingToRoute:(Route *)route;

- (NSArray *)stops;

@end
