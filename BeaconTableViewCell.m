//
//  RegionTableViewCell.m
//  UABeacons
//
//  Created by David Crow on 10/31/13.
//  Copyright (c) 2013 David Crow. All rights reserved.
//

#import "BeaconTableViewCell.h"

@implementation BeaconTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
