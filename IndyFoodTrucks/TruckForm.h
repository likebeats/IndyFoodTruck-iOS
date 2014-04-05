//
//  TruckForm.h
//  IndyFoodTrucks
//
//  Created by Manny on 4/4/14.
//  Copyright (c) 2014 AppDar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXForms.h"

@interface TruckForm : NSObject <FXForm>

@property (nonatomic, copy) NSString *truckId;
@property (nonatomic, copy) NSString *truckName;
@property (nonatomic, copy) NSString *truckInfo;
@property (nonatomic, copy) NSString *truckMenuURL;
@property (nonatomic, copy) NSString *truckTwitter;
@property (nonatomic, copy) NSString *truckTwitterId;
@property (nonatomic, copy) NSString *truckWebsite;
@property (nonatomic, copy) NSString *truckPhone;

@end
