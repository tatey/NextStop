#import "JSONSerializer.h"

@implementation JSONSerializer

- (id)init {
    self = [super init];
    if (self) {
        self.graph = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)setObject:(id)object forKey:(NSString *)key {
    [self.graph setObject:object forKey:key];
}

- (NSData *)data {
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self.graph options:0 error:&error];
    if (!data) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    return data;
}

- (NSString *)string {
    return [[NSString alloc] initWithData:[self data] encoding:NSUTF8StringEncoding];
}

@end
