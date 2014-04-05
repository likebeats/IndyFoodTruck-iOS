//
//  TruckSingleton.m
//  IndyFoodTrucks
//
//  Created by sj singh on 4/4/14.
//  Copyright (c) 2014 AppDar. All rights reserved.
//

#import "TruckSingleton.h"


static TruckSingleton *singleton = nil;

@implementation TruckSingleton

+ (TruckSingleton*)singleton {
    if (!singleton)
        singleton = [[TruckSingleton alloc] init];
    
    return singleton;
}

@end
