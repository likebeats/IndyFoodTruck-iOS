//
//  YelpTruckViewController.h
//  IndyFoodTrucks
//
//  Created by sj singh on 4/5/14.
//  Copyright (c) 2014 AppDar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YelpTruckViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *theTableview;

@end
