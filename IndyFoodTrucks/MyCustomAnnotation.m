//
//  MyCustomAnnotation.m
//  BuddyTag
//
//  Created by sj singh on 3/14/14.
//  Copyright (c) 2014 AppDar. All rights reserved.
//

#import "MyCustomAnnotation.h"

@interface MyCustomAnnotation (){
    
}

@end

@implementation MyCustomAnnotation
@synthesize truck;

- (id)initWithTruck:(TruckForm *)theTruck {
    
    self = [super init];
    if (self)
        truck = theTruck;

    return self;
}

//-(BOOL)isEqual:(MyCustomAnnotation *)object {
//    //if (![object isKindOfClass:[MyCustomAnnotation class]]) return NO;
//    
//    if ([object.location.locationUser isEqual:self.location.locationUser]) return YES;
//    else return NO;
//}
@end
