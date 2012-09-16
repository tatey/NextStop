#import "NSObject+KVOSEL.h"
#import "RouteCell.h"
#import "RouteManagedObject.h"
#import "RouteRecord.h"

static NSString *const kRouteManagedObjectIsMonitorProximityToTarget = @"routeManagedObject.isMonitoringProximityToTarget";
static NSString *const kRouteManagedObjectRouteLongNameKeyPath = @"routeManagedObject.route.longName";
static NSString *const kRouteManagedObjectRouteShortNameKeyPath = @"routeManagedObject.route.shortName";
static NSString *const kRouteManagedObjectUpdatedAtKeyPath = @"routeManagedObject.updatedAt";

@implementation RouteCell

@synthesize longNameLabel = _longNameLabel;
@synthesize monitoredImageView = _monitoredImageView;
@synthesize routeManagedObject = _routeManagedObject;
@synthesize shortNameLabel = _shortNameLabel;
@synthesize updatedAtLabel = _updatedAtLabel;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addObserver:self forKeyPath:kRouteManagedObjectIsMonitorProximityToTarget options:0 context:@selector(routeManagedObjectIsMonitorProximityToTargetDidChange)];
        [self addObserver:self forKeyPath:kRouteManagedObjectRouteLongNameKeyPath options:0 context:@selector(routeManagedObjectLongNameDidChange)];
        [self addObserver:self forKeyPath:kRouteManagedObjectRouteShortNameKeyPath options:0 context:@selector(routeManagedObjectShortNameDidChange)];
        [self addObserver:self forKeyPath:kRouteManagedObjectUpdatedAtKeyPath options:0 context:@selector(routeManagedObjectUpdatedAtDidChange)];
    }
    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:kRouteManagedObjectIsMonitorProximityToTarget];
    [self removeObserver:self forKeyPath:kRouteManagedObjectRouteLongNameKeyPath];
    [self removeObserver:self forKeyPath:kRouteManagedObjectRouteShortNameKeyPath];
}

#pragma mark - Notifications

- (void)routeManagedObjectIsMonitorProximityToTargetDidChange {
    UIImage *image = nil;
    if ([self.routeManagedObject.isMonitoringProximityToTarget boolValue]) {
        image = [UIImage imageNamed:@"BusGreen.png"];
    } else {
        image = [UIImage imageNamed:@"BusGray.png"];
    }
    self.monitoredImageView.image = image;
}

- (void)routeManagedObjectLongNameDidChange {
    self.longNameLabel.text = self.routeManagedObject.route.longName;
}

- (void)routeManagedObjectShortNameDidChange {
    self.shortNameLabel.text = self.routeManagedObject.route.shortName;
}

- (void)routeManagedObjectUpdatedAtDidChange {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    self.updatedAtLabel.text = [dateFormatter stringFromDate:self.routeManagedObject.updatedAt];
}

@end
