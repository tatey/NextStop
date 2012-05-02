#import <Foundation/Foundation.h>
#import "Route.h"

@interface RoutesTableViewController : NSObject <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (assign, nonatomic) RouteDirection direction;
@property (strong, nonatomic) NSArray *routes;

- (id)initWithDirection:(RouteDirection)direction;

@end
