//
//  UABeaconManager.h
//  UABeacons
//
//  Created by David Crow on 10/3/13.
//  Copyright (c) 2013 David Crow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "UAPlistManager.h"

#define DEFINE_SHARED_INSTANCE_USING_BLOCK(block) \
static dispatch_once_t pred = 0; \
__strong static id _sharedObject = nil; \
dispatch_once(&pred, ^{ \
_sharedObject = block(); \
}); \
return _sharedObject; \

@interface UARegionManager : NSObject <CLLocationManagerDelegate>

@property (strong, nonatomic) NSArray *rangedBeacons;
//The current beacons that are monitored, apple already used "monitoredRegions" so they chose "rangedRegions"
@property (strong, nonatomic, readonly) NSSet *monitoredBeaconRegions;
@property (strong, nonatomic, readonly) NSDictionary *visitedBeaconRegions;
@property (strong, nonatomic) CLBeaconRegion *currentRegion;//this may be redundant with rangedBeacons



+ (id)shared;

@end
