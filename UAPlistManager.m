#import "UAPlistManager.h"
#import <CoreLocation/Corelocation.h>

@implementation UAPlistManager {
    NSFileManager* manager;
}

- (id)init
{
    self = [super init];
    if(self)
    {
        // uuidgen should be used to generate UUIDs.
       
        _beaconRegions = [self buildBeaconsDataFromPlist];
        _regions = [self buildRegionsDataFromPlist];
        self.visitedBeaconRegions = [self buildVisitedRegionsDataFromPlist];
        
        
        //Initialize plist filed - TODO add file mngr checking
        
        manager = [NSFileManager defaultManager];
        
        NSString* plistRegionsPath = [[NSBundle mainBundle] pathForResource:@"Regions" ofType:@"plist"];
        _plistRegionContentsArray = [NSArray arrayWithContentsOfFile:plistRegionsPath];
        
        NSString* plistBeaconRegionsPath = [[NSBundle mainBundle] pathForResource:@"BeaconRegions" ofType:@"plist"];
        self.plistBeaconContentsArray = [[NSArray alloc] initWithContentsOfFile:plistBeaconRegionsPath];
        
//        NSString* plistVisitedPath = [[NSBundle mainBundle] pathForResource:@"VisitedBeaconRegions" ofType:@"plist"];
//        _plistVisitedContentsArray = [NSArray arrayWithContentsOfFile:plistVisitedPath];
        
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

-(void)saveVisitedBeaconRegionsToPlist:(NSString *) filePath{

//    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
//    NSData *dataRepresentingSavedArray = [currentDefaults objectForKey:@"savedArray"];
//    if (dataRepresentingSavedArray != nil)
//    {
//        NSArray *oldSavedArray = [NSKeyedUnarchiver unarchiveObjectWithData:dataRepresentingSavedArray];
//        if (oldSavedArray != nil)
//            objectArray = [[NSMutableArray alloc] initWithArray:oldSavedArray];
//        else
//            objectArray = [[NSMutableArray alloc] init];
//    }
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

    NSMutableArray *visitedRegions = [NSMutableArray array];
    for(NSDictionary *beaconDict in self.plistBeaconContentsArray)
    {
        NSDictionary *visited= [self mapDictionaryToVisited:beaconDict];
        
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
