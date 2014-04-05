//
//  YelpTruckViewController.h
//  IndyFoodTrucks
//
//  Created by sj singh on 4/5/14.
//  Copyright (c) 2014 AppDar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLBusiness.h"


@protocol YelpTruckViewControllerDelegate <NSObject>

@optional
- (void)truckSelected:(YLBusiness *)truck;


@end

@interface YelpTruckViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *theTableview;

@property (nonatomic, weak) id<YelpTruckViewControllerDelegate> delegate;

@end
