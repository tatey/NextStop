#import <UIKit/UIKit.h>

@class RouteManager;

@interface RouteCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *longNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *monitoredImageView;
@property (strong, nonatomic) RouteManager *routeManager;
@property (weak, nonatomic) IBOutlet UILabel *shortNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *updatedAtLabel;

@end
