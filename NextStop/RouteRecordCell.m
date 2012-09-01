#import "RouteRecord.h"
#import "RouteRecordCell.h"

@implementation RouteRecordCell

@synthesize longNameLabel = _longNameLabel;
@synthesize routeRecord = _routeRecord;
@synthesize shortNameLabel = _shortNameLabel;

- (void)setRouteRecord:(RouteRecord *)routeRecord {
    _routeRecord = routeRecord;
    self.shortNameLabel.text = routeRecord.shortName;
    self.longNameLabel.text = routeRecord.longName;
}

@end
