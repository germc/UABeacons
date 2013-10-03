//
//  ViewController.h
//  UABeacons
//
//  Created by David Crow on 9/26/13.
//  Copyright (c) 2013 David Crow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate>

-(NSMutableArray *)getBeaconUUIDStrings:(NSArray *)beacons;

@property (strong, nonatomic) IBOutlet UIImageView *goat3;
@property (strong, nonatomic) IBOutlet UIImageView *goat2;
@property (strong, nonatomic) IBOutlet UIImageView *goat1;
@property (strong, nonatomic) IBOutlet UIImageView *disconnected;
@property (strong, nonatomic) IBOutlet UIImageView *connected;
@property (strong, nonatomic) IBOutlet UISwitch *goatDarSwitch;
@property (strong, nonatomic) IBOutlet UILabel *xyLabel;


@property CGFloat iPodProx;
@property CGFloat iPadProx;


@property (strong, nonatomic) IBOutlet UILabel *iPodProxLabel;
@property (strong, nonatomic) IBOutlet UILabel *iPadProxLabel;

@end
