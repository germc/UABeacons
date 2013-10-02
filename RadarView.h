//
//  RadarView.h
//  UABeacons
//
//  Created by David Crow on 9/26/13.
//  Copyright (c) 2013 David Crow. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface RadarView : UIView

-(void)updateView;
-(void)updateViewWithX:(int) x andY:(int) y;
@end
