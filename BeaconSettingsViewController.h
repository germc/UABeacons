//
//  BeaconSettingsViewController.h
//  UABeacons
//
//  Created by David Crow on 11/3/13.
//  Copyright (c) 2013 David Crow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface BeaconSettingsViewController : UITableViewController

@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) CLBeacon *beacon;
@property (strong, nonatomic) IBOutlet UILabel *monitorLabel;
@property (strong, nonatomic) IBOutlet UISwitch *monitorSwitch;
@property (strong, nonatomic) IBOutlet UILabel *noteEntryLabel;
@property (strong, nonatomic) IBOutlet UISwitch *noteEntrySwitch;
@property (strong, nonatomic) IBOutlet UILabel *noteExitLabel;
@property (strong, nonatomic) IBOutlet UISwitch *noteExitSwitch;
@property (strong, nonatomic) IBOutlet UILabel *noteEntryOnDisplayLabel;
@property (strong, nonatomic) IBOutlet UISwitch *noteEntryOnDisplaySwitch;

@end
