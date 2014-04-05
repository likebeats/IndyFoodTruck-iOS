//
//  AutomaticCheckInForm.h
//  IndyFoodTrucks
//
//  Created by Manny on 4/5/14.
//  Copyright (c) 2014 AppDar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXForms.h"

@interface AutomaticCheckInForm : NSObject <FXForm>

@property (nonatomic, copy) NSDate *endTime;

@end
