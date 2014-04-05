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