//
//  ManualCheckInForm.m
//  IndyFoodTrucks
//
//  Created by Manny on 4/5/14.
//  Copyright (c) 2014 AppDar. All rights reserved.
//

#import "ManualCheckInForm.h"

@implementation ManualCheckInForm

- (NSArray *)fields
{
    return @[@"locationName",
             @{FXFormFieldKey: @"fromTime", FXFormFieldType: FXFormFieldTypeDateTime},
             @{FXFormFieldKey: @"toTime", FXFormFieldType: FXFormFieldTypeDateTime}];
}

@end
