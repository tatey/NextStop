#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>
#import "RouteRecord.h"

@protocol RoutesTableViewDelegate;

@interface RoutesTableViewController : NSObject <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) id <RoutesTableViewDelegate> delegate;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSArray *routes;

- (id)initWithDelegate:(id <RoutesTableViewDelegate>)delegate managedObjectContext:(NSManagedObjectContext *)context;

@end
