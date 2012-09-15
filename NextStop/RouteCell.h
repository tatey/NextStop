#import <UIKit/UIKit.h>

@class RouteManagedObject;

@interface RouteCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *longNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *monitoredImageView;
@property (strong, nonatomic) RouteManagedObject *routeManagedObject;
@property (weak, nonatomic) IBOutlet UILabel *shortNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *updatedAtLabel;

@end
