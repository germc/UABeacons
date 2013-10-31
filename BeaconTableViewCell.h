//
//  RegionTableViewCell.h
//  UABeacons
//
//  Created by David Crow on 10/31/13.
//  Copyright (c) 2013 David Crow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BeaconTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *beaconIdLabel;
@property (strong, nonatomic) IBOutlet UILabel *beaconUUIDLabel;
@property (strong, nonatomic) IBOutlet UILabel *beaconMajorLabel;
@property (strong, nonatomic) IBOutlet UILabel *beaconMinorLabel;

@property (strong, nonatomic) IBOutlet UIImageView *beaconMonitoredImage;

@property (strong, nonatomic) IBOutlet UIButton *notifyOnEntryButton;
@property (strong, nonatomic) IBOutlet UIButton *notifyOnExitButton;
@property (strong, nonatomic) IBOutlet UILabel *entryStateOnDisplayLabel;

@end
