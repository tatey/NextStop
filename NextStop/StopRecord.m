#import <CoreLocation/CoreLocation.h>
#import "DirectionRecord.h"
#import "NameFormatter.h"
#import "StopRecord.h"

#define QUERY1 @"SELECT stops.* "                                                          \
                "FROM stops "                                                              \
                "INNER JOIN directions_stops ON directions_stops.stop_id = stops.stop_id " \
                "  AND directions_stops.direction = ? "                                    \
                "  AND directions_stops.route_id = ? "                                     \
                "ORDER BY directions_stops.stop_sequence ASC; "                            \

#define QUERY2 @"SELECT stops.* "                                                          \
                "FROM stops "                                                              \
                "INNER JOIN directions_stops ON directions_stops.stop_id = stops.stop_id " \
                "  AND directions_stops.direction = ? "                                    \
                "  AND directions_stops.route_id = ? "                                     \
                "WHERE stops.stop_name LIKE ? "                                            \
                "ORDER BY stops.stop_name ASC; "                                           \

#define QUERY3 @"SELECT stops.* "          \
                "FROM stops "              \
                "WHERE stops.stop_id = ? " \
                "LIMIT 1; "                \

@interface StopRecord () {
@private 
    CLLocationDegrees _latitude;
    CLLocationDegrees _longitude;
    __strong NSString *_name;
    __strong NSString *_stopId;
    __strong NSString *_subtitle;
    __strong NSString *_title;
}

@property (strong, nonatomic) NameFormatter *nameFormatter;

- (id)initWithStatement:(sqlite3_stmt *)stmt;

@end

@implementation StopRecord

+ (NSArray *)stopsBelongingToDirection:(DirectionRecord *)direction {
    SQLiteDB *db = [SQLiteDB sharedDB];
    sqlite3_stmt *stmt = [db prepareStatementWithQuery:QUERY1];
    sqlite3_bind_int(stmt, 1, direction.direction);
    sqlite3_bind_text(stmt, 2, [direction.routeId UTF8String], -1, SQLITE_STATIC);
    NSMutableArray *stops = [NSMutableArray array];
    [db performAndFinalizeStatement:stmt blockForEachRow:^(sqlite3_stmt *stmt) {
        StopRecord *stop = [[self alloc] initWithStatement:stmt];
        [stops addObject:stop];
    }];
    return [stops copy];
}

+ (NSArray *)stopsBelongingToDirection:(DirectionRecord *)direction likeName:(NSString *)name {
    SQLiteDB *db = [SQLiteDB sharedDB];
    sqlite3_stmt *stmt = [db prepareStatementWithQuery:QUERY2];
    sqlite3_bind_int(stmt, 1, direction.direction);
    sqlite3_bind_text(stmt, 2, [direction.routeId UTF8String], -1, SQLITE_STATIC);
    sqlite3_bind_text(stmt, 3, SQLiteDBWildcardUTF8String(name), -1, SQLITE_STATIC);
    NSMutableArray *stops = [NSMutableArray array];
    [db performAndFinalizeStatement:stmt blockForEachRow:^(sqlite3_stmt *stmt) {
        StopRecord *stop = [[self alloc] initWithStatement:stmt];
        [stops addObject:stop];
    }];
    return [stops copy];
}

+ (id)stopMatchingStopId:(NSString *)stopId {
    SQLiteDB *db = [SQLiteDB sharedDB];
    sqlite3_stmt *stmt = [db prepareStatementWithQuery:QUERY3];
    sqlite3_bind_text(stmt, 1, [stopId UTF8String], -1, SQLITE_STATIC);
    __block StopRecord *stop = nil;
    [db performAndFinalizeStatement:stmt blockForEachRow:^(sqlite3_stmt *stmt) {
        stop = [[self alloc] initWithStatement:stmt];
    }];
    return stop;
}

- (id)initWithStatement:(sqlite3_stmt *)stmt {
    self = [self init];
    if (self) {
        _latitude = sqlite3_column_double(stmt, 2);
        _longitude = sqlite3_column_double(stmt, 3);
        _name = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 1)] copy];
        _stopId = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 0)] copy];
    }
    return self;
}

- (NSString *)name {
    return _name;
}

- (NSString *)stopId {
    return _stopId;
}

- (NameFormatter *)nameFormatter {
    if (!_nameFormatter) {
        _nameFormatter = [[NameFormatter alloc] initWithName:self.name];
    }
    return _nameFormatter;
}

- (BOOL)isEqualToStop:(StopRecord *)stop {
    return [self.stopId isEqualToString:stop.stopId];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, latitude: %f, longitude: %f, name: %@, stopId: %@>", NSStringFromClass([self class]), self, _latitude, _longitude, _name, _stopId];
}

#pragma mark - MKAnnotation

- (NSString *)title {
    return self.nameFormatter.title;
}

- (NSString *)subtitle {
    return self.nameFormatter.subtitle;
}

- (CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake(_latitude, _longitude);
}

@end
