#import <Foundation/Foundation.h>
#import "Trip.h"

@interface TripsTableViewController : NSObject <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *trips;

@end
