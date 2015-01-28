//
//  MapViewController.h
//  IndyFoodTrucks
//
//  Created by Manny on 4/4/14.
//  Copyright (c) 2014 AppDar. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController

@property (nonatomic, weak) MSDynamicsDrawerViewController *dynamicsDrawerViewController;

@property (nonatomic, strong) IBOutlet MKMapView *mapview;

@end
