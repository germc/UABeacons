
//  ViewController.m
//  UABeacons
//
//  Created by David Crow on 9/26/13.
//  Copyright (c) 2013 David Crow. All rights reserved.
//

#import "GoatDarViewController.h"
#import "UAPlistManager.h"
#import "UAPush.h"
#import "UALocationService.h"
#import "UAirship.h"
#include <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVAudioPlayer.h>
#import "RadarView.h"
#import "Math.h"
#import "UARegionManager.h"

/*UA presentation room can be divided into 660 floor squares - each 19.5 inches across
 * to fit in a reasonable coordinate system on screen, this is at half scale, so each square is roughly
 * 9.75 pixels across
 * 0,0 starts at top left of room
 */

//everything in meters until display time!!!
#define kiPadX 0
#define kiPadY 0
#define kiPodX 9.906
#define kiPodY 0
#define kPadToPodProx 9.096

#define inchesToPixels(a)    (a / 2)
#define metersToPixels(a)    ((a * 39.3701) / 2)
#define inchesToMeters(a)    (a * 0.0254)
#define metersToSquares(a)    ((a * 39.3701)/9.75)

@interface GoatDarViewController ()

@end

@implementation GoatDarViewController
{
    NSMutableDictionary *_beacons;
    CLLocationManager *_locationManager;
    NSMutableArray *_rangedRegions;
    NSMutableArray *tagArray;
    NSMutableArray* UUIDStrings;
    SystemSoundID bleat;
    SystemSoundID adam;
    SystemSoundID cat;
    NSURL *bleatUrl;
    NSURL *adamUrl;
    NSURL *catUrl;
    int loopCheck;
    int adamCheck;
    RadarView *view;
    
    CGFloat bleatTime;
    
    int goatX;
    int goatY;
    
    // AVAudioPlayer *audioPlayer;
}

//Adds each UUID from each beacon as a string to the return array
-(NSMutableArray *)getBeaconUUIDStrings:(NSArray *)beacons{
    
    for (CLBeacon *beacon in beacons) {
        //Add the UUID string for each beacon
        [UUIDStrings addObject:[beacon.proximityUUID UUIDString]];
    }
    return UUIDStrings;
}

-(void)getBeaconProximities:(NSArray *)beacons inRegion:(CLBeaconRegion *)region{
    
    for (CLBeacon *beacon in beacons) {
        //Add the UUID string for each beacon
        if ([[beacon.proximityUUID UUIDString]  isEqual: @"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"]) {
            self.iPodProx = [beacon accuracy];
            [self.iPodProxLabel setText:[NSString stringWithFormat:@"%.2fm from region %@", beacon.accuracy, region.identifier]];
           
        }
        if ([[beacon.proximityUUID UUIDString]  isEqual: @"5A4BCFCE-174E-4BAC-A814-092E77F6B7E5"]) {
            self.iPadProx = [beacon accuracy];
            [self.iPadProxLabel setText:[NSString stringWithFormat:@"%.2fm from region %@", beacon.accuracy, region.identifier]];
            
        }
    }
    

}

-(void)getXY{
    kiPadX; //dx
    kiPadY; //dy initialise coordinates somehow
    kiPodX; //ex
    kiPodY; //ey
    self.iPadProx; //A
    kPadToPodProx; //B 9.906m
    self.iPodProx; //C
    
    //all in meters
    CGFloat cosd = kiPodX / kPadToPodProx;
    CGFloat cosfi = (pow(kPadToPodProx,2) + pow(self.iPodProx,2) - pow(self.iPadProx,2)) / (2*self.iPodProx*kPadToPodProx);
    CGFloat d = acos(cosd);     
    CGFloat fi = acos(cosfi);
    //look for a method of inverse cos
    CGFloat theta = fi - d;
    
    goatX = self.iPodProx* cos(theta);
    goatY = self.iPodProx * sin(theta);
    
    //change these from meters to squares
    [self.xyLabel setText:[NSString stringWithFormat:@"%.2f,%.2f", metersToSquares(goatX), metersToSquares(goatY)]];

}


