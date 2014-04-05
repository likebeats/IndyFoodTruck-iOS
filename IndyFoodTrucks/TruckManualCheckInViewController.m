//
//  TruckManualCheckInViewController.m
//  IndyFoodTrucks
//
//  Created by Manny on 4/5/14.
//  Copyright (c) 2014 AppDar. All rights reserved.
//

#import "TruckManualCheckInViewController.h"
#import "ManualCheckInForm.h"
#import <MapKit/MapKit.h>

@interface TruckManualCheckInViewController () <FXFormControllerDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) FXFormController *formController;

@property (nonatomic, strong) IBOutlet MKMapView *mapView;

@end

@implementation TruckManualCheckInViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Manual";
    
    self.formController = [[FXFormController alloc] init];
    self.formController.tableView = self.tableView;
    self.formController.delegate = self;
    self.formController.form = [[ManualCheckInForm alloc] init];
    
    UIImageView *marker = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"marker"]];
    marker.center = CGPointMake(self.mapView.frame.size.width/2, self.mapView.frame.size.height/2-marker.frame.size.height/2);
    [self.mapView addSubview:marker];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        MKCoordinateRegion region;
        region.center = CLLocationCoordinate2DMake(39.768403, -86.158068);
        
        MKCoordinateSpan span;
        span.latitudeDelta  = 0.2;
        span.longitudeDelta = 0.2;
        region.span = span;
        
        [self.mapView setRegion:region animated:NO];
    });
}

-  (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIBarButtonItem *checkInBtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Check In", nil)
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(onCheckInBtnClicked:)];
    self.navigationItem.rightBarButtonItem = checkInBtn;
    
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil)
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(onCancelBtnClicked:)];
    self.navigationItem.leftBarButtonItem = cancelBtn;
    
    [self.tableView reloadData];
}

- (void)onCancelBtnClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onCheckInBtnClicked:(id)sender
{
    ManualCheckInForm *checkInForm = self.formController.form;
    CLLocationCoordinate2D coordinates = self.mapView.centerCoordinate;
    
    PFGeoPoint *geoPoint = [PFGeoPoint new];
    geoPoint.latitude = coordinates.latitude;
    geoPoint.longitude = coordinates.longitude;
    
    PFObject *theTruck = [PFObject objectWithoutDataWithClassName:@"Trucks" objectId:self.truck.truckId];
//    theTruck[@"objectId"] = self.truck.truckId;
//    theTruck[@"truckName"] = self.truck.truckName;
//    theTruck[@"truckAvatarURL"] = sle.ftruck.truckAvatarURL;
//    theTruck[@"truckPhone"] = truck.truckPhone;
//    theTruck[@"truckWebsite"] = truck.truckMenuURL;
    
    PFObject *theTruckLocation = [PFObject objectWithClassName:@"Truck_Locations"];
    theTruckLocation[@"truckLocation"] = geoPoint;
    theTruckLocation[@"truck"] = theTruck;
    theTruckLocation[@"locationName"] = checkInForm.locationName;
    theTruckLocation[@"fromTime"] = checkInForm.fromTime;
    theTruckLocation[@"toTime"] = checkInForm.toTime;
    
    [theTruckLocation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
