//
//  RadarView.m
//  UABeacons
//
//  Created by David Crow on 9/26/13.
//  Copyright (c) 2013 David Crow. All rights reserved.
//

#import "RadarView.h"

@implementation RadarView

/*UA presentation room can be divided into 660 floor squares - each 19.5 inches across
 * to fit in a reasonable coordinate system on screen, this is at half scale, so each square is roughly
 * 9.75 pixels across
 * 0,0 starts at top left of room
 */

// 390/2 + 9.75(one square)
// 643.5/3 + 9.75(one square)
// 1pixel = 2 inches = 0.0508 meters

#define kiPadX 0 //0 * 9.75
#define kiPadY 0 //33 * 9.75
#define kiPodX 195 //20 * 9.75
#define kiPodY 0 //33 * 9.75

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//    [[NSNotificationCenter defaultCenter]
//    addObserver:self
//    selector:@selector(updateView)
//    name:@"updateView"
//    object:nil];
    }
    return self;
}

//
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    // Drawing Rect
//    [[UIColor redColor] setFill]; // red
//    UIRectFill(CGRectInset(self.bounds, 100, 100));
//}


//frame is 195 x 321.75 pixels
-(void)drawRect:(CGRect)rect
{

    [self drawBeaconRects:(CGRect)rect];

}


-(void)drawBeaconRects:(CGRect)rect
{
    CGContextRef cont = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(cont, 1.0, 1.0, 0.0, 1.0);
    CGContextFillRect(cont, CGRectMake(kiPadX, kiPadY, 9.75, 9.75));
    CGContextSetRGBFillColor(cont, 1.0, 0.0, 1.0, 1.0);
    CGContextFillRect(cont, CGRectMake(kiPodX, kiPodY, 9.75, 9.75));
    CGContextSetRGBFillColor(cont, 0.0, 0.0, 1.0, 1.0);
    CGContextFillRect(cont, CGRectMake(140, 80, 9.75, 9.75));
}

-(void)updateView
{
    CGContextRef cont = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(cont, 1.0, 1.0, 0.0, 1.0);
    CGContextFillRect(cont, CGRectMake(0.0, 0.0, 9.75, 9.75));
}

-(void)updateViewWithX:(int) x andY:(int) y
{
    CGContextRef cont = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(cont, 1.0, 0.0, 1.0, 0.0);
    CGContextFillRect(cont, CGRectMake(x, y, 9.75, 9.75));
}

@end
