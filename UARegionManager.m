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
    
    NSMutableDictionary *vistedRegions;
    
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
    
    //this should be initialized from persistent storage at some point
    vistedRegions = [[NSMutableDictionary alloc] init];
    
    for (CLBeaconRegion *beaconRegion in [UAPlistManager shared].beaconRegions)
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
    for (CLBeaconRegion *beaconRegion in [UAPlistManager shared].beaconRegions)
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

    [self updateVistedMetricsForRangedBeacons:beacons];

}

-(void)updateVistedMetricsForRangedBeacons:(NSArray *)rangedBeacons
{
    //this is required to have the most up to date list for getting identifiers for uuids
    [[UAPlistManager shared] loadReadableBeaconRegions];
    
    for (CLBeacon *beacon in rangedBeacons)
    {
        //If the current beacon UUID is missing form the visited regions, make it a dictionary add it to the visited regions
        
        int value;
        NSString *title = [[UAPlistManager shared] identifierForUUID:[beacon proximityUUID]];
        //initial values
        NSNumber *visits = [NSNumber numberWithInt:0];
        NSNumber *totalVisitTime = [NSNumber numberWithInt:0];
        //each key is appended with title ex. title_visits
        NSString *visitsKey = [NSString stringWithFormat:@"%@_visits",title];
        NSString *totalVisitTimeKey = [NSString stringWithFormat:@"%@_totalVisitTime",title];
        
        if ([self.visitedBeaconRegions valueForKey:visitsKey]) {
            value = [visits intValue];
            visits = [NSNumber numberWithInt:value + 1];
            [self.visitedBeaconRegions setValue:visits forKey:visitsKey];
        }
        else{
            //new beacon region (no such visit key exists)
            [self.visitedBeaconRegions setValue:visits forKey:visitsKey];
        }
        
        if ([self.visitedBeaconRegions valueForKey:totalVisitTimeKey]) {
            value = [totalVisitTimeKey intValue];
            totalVisitTime = [NSNumber numberWithInt:value + 1];
            [self.visitedBeaconRegions setValue:totalVisitTime forKey:totalVisitTimeKey];
        }
        else{
            //new beacon region (no such visit key exists)
            [self.visitedBeaconRegions setValue:totalVisitTime forKey:totalVisitTimeKey];
        }

    }
}



@end
