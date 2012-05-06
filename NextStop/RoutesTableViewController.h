#import <Foundation/Foundation.h>
#import "Route.h"

@interface RoutesTableViewController : NSObject <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *routes;

@end
