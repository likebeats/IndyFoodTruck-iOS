//
//  TruckSingleton.h
//  IndyFoodTrucks
//
//  Created by sj singh on 4/4/14.
//  Copyright (c) 2014 AppDar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import <Twitter/Twitter.h>

@interface TruckSingleton : NSObject

+ (TruckSingleton*)singleton;

@property (nonatomic, strong) ACAccount *twitterAccount;

@property (nonatomic, strong) NSDictionary *twitterUserInfo;

@end
