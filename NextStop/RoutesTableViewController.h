#import <Foundation/Foundation.h>

@interface RoutesTableViewController : NSObject <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *routes;

@end