//-(void)getXY{
//    kiPadX; //dx
//    kiPadY; //dy initialise coordinates somehow
//    kiPodX; //ex
//    kiPodY; //ey
//    self.iPadProx; //A
//    kPadToPodProx; //B 9.906m
//    self.iPodProx; //C
//    
//    //all in meters
//    CGFloat cosd = kiPodX / kPadToPodProx;
//    CGFloat cosfi = (pow(self.iPadProx,2) + pow(self.iPadProx,2) - pow(self.iPadProx,2)) / (2*self.iPadProx*kPadToPodProx);
//    CGFloat d = acos(cosd);     //acos is a method in java.math
//    CGFloat fi = acos(cosfi);   //you will have to find an equivalent in your chosen language
//    //look for a method of inverse cos
//    CGFloat theta = fi - d;
//    
//    goatX = self.iPadProx* cos(theta);
//    goatY = self.iPadProx * sin(theta);
//    
//    //change these from meters to squares
//    [self.xyLabel setText:[NSString stringWithFormat:@"%.2f,%.2f", metersToSquares(goatX), metersToSquares(goatY)]];
//    
//}

- (NSMutableArray*) prependStringsInArray:(NSMutableArray*)originalArray withPrefix:(NSString*)prefix
{
    NSMutableArray *newArray = [[NSMutableArray alloc] init];
    for( NSString *currString in originalArray )
    {
        NSString *newString = [NSString stringWithFormat:@"%@-%@", prefix, currString];
        [newArray addObject:newString];
    }
    
    return newArray;
}

- (void)viewDidAppear:(BOOL)animated
{
//    // Start ranging when the view appears.
//    for (CLBeaconRegion *beaconRegion in [UAPlistManager sharedDefaults].beaconRegions)
//    {
//    [_locationManager startRangingBeaconsInRegion:beaconRegion];
//    }
   
}

- (void)viewDidDisappear:(BOOL)animated
{
//    // Stop ranging when the view goes away.
//    for (CLBeaconRegion *beaconRegion in [UAPlistManager sharedDefaults].beaconRegions)
//    {
//        [_locationManager stopRangingBeaconsInRegion:beaconRegion];
//    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Init UABeaconManager

    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(managerDidRangeBeacons)
     name:@"managerDidRangeBeacons"
     object:nil];
    
    int goatX = 2 * 9.75;
    int goatY = 21 * 9.75;
    
//    [UALocationService locationServicesEnabled];
//    [UALocationService locationServiceAuthorized];
//    [UALocationService airshipLocationServiceEnabled];
    
//    UALocationService *locationService = [[UAirship shared] locationService];
//    [locationService startReportingSignificantLocationChanges];
    
     [self.goat1 setHidden:YES];
     [self.goat2 setHidden:YES];
     [self.goat3 setHidden:YES];
     [self.connected setHidden:YES];
     [self.disconnected setHidden:NO];
    _beacons = [[NSMutableDictionary alloc] init];
    
    
    //390/2 + 9.75(one square)
    //643.5/3 + 9.75(one square)
    //1pixel = 2 inches = 0.0508 meters
    view = [[RadarView alloc]initWithFrame:CGRectMake(10, 100, 204.75, 331.5)];
    view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:view];
 
    tagArray = [[NSMutableArray alloc]init];
    UUIDStrings = [[NSMutableArray alloc]init];
    
    
    bleatUrl = [[NSBundle mainBundle] URLForResource:@"goat"
                                       withExtension:@"caf"];
    adamUrl = [[NSBundle mainBundle] URLForResource:@"hey_adam"
                                      withExtension:@"caf"];
    catUrl = [[NSBundle mainBundle] URLForResource:@"cat"
                                     withExtension:@"caf"];
    AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain(bleatUrl), &bleat);
    AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain(adamUrl), &adam);
    AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain(catUrl), &cat);
    loopCheck = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goatDarSwitchTouched:(id)sender {
    if ([self.goatDarSwitch isOn]) {
        //yay
    }
    else{
        [self.goat1 setHidden:YES];
        [self.goat2 setHidden:YES];
        [self.goat3 setHidden:YES];
        [self.connected setHidden:YES];
        [self.disconnected setHidden:NO];
    }
}

