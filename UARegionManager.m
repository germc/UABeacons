//
//  UABeaconManager.m
//  UABeacons
//
//  Created by David Crow on 10/3/13.
//  Copyright (c) 2013 David Crow. All rights reserved.
//

#import "UARegionManager.h"


@interface UARegionManager ()

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation UARegionManager {
    
    NSMutableDictionary *_beacons;
    CLLocationManager *_locationManager;
    //NSMutableArray *_rangedRegions;
    NSMutableArray *tagArray;
    CGFloat bleatTime;
    
    int goatX;
    int goatY;

}

+ (UARegionManager *)shared
{
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    });
}

-(UARegionManager *)init{
    self = [super init];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    for (CLBeaconRegion *beaconRegion in [UAPlistManager sharedDefaults].beaconRegions)
    {
        [self.locationManager startRangingBeaconsInRegion:beaconRegion];
        [self.locationManager startMonitoringForRegion:beaconRegion];
        beaconRegion.notifyOnEntry = YES;
        beaconRegion.notifyOnExit = YES;
        beaconRegion.notifyEntryStateOnDisplay = YES;

        
    }
    
    return self;
}

-(void)dealloc{
    //when manager is deallocated, stop ranging (might be unecessary cleanup)
    for (CLBeaconRegion *beaconRegion in [UAPlistManager sharedDefaults].beaconRegions)
    {
        [self.locationManager stopRangingBeaconsInRegion:beaconRegion];
        [self.locationManager stopMonitoringForRegion:beaconRegion];

    }
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    // CoreLocation will call this delegate method at 1 Hz with updated range information.
    // Beacons will be categorized and displayed by proximity.
    
    self.rangedBeacons = beacons;
    self.currentRegion = region;
    //set ivar to init read-only property
    _monitoredBeaconRegions = [manager rangedRegions];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"managerDidRangeBeacons"
     object:self];
    

}

-(void)updateVistedMetricsForRangedBeacons:(NSArray *)rangedBeacons
{
    for (CLBeacon *beacon in rangedBeacons)
    {
        //If the current beacon UUID is missing form the visited regions, add it to the visited regions
        if ([self.visitedBeaconRegions valueForKey:[[beacon proximityUUID] UUIDString]]==nil)
        {
            NSLog(@"New beacon region visited!");
                NSString *title = [[beacon proximityUUID] UUIDString];
                //initial values
                NSNumber *visits = [NSNumber numberWithInt:0];
                NSNumber *totalVisitTime = [NSNumber numberWithInt:0];
            
            
            [[NSDictionary alloc] initWithObjectsAndKeys:title,@"title", visits,@"visits",totalVisitTime,@"totalVisitTime",nil];
            
        }
    }



}



@end
