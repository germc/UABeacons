#import "UAPlistManager.h"
#import <CoreLocation/Corelocation.h>

@implementation UAPlistManager {

}

- (id)init
{
    self = [super init];
    if(self)
    {
        // uuidgen should be used to generate UUIDs.
       
        _beaconRegions = [self buildBeaconsDataFromPlist];
        _regions = [self buildRegionsDataFromPlist];
        _visitedBeaconRegions = [self buildVisitedRegionsDataFromPlist];
        
//        _supportedProximityUUIDs = @[[[NSUUID alloc] initWithUUIDString:@"5AFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFD"],
//                                     [[NSUUID alloc] initWithUUIDString:@"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"],
//                                      [[NSUUID alloc] initWithUUIDString:@"5A4BCFCE-174E-4BAC-A814-092E77F6B7E5"],
//                                      [[NSUUID alloc] initWithUUIDString:@"74278BDA-B644-4520-8F0C-720EAF059935"],
//                                     [[NSUUID alloc] initWithUUIDString:@"9DEAD044-DD92-E366-7E2D-C53AC3381B27"]];
        _defaultPower = @-59;
    }
    
    return self;
}

+ (UAPlistManager *)sharedDefaults
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

-(void)loadReadableBeaconRegions{
    
    NSMutableArray *readableBeaconArray = [[NSMutableArray alloc] initWithCapacity:[self.beaconRegions count]];
    NSString *currentReadableBeacon = [[NSString alloc] init];
    
    for (CLBeaconRegion *beaconRegion in self.beaconRegions) {
        currentReadableBeacon = [NSString stringWithFormat:@"%@ - %@", [beaconRegion identifier], [[beaconRegion proximityUUID] UUIDString]];
        [readableBeaconArray addObject:currentReadableBeacon];
    }
    
    _readableBeaconRegions = [NSArray arrayWithArray:readableBeaconArray];
}

- (NSArray*) buildBeaconsDataFromPlist
{
    
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"BeaconRegions" ofType:@"plist"];
    self.plistBeaconContentsArray = [[NSArray alloc] initWithContentsOfFile:plistPath];
    
    NSMutableArray *beacons = [NSMutableArray array];
    for(NSDictionary *beaconDict in self.plistBeaconContentsArray)
    {
        CLBeaconRegion *beaconRegion = [self mapDictionaryToBeacon:beaconDict];
        if (beaconRegion != nil) {
              [beacons addObject:beaconRegion];
        } else {
            NSLog(@"beaconRegion is nil");
        }
     
    }
    return [NSArray arrayWithArray:beacons];
}

-(NSArray*)buildVisitedRegionsDataFromPlist
{
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"VisitedBeaconRegions" ofType:@"plist"];
    _plistVisitedContentsArray = [NSArray arrayWithContentsOfFile:plistPath];
    
    NSMutableArray *visitedRegions = [NSMutableArray array];
    for(NSDictionary *vistedDict in _plistVisitedContentsArray)
    {
        NSDictionary *visited= [self mapDictionaryToVisited:vistedDict];
        
        if (visited != nil) {
            [visitedRegions addObject:visited];
        } else {
            NSLog(@"region is nil");
        }
        
    }
    return [NSArray arrayWithArray:visitedRegions];
    
}

- (NSArray*) buildRegionsDataFromPlist
{
    
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"Regions" ofType:@"plist"];
    _plistRegionContentsArray = [NSArray arrayWithContentsOfFile:plistPath];
    
    NSMutableArray *regions = [NSMutableArray array];
    for(NSDictionary *regionDict in _plistRegionContentsArray)
    {
        CLRegion *region = [self mapDictionaryToRegion:regionDict];
        
        if (region != nil) {
            [regions addObject:region];
        } else {
            NSLog(@"region is nil");
        }
        
    }
    return [NSArray arrayWithArray:regions];
}


- (CLBeaconRegion*)mapDictionaryToBeacon:(NSDictionary*)dictionary {
    NSString *title = [dictionary valueForKey:@"title"];
    NSUUID *proximityUUID = [[NSUUID alloc] initWithUUIDString:[dictionary valueForKey:@"proximityUUID"]] ;
    //CLBeaconMajorValue major = [[dictionary valueForKey:@"Major"] unsignedShortValue];
    //CLBeaconMinorValue minor = [[dictionary valueForKey:@"Minor"] unsignedShortValue];
    
    return [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID identifier:title];
}

- (NSDictionary*)mapDictionaryToVisited:(NSDictionary*)dictionary {
    NSString *title = [dictionary valueForKey:@"title"];
    NSNumber *visits = [dictionary valueForKey:@"visits"];
    NSNumber *totalVisitTime = [dictionary valueForKey:@"totalVisitTime"];

    //CLBeaconMajorValue major = [[dictionary valueForKey:@"Major"] unsignedShortValue];
    //CLBeaconMinorValue minor = [[dictionary valueForKey:@"Minor"] unsignedShortValue];
    
    return [[NSDictionary alloc] initWithObjectsAndKeys:title,@"title",visits,@"visits",totalVisitTime,@"totalVisitTime",nil];
}

- (CLRegion*)mapDictionaryToRegion:(NSDictionary*)dictionary {
    NSString *title = [dictionary valueForKey:@"title"];
    
    CLLocationDegrees latitude = [[dictionary valueForKey:@"latitude"] doubleValue];
    CLLocationDegrees longitude =[[dictionary valueForKey:@"longitude"] doubleValue];
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
    
    CLLocationDistance regionRadius = [[dictionary valueForKey:@"radius"] doubleValue];
    return [[CLRegion alloc] initCircularRegionWithCenter:centerCoordinate radius:regionRadius identifier:title];
    
}

@end
