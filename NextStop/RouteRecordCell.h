#import <UIKit/UIKit.h>

@class RouteRecord;

@interface RouteRecordCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *longNameLabel;
@property (strong, nonatomic) RouteRecord *routeRecord;
@property (weak, nonatomic) IBOutlet UILabel *shortNameLabel;

@end
