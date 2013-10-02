
#import "ALDefaults.h"

@implementation ALDefaults

- (id)init
{
    self = [super init];
    if(self)
    {
        // uuidgen should be used to generate UUIDs.
        _supportedProximityUUIDs = @[[[NSUUID alloc] initWithUUIDString:@"5AFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFD"],
                                     [[NSUUID alloc] initWithUUIDString:@"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"],
                                      [[NSUUID alloc] initWithUUIDString:@"5A4BCFCE-174E-4BAC-A814-092E77F6B7E5"],
                                      [[NSUUID alloc] initWithUUIDString:@"74278BDA-B644-4520-8F0C-720EAF059935"],
                                     [[NSUUID alloc] initWithUUIDString:@"9DEAD044-DD92-E366-7E2D-C53AC3381B27"]];
        _defaultPower = @-59;
    }
    
    return self;
}

+ (ALDefaults *)sharedDefaults
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (NSUUID *)defaultProximityUUID
{
    return [_supportedProximityUUIDs objectAtIndex:0];
}

@end
