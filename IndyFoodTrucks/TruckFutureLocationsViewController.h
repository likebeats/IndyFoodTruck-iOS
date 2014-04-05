//
//  TruckFutureLocationsViewController.h
//  IndyFoodTrucks
//
//  Created by Manny on 4/5/14.
//  Copyright (c) 2014 AppDar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TruckFutureLocationsViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *locations;
@property (nonatomic, strong) PFObject *currentLocationObject;

@end
