#import <Foundation/Foundation.h>
#import "Trip.h"

@interface RoutesTableViewController : NSObject <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *trips;

@end
