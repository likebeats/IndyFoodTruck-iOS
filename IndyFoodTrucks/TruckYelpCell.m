//
//  TruckYelpCell.m
//  IndyFoodTrucks
//
//  Created by Manny on 4/5/14.
//  Copyright (c) 2014 AppDar. All rights reserved.
//

#import "TruckYelpCell.h"

@implementation TruckYelpCell

- (void)awakeFromNib
{
    // Initialization code
    
    [self.truckImageView.layer setCornerRadius:10];
    [self.truckImageView.layer setMasksToBounds:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
