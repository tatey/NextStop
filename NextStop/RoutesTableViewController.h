#import <Foundation/Foundation.h>
#import "RouteRecord.h"

@protocol RoutesTableViewDelegate;

@interface RoutesTableViewController : NSObject <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) id <RoutesTableViewDelegate> delegate;
@property (strong, nonatomic) NSArray *routes;

- (id)initWithDelegate:(id <RoutesTableViewDelegate>)delegate;

@end
