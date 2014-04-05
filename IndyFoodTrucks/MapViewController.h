//
//  MapViewController.h
//  IndyFoodTrucks
//
//  Created by Manny on 4/4/14.
//  Copyright (c) 2014 AppDar. All rights reserved.
//

@interface MapViewController : UIViewController
#import <MapKit/MapKit.h>

@property (nonatomic, weak) MSDynamicsDrawerViewController *dynamicsDrawerViewController;

@property (nonatomic, strong) IBOutlet MKMapView *mapview;

@end
