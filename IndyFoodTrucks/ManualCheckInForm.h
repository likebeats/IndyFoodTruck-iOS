//
//  ManualCheckInForm.h
//  IndyFoodTrucks
//
//  Created by Manny on 4/5/14.
//  Copyright (c) 2014 AppDar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXForms.h"

@interface ManualCheckInForm : NSObject <FXForm>

@property (nonatomic, copy) NSString *locationName;
@property (nonatomic, copy) NSDate *fromTime;
@property (nonatomic, copy) NSDate *toTime;

@end
