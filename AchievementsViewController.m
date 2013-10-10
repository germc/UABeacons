//
//  AchievementsViewController.m
//  UABeacons
//
//  Created by David Crow on 10/4/13.
//  Copyright (c) 2013 David Crow. All rights reserved.
//

#import "AchievementsViewController.h"

@interface AchievementsViewController ()

@end

@implementation AchievementsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //register for ranging beacons notification
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(managerDidRangeBeacons)
         name:@"managerDidRangeBeacons"
         object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)managerDidRangeBeacons
{

}

-(void)achievementCheck
{
    NSArray *monitoredRegions = [NSArray arrayWithArray:[[[UARegionManager shared] monitoredBeaconRegions] allObjects]];
    NSArray *rangedRegions = [NSArray arrayWithArray:[[[UARegionManager shared] rangedRegions] allObjects]];
    
    for (CLBeaconRegion *monitoredBeaconRegion in monitoredRegions) {
       //if a monitored region identifier matches a current ranged region identifier
        for (CLBeaconRegion *rangedBeaconRegion in rangedRegions) {
            if ([[monitoredBeaconRegion identifier] isEqualToString:[rangedBeaconRegion identifier]] ) {
             
                //increment visit count in visitedRegionsDict 
                
            }
        }
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