- (void)managerDidRangeBeacons
{
    // UABeaconManager will call this delegate method at 1 Hz with updated range information.
    // Beacons will be categorized and displayed by proximity.
    NSLog(@"%@", [[UARegionManager shared] monitoredBeaconRegions]);
    [self getBeaconUUIDStrings:[[UARegionManager shared] rangedBeacons]];
    [self getBeaconProximities:[[UARegionManager shared] rangedBeacons] inRegion:[[UARegionManager shared] currentRegion]];
    //[self getXY];//updats goatX and goatY

    //[view updateViewWithX:goatX andY:goatY];//draws goatX and goatY on screen
    
    if ([self.goatDarSwitch isOn]) {
 
        
        
        NSArray *immediateBeacons = [[[UARegionManager shared] rangedBeacons] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"proximity = %d", CLProximityImmediate]];
        if([immediateBeacons count]){
            [_beacons setObject:immediateBeacons forKey:[NSNumber numberWithInt:CLProximityImmediate]];
            //add all uuid strings to set as tags
            
            adamCheck = 0;
            AudioServicesPlayAlertSound(bleat);
            [tagArray removeAllObjects];
            NSString *tagToAdd = @"Immediate";
            
            
            
            [self.goat1 setHidden:NO];
            [self.goat2 setHidden:NO];
            [self.goat3 setHidden:NO];
            [self.connected setHidden:NO];
            [self.disconnected setHidden:YES];
            [tagArray addObjectsFromArray:[self prependStringsInArray:[self getBeaconUUIDStrings:[[UARegionManager shared] rangedBeacons]] withPrefix:tagToAdd]];
        }
        
        NSArray *nearBeacons = [[[UARegionManager shared] rangedBeacons] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"proximity = %d", CLProximityNear]];
        
        if([nearBeacons count]){
            [_beacons setObject:nearBeacons forKey:[NSNumber numberWithInt:CLProximityNear]];
            loopCheck++;
            adamCheck =0;
            if (loopCheck/2 == 1){
                AudioServicesPlaySystemSound(bleat);
                loopCheck = 0;
            }
            [tagArray removeAllObjects];
            NSString *tagToAdd = @"Near";
            [tagArray addObjectsFromArray:tagArray];
            
            [self.goat1 setHidden:NO];
            [self.goat2 setHidden:NO];
            [self.goat3 setHidden:YES];
            [self.connected setHidden:NO];
            [self.disconnected setHidden:YES];
            [tagArray addObjectsFromArray:[self prependStringsInArray:[self getBeaconUUIDStrings:[[UARegionManager shared] rangedBeacons]] withPrefix:tagToAdd]];
        }
        
        NSArray *farBeacons = [[[UARegionManager shared] rangedBeacons] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"proximity = %d", CLProximityFar]];
        if([farBeacons count]){
            [_beacons setObject:farBeacons forKey:[NSNumber numberWithInt:CLProximityFar]];
            
            loopCheck++;
            adamCheck =0;
            if (loopCheck/3 == 1){
                AudioServicesPlaySystemSound(bleat);
                loopCheck = 0;
            }
            [tagArray removeAllObjects];
            NSString *tagToAdd = @"Far";
            
            [self.goat1 setHidden:NO];
            [self.goat2 setHidden:YES];
            [self.goat3 setHidden:YES];
            [self.connected setHidden:NO];
            [self.disconnected setHidden:YES];
            [tagArray addObjectsFromArray:[self prependStringsInArray:[self getBeaconUUIDStrings:[[UARegionManager shared] rangedBeacons]] withPrefix:tagToAdd]];
        }
        
        NSArray *unknownBeacons = [[[UARegionManager shared] rangedBeacons] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"proximity = %d", CLProximityUnknown]];
        if([unknownBeacons count]){
            [tagArray removeAllObjects];
            [self.goat1 setHidden:YES];
            [self.goat2 setHidden:YES];
            [self.goat3 setHidden:YES];
            [self.connected setHidden:YES];
            [self.disconnected setHidden:NO];
            if(adamCheck == 0){
                AudioServicesPlayAlertSound(adam);
                adamCheck++;
            }
            
            
            }
            //Set Urban Airship tags for beacons in range
            if ([immediateBeacons count] || [nearBeacons count] || [farBeacons count] || [unknownBeacons count] ) {
                [UAPush shared].tags = [NSArray arrayWithArray:tagArray];//update locally
                [[UAPush shared] updateRegistration];//update server
            }
        
    }
}

@end
