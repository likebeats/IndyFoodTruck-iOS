//
//  MapViewController.m
//  IndyFoodTrucks
//
//  Created by Manny on 4/4/14.
//  Copyright (c) 2014 AppDar. All rights reserved.
//

#import "MapViewController.h"
#import "TruckDetailViewController.h"

@interface MapViewController ()

@end



@implementation MapViewController

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
    
    self.title = @"#IndyFoodTrucks";

    //[self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"TruckForm"] animated:NO];
    
    TruckForm *truckForm = [[TruckForm alloc] init];
    truckForm.truckName = @"Truck Name";
    
    TruckDetailViewController *truckDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TruckDetail"];
    truckDetailViewController.truck = truckForm;
    
    [self.navigationController pushViewController:truckDetailViewController animated:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIImage *menuBtnImage = [UIImage imageNamed:@"menu_icon"];
    CGRect menuBtnImageFrame = CGRectMake(0, 0, menuBtnImage.size.width, menuBtnImage.size.height);
    UIButton *menuBtn = [[UIButton alloc] initWithFrame:menuBtnImageFrame];
    [menuBtn setImage:menuBtnImage forState:UIControlStateNormal];
    [menuBtn setTitle:nil forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(onMenuBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *menuBtnItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    self.navigationItem.leftBarButtonItem = menuBtnItem;
}

- (void)onMenuBtnClick
{
    [self.dynamicsDrawerViewController setPaneState:MSDynamicsDrawerPaneStateOpen
                                        inDirection:MSDynamicsDrawerDirectionLeft
                                           animated:YES
                              allowUserInterruption:YES
                                         completion:nil];
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
