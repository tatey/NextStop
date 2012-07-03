#import <Foundation/Foundation.h>

typedef enum {
    TripInboundDirection,
    TripOutboundDirection,
    TripCounterClockwiseDirection,
    TripClockwiseDirection,
    TripInwardDirection,
    TripOutwardDirection,
    TripSouthDirection,
    TripNorthDirection,
    TripEastDirection,
    TripWestDirection,
    TripUnknownDirection,
} TripDirection;

static NSString * TripDirectionToLocalizableString(TripDirection direction) {
    switch (direction) {
        case TripInboundDirection:
            return @"trip.directions.inbound";
        case TripOutboundDirection:
            return @"trip.directions.outbound";
        case TripCounterClockwiseDirection:
            return @"trip.directions.counter_clockwise";
        case TripClockwiseDirection:
            return @"trip.directions.clockwise";
        case TripInwardDirection:
            return @"trip.directions.inward";
        case TripOutwardDirection:
            return @"trip.directions.outward";
        case TripSouthDirection:
            return @"trip.directions.south";
        case TripNorthDirection:
            return @"trip.directions.north";
        case TripEastDirection:
            return @"trip.directions.east";
        case TripWestDirection:
            return @"trip.directions.west";
        default:
            return @"trip.directions.unknown";
    }
}

@class Route;

@interface Trip : NSObject

@property (readonly) NSUInteger primaryKey;
@property (readonly) TripDirection direction;

+ (NSArray *)tripsBelongingToRoute:(Route *)route;

- (NSArray *)stops;

@end
