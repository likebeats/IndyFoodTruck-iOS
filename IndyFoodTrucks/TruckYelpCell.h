//
//  TruckYelpCell.h
//  IndyFoodTrucks
//
//  Created by Manny on 4/5/14.
//  Copyright (c) 2014 AppDar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TruckYelpCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *truckImageView;
@property (nonatomic, strong) IBOutlet UILabel *truckTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *truckDetailLabel;

@end
