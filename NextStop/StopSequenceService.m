#import "DirectionRecord.h"
#import "Haversin.h"
#import "StopSequenceService.h"
#import "StopRecord.h"
#import "SQLiteDB.h"

#define QUERY @"SELECT stops.* "                                                 \
               "FROM stops "                                                     \
               "INNER JOIN directions_stops ds1 ON ds1.stop_id = stops.stop_id " \
               "  AND ds1.direction = ? "                                        \
               "  AND ds1.route_id = ? "                                         \
               "WHERE ds1.stop_sequence = ( "                                    \
               "  SELECT ds2.stop_sequence - 1 "                                 \
               "  FROM directions_stops ds2 "                                    \
               "  WHERE ds2.stop_id = ? "                                        \
               "    AND ds2.direction = ? "                                      \
               "    AND ds2.route_id = ? "                                       \
               "  ) "                                                            \
               "ORDER BY ds1.stop_sequence ASC; "                                \

@implementation StopSequenceService

+ (CLLocationDistance)distanceBetweenClosestPreviouStopFromStop:(StopRecord *)stop inDirection:(DirectionRecord *)direction {
    NSArray *previousStops = [self previousStopsFromStop:stop inDirection:direction];
    if ([previousStops count] == 0) {
        return -1;
    } else {
        CLLocationDistance minDistance = MAXFLOAT;
        for (StopRecord *previousStop in previousStops) {
            CLLocationDistance distance = Haversin(stop.coordinate, previousStop.coordinate);
            if (distance < minDistance) {
                minDistance = distance;
            }
        }
        return minDistance;
    }
}

+ (CLLocationDistance)notificationDistanceFromRawDistance:(CLLocationDistance)rawDistance {
    CLLocationDistance diminishedDistance = rawDistance * 0.85;
    if (rawDistance == -1) {
        return 350.0;
    } else if (diminishedDistance < 50) {
        return 50.0;
    } else if (diminishedDistance > 1000) {
        return 1000;
    } else {
        return diminishedDistance;
    }
}

+ (NSArray *)previousStopsFromStop:(StopRecord *)stop inDirection:(DirectionRecord *)direction {
    SQLiteDB *db = [SQLiteDB sharedDB];
    sqlite3_stmt *stmt = [db prepareStatementWithQuery:QUERY];
    sqlite3_bind_int(stmt, 1, direction.direction);
    sqlite3_bind_text(stmt, 2, [direction.routeId UTF8String], -1, SQLITE_STATIC);
    sqlite3_bind_text(stmt, 3, [stop.stopId UTF8String], -1, SQLITE_STATIC);
    sqlite3_bind_int(stmt, 4, direction.direction);
    sqlite3_bind_text(stmt, 5, [direction.routeId UTF8String], -1, SQLITE_STATIC);
    NSMutableArray *stops = [NSMutableArray array];
    [db performAndFinalizeStatement:stmt blockForEachRow:^(sqlite3_stmt *stmt) {
        StopRecord *stop = [[StopRecord alloc] initWithStatement:stmt];
        [stops addObject:stop];
    }];
    return [stops copy];
}

@end
