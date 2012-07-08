#import <Foundation/Foundation.h>

typedef enum {
    TripRecordInboundDirection,
    TripRecordOutboundDirection,
    TripRecordCounterClockwiseDirection,
    TripRecordClockwiseDirection,
    TripRecordInwardDirection,
    TripRecordOutwardDirection,
    TripRecordSouthDirection,
    TripRecordNorthDirection,
    TripRecordEastDirection,
    TripRecordWestDirection,
    TripRecordUnknownDirection,
} TripRecordDirection;

static NSString * TripRecordDirectionToLocalizableString(TripRecordDirection direction) {
    switch (direction) {
        case TripRecordInboundDirection:
            return @"trip_record.directions.inbound";
        case TripRecordOutboundDirection:
            return @"trip_record.directions.outbound";
        case TripRecordCounterClockwiseDirection:
            return @"trip_record.directions.counter_clockwise";
        case TripRecordClockwiseDirection:
            return @"trip_record.directions.clockwise";
        case TripRecordInwardDirection:
            return @"trip_record.directions.inward";
        case TripRecordOutwardDirection:
            return @"trip_record.directions.outward";
        case TripRecordSouthDirection:
            return @"trip_record.directions.south";
        case TripRecordNorthDirection:
            return @"trip_record.directions.north";
        case TripRecordEastDirection:
            return @"trip_record.directions.east";
        case TripRecordWestDirection:
            return @"trip_record.directions.west";
        default:
            return @"trip_record.directions.unknown";
    }
}

@class RouteRecord;

@interface TripRecord : NSObject

@property (readonly) NSUInteger primaryKey;
@property (readonly) TripRecordDirection direction;

+ (NSArray *)tripsBelongingToRoute:(RouteRecord *)route;

- (NSArray *)stops;

@end
