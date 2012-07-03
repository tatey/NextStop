#import <CoreLocation/CoreLocation.h>
#import "Stop.h"
#import "SQLiteDB.h"
#import "Trip.h"

#define QUERY @"SELECT DISTINCT stops.* "                                \
               "FROM stops "                                             \
               "INNER JOIN stop_times ON stop_times.stop_id = stops.id " \
               "INNER JOIN trips ON stop_times.trip_id = trips.id "      \
               "WHERE trips.id = ?; "                                    \

static NSString *const kPrimaryKeyArchiveKey = @"me.nextstop.archive.stop.primary_key";
static NSString *const kLatitudeArchiveKey = @"me.nextstop.archive.stop.latitude";
static NSString *const kLongitudeArchiveKey = @"me.nextstop.archive.stop.longitude";
static NSString *const kNameArchiveKey = @"me.nextstop.archive.stop.name";

@interface Stop () {
@private 
    NSUInteger _primaryKey;
    CLLocationDegrees _latitude;
    CLLocationDegrees _longitude;
    __strong NSString *_name;
}

- (id)initWithStatement:(sqlite3_stmt *)stmt;

@end

@implementation Stop

+ (NSArray *)stopsBelongingToTrip:(Trip *)trip {
    SQLiteDB *db = [SQLiteDB sharedDB];
    sqlite3_stmt *stmt = [db prepareStatementWithQuery:QUERY];    
    sqlite3_bind_int(stmt, 1, trip.primaryKey);
    NSMutableArray *stops = [NSMutableArray array];
    [db performAndFinalizeStatement:stmt blockForEachRow:^(sqlite3_stmt *stmt) {
        Stop *stop = [[self alloc] initWithStatement:stmt];
        [stops addObject:stop];
    }];
    return [stops copy];
}

- (id)initWithStatement:(sqlite3_stmt *)stmt {
    self = [self init];
    if (self) {
        _primaryKey = sqlite3_column_int(stmt, 0);
        _latitude = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 3)] doubleValue];
        _longitude = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 4)] doubleValue];
        _name = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 2)] copy];
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
    return [NSString stringWithFormat:@"<%@: %p, primaryKey: %d, latitude: %f, longitude: %f, name: %@>", NSStringFromClass([self class]), self, self.primaryKey, _latitude, _longitude, self.name];
}

#pragma mark - MKAnnotation

- (NSString *)title {
    return self.name;
}

- (CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake(_latitude, _longitude);
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)coder {
    self = [self init];
    if (self) {
        _primaryKey = [coder decodeIntegerForKey:kPrimaryKeyArchiveKey];
        _latitude = [coder decodeDoubleForKey:kLatitudeArchiveKey];
        _longitude = [coder decodeDoubleForKey:kLongitudeArchiveKey];
        _name = [[coder decodeObjectForKey:kNameArchiveKey] copy];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeInteger:_primaryKey forKey:kPrimaryKeyArchiveKey];
    [coder encodeDouble:_latitude forKey:kLatitudeArchiveKey];
    [coder encodeDouble:_longitude forKey:kLongitudeArchiveKey];
    [coder encodeObject:_name forKey:kNameArchiveKey];
}

@end
