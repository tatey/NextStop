#import <Foundation/Foundation.h>
#import <sqlite3.h>

typedef enum {
    RouteInboundDirection,
    RouteOutboundDirection,
} RouteDirection;

static inline NSString * RouteDirectionToString(RouteDirection direction) {
    switch (direction) {
        case RouteInboundDirection:
            return @"route.directions.inbound";
        case RouteOutboundDirection:
            return @"route.directions.outbound";
    }
}

@interface Route : NSObject {
@private
    NSString *_code;
    NSString *_name;
    NSUInteger _primaryKey;
}

@property (readonly) NSString *code;
@property (readonly) NSString *name;
@property (readonly) NSUInteger primaryKey;

+ (NSArray *)routesMatchingCodeOrName:(NSString *)codeOrName direction:(RouteDirection)direction;

- (id)initWithStatement:(sqlite3_stmt *)stmt;

@end
