#import "StopAnnotationView.h"

@interface StopAnnotationView ()

@property (strong, nonatomic) UISwitch *monitorSwitch;

@end

@implementation StopAnnotationView

// Public
@synthesize delegate = _delegate;
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
        self.monitorSwitch.onTintColor = [UIColor colorWithRed:0.0588 green:0.4667 blue:0.0588 alpha:1.0000];
        [self.monitorSwitch addTarget:self action:@selector(monitorSwitchDidChangeValue:) forControlEvents:UIControlEventValueChanged];
        self.leftCalloutAccessoryView = self.monitorSwitch;
        self.centerOffset = CGPointMake(8, -15);
        self.calloutOffset = CGPointMake(-8, 0);
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
    UIImage *image = nil;
    if (self.monitored && self.targeted) {
        image = [UIImage imageNamed:@"PinGreen.png"];
    } else if (self.targeted) {
        image = [UIImage imageNamed:@"PinGray.png"];
    } else {
        image = [UIImage imageNamed:@"PinPurple.png"];
    }
    self.image = image;
}

#pragma mark - Actions

- (void)monitorSwitchDidChangeValue:(UISwitch *)monitorSwitch {
    self.monitored = monitorSwitch.on;
    [self.delegate stopAnnotationView:self monitoredDidChangeValue:monitorSwitch.on];
}

@end
