#import <CoreLocation/CoreLocation.h>
#import "DirectionRecord.h"
#import "StopRecord.h"
#import "SQLiteDB.h"

#define QUERY1 @"SELECT DISTINCT stops.* "                                \
               "FROM stops "                                              \
               "INNER JOIN stop_times ON stop_times.stop_id = stops.id "  \
               "INNER JOIN trips ON stop_times.trip_id = trips.id "       \
               "WHERE trips.id = ?; "                                     \

#define QUERY2 @"SELECT stops.* "      \
                "FROM stops "          \
                "WHERE stops.id = ?; " \

@interface StopRecord () {
@private 
    NSUInteger _primaryKey;
    CLLocationDegrees _latitude;
    CLLocationDegrees _longitude;
    __strong NSString *_name;
    __strong NSString *_stopId;
}

- (id)initWithStatement:(sqlite3_stmt *)stmt;

@end

@implementation StopRecord

+ (NSArray *)stopsBelongingToDirection:(DirectionRecord *)direction {
    SQLiteDB *db = [SQLiteDB sharedDB];
    sqlite3_stmt *stmt = [db prepareStatementWithQuery:QUERY1];
    sqlite3_bind_int(stmt, 1, direction.primaryKey);
    NSMutableArray *stops = [NSMutableArray array];
    [db performAndFinalizeStatement:stmt blockForEachRow:^(sqlite3_stmt *stmt) {
        StopRecord *stop = [[self alloc] initWithStatement:stmt];
        [stops addObject:stop];
    }];
    return [stops copy];
}

+ (id)stopMatchingPrimaryKey:(NSInteger)primaryKey {
    SQLiteDB *db = [SQLiteDB sharedDB];
    sqlite3_stmt *stmt = [db prepareStatementWithQuery:QUERY2];
    sqlite3_bind_int(stmt, 1, primaryKey);
    __block StopRecord *stop = nil;
    [db performAndFinalizeStatement:stmt blockForEachRow:^(sqlite3_stmt *stmt) {
        stop = [[self alloc] initWithStatement:stmt];
    }];
    return stop;
}

- (id)initWithStatement:(sqlite3_stmt *)stmt {
    self = [self init];
    if (self) {
        _primaryKey = sqlite3_column_int(stmt, 0);
        _latitude = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 3)] doubleValue];
        _longitude = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 4)] doubleValue];
        _name = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 2)] copy];
        _stopId = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 1)] copy];
    }
    return self;
}

- (NSString *)name {
    return _name;
}

- (NSUInteger)primaryKey {
    return _primaryKey;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, primaryKey: %d, latitude: %f, longitude: %f, name: %@, stopId: %@>", NSStringFromClass([self class]), self, self.primaryKey, _latitude, _longitude, self.name, self.stopId];
}

- (BOOL)isEqualToStop:(StopRecord *)stop {
    return self.primaryKey == stop.primaryKey;
}

#pragma mark - MKAnnotation

- (NSString *)title {
    return self.stopId;
}

- (NSString *)subtitle {
    return self.name;
}

- (CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake(_latitude, _longitude);
}

@end
