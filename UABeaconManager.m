//
//  UABeaconManager.m
//  UABeacons
//
//  Created by David Crow on 10/3/13.
//  Copyright (c) 2013 David Crow. All rights reserved.
//

#import "UABeaconManager.h"


@interface UABeaconManager ()

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation UABeaconManager {
    
    NSMutableDictionary *_beacons;
    CLLocationManager *_locationManager;
    NSMutableArray *_rangedRegions;
    NSMutableArray *tagArray;
    CGFloat bleatTime;
    
    int goatX;
    int goatY;

}

+ (UABeaconManager *)shared
{
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    });
}

-(UABeaconManager *)init{
    self = [super init];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    for (CLBeaconRegion *beaconRegion in [UAPlistManager sharedDefaults].beaconRegions)
    {
        [self.locationManager startRangingBeaconsInRegion:beaconRegion];
    }
    
    return self;
}

-(void)dealloc{
    //when manager is deallocated, stop ranging (might be unecessary cleanup)
    for (CLBeaconRegion *beaconRegion in [UAPlistManager sharedDefaults].beaconRegions)
    {
        [self.locationManager stopRangingBeaconsInRegion:beaconRegion];
    }
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    // CoreLocation will call this delegate method at 1 Hz with updated range information.
    // Beacons will be categorized and displayed by proximity.
    
    self.rangedBeacons = beacons;
    self.currentRegion = region;
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"managerDidRangeBeacons"
     object:self];

}

@end
