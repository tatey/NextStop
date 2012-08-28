#import "StopAnnotationView.h"

@interface StopAnnotationView ()

@property (strong, nonatomic) UISwitch *monitorSwitch;

@end

@implementation StopAnnotationView

// Public
@synthesize monitored = _monitored;
@synthesize targeted = _targeted;

// Private
@synthesize monitorSwitch = _monitorSwitch;

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.canShowCallout = YES;
        self.monitored = NO;
        self.targeted = NO;
        self.monitorSwitch = [[UISwitch alloc] init];
        [self.monitorSwitch addTarget:self action:@selector(monitorSwitchDidChangeValue:) forControlEvents:UIControlEventValueChanged];
        self.leftCalloutAccessoryView = self.monitorSwitch;
    }
    return self;
}

- (void)setMonitored:(BOOL)monitored {
    [self setMonitored:monitored animated:NO];
}

- (void)setMonitored:(BOOL)monitored animated:(BOOL)animated {
    _monitored = monitored;
    [self.monitorSwitch setOn:monitored animated:animated];
    [self changePinColor];
}

- (void)setTargeted:(BOOL)targeted {
    _targeted = targeted;
    [self changePinColor];
}

- (void)changePinColor {
    if (self.monitored && self.targeted) {
        self.pinColor = MKPinAnnotationColorGreen;
    } else if (self.targeted) {
        self.pinColor = MKPinAnnotationColorRed;
    } else {
        self.pinColor = MKPinAnnotationColorPurple;
    }
}

#pragma mark - Actions

- (void)monitorSwitchDidChangeValue:(UISwitch *)monitorSwitch {
    self.monitored = monitorSwitch.on;
}

@end
