//
//  AutomaticCheckInForm.m
//  IndyFoodTrucks
//
//  Created by Manny on 4/5/14.
//  Copyright (c) 2014 AppDar. All rights reserved.
//

#import "AutomaticCheckInForm.h"

@implementation AutomaticCheckInForm

- (NSArray *)fields
{
    return @[
             @{FXFormFieldKey: @"endTime", FXFormFieldType: FXFormFieldTypeDateTime}
             ];
}

@end
