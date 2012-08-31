#import "NSObject+KVOSEL.h"
#import "RouteCell.h"
#import "RouteManager.h"
#import "RouteRecord.h"

static NSString *const kRouteManagerIsMonitorProximityToTarget = @"routeManager.isMonitoringProximityToTarget";
static NSString *const kRouteManagerRouteLongNameKeyPath = @"routeManager.route.longName";
static NSString *const kRouteManagerRouteShortNameKeyPath = @"routeManager.route.shortName";
static NSString *const kRouteManagerUpdatedAtKeyPath = @"routeManager.updatedAt";

@implementation RouteCell

@synthesize longNameLabel = _longNameLabel;
@synthesize monitoredImageView = _monitoredImageView;
@synthesize routeManager = _routeManager;
@synthesize shortNameLabel = _shortNameLabel;
@synthesize updatedAtLabel = _updatedAtLabel;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addObserver:self forKeyPath:kRouteManagerIsMonitorProximityToTarget options:0 context:@selector(routeManagerIsMonitorProximityToTargetDidChange)];
        [self addObserver:self forKeyPath:kRouteManagerRouteLongNameKeyPath options:0 context:@selector(routeManagerLongNameDidChange)];
        [self addObserver:self forKeyPath:kRouteManagerRouteShortNameKeyPath options:0 context:@selector(routeManagerShortNameDidChange)];
        [self addObserver:self forKeyPath:kRouteManagerUpdatedAtKeyPath options:0 context:@selector(routeManagerUpdatedAtDidChange)];
    }
    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:kRouteManagerIsMonitorProximityToTarget];
    [self removeObserver:self forKeyPath:kRouteManagerRouteLongNameKeyPath];
    [self removeObserver:self forKeyPath:kRouteManagerRouteShortNameKeyPath];
}

#pragma mark - Notifications

- (void)routeManagerIsMonitorProximityToTargetDidChange {
    UIImage *image = nil;
    if ([self.routeManager.isMonitoringProximityToTarget boolValue]) {
        image = [UIImage imageNamed:@"Green.png"];
    } else {
        image = [UIImage imageNamed:@"Gray.png"];
    }
    self.monitoredImageView.image = image;
}

- (void)routeManagerLongNameDidChange {
    self.longNameLabel.text = self.routeManager.route.longName;
}

- (void)routeManagerShortNameDidChange {
    self.shortNameLabel.text = self.routeManager.route.shortName;
}

- (void)routeManagerUpdatedAtDidChange {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    self.updatedAtLabel.text = [dateFormatter stringFromDate:self.routeManager.updatedAt];
}

@end
