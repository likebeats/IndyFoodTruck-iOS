//
//  MyCustomAnnotation.h
//  BuddyTag
//
//  Created by sj singh on 3/14/14.
//  Copyright (c) 2014 AppDar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "TruckForm.h"

@interface MyCustomAnnotation : NSObject <MKAnnotation>

@property (nonatomic,nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) TruckForm *truck;

@property (nonatomic, copy) NSString *title;

- (id)initWithTruck:(TruckForm *)theTruck;

@end
