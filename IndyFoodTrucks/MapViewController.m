//
//  MapViewController.m
//  IndyFoodTrucks
//
//  Created by Manny on 4/4/14.
//  Copyright (c) 2014 AppDar. All rights reserved.
//

#import "MapViewController.h"
#import "TruckDetailViewController.h"
#import "MyCustomAnnotation.h"

@interface MapViewController (){
    CLLocationManager *locationManager;
    NSMutableArray *annotations;
}

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
    
  
    PFQuery *query = [PFQuery queryWithClassName:@"Truck_Locations"];
   // [query whereKey:@"truckTwitterId" equalTo:@([userId integerValue])];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            [objects enumerateObjectsUsingBlock:^(PFObject *pfTruck, NSUInteger idx, BOOL *stop) {
                
                PFObject *truckObject = (PFObject*)pfTruck[@"truck"];
                [truckObject fetchIfNeeded];
                
                TruckForm *theTruck = [TruckForm new];
                theTruck.truckId = pfTruck.objectId;
                if (truckObject[@"truckAvatarURL"]) theTruck.truckAvatarURL = truckObject[@"truckAvatarURL"];
                if (truckObject[@"truckInfo"]) theTruck.truckInfo = truckObject[@"truckInfo"];
                if (truckObject[@"truckMenuURL"]) theTruck.truckMenuURL = truckObject[@"truckMenuURL"];
                if (truckObject[@"truckName"]) theTruck.truckName = truckObject[@"truckName"];
                if (truckObject[@"truckPhone"]) theTruck.truckPhone = truckObject[@"truckPhone"];
                if (truckObject[@"truckTwitter"]) theTruck.truckTwitter = truckObject[@"truckTwitter"];
                if (truckObject[@"truckTwitterId"]) theTruck.truckTwitterId = truckObject[@"truckTwitterId"];
                if (truckObject[@"truckWebsite"]) theTruck.truckWebsite = truckObject[@"truckWebsite"];
                
                MyCustomAnnotation *myCustomAnnotation = [[MyCustomAnnotation alloc] initWithTruck:theTruck];
                
                PFGeoPoint *currentLocationGeoPoint = pfTruck[@"truckLocation"];
                
                myCustomAnnotation.coordinate = CLLocationCoordinate2DMake(currentLocationGeoPoint.latitude, currentLocationGeoPoint.longitude) ;
        
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [annotations addObject:myCustomAnnotation];
                    [self.mapview addAnnotation:myCustomAnnotation];
                });
                
                
            }];

            NSLog(@"Successfully retrieved %lu trucks.", (unsigned long)objects.count);
           // [self.theTableview reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        MKCoordinateRegion region;
        region.center = CLLocationCoordinate2DMake(39.768403, -86.158068);
    
        MKCoordinateSpan span;
        span.latitudeDelta  = 0.2; // Change these values to change the zoom
        span.longitudeDelta = 0.2;
        region.span = span;
        
        [self.mapview setRegion:region animated:YES];
        
       // [self.mapview setCenterCoordinate:self.mapview.userLocation.coordinate animated:YES];
    });
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

//Keep reference of the selected annotation
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)aView
{
    if (![aView.annotation isKindOfClass:[MyCustomAnnotation class]]) return;
    
    MyCustomAnnotation *myCustomAnn = (MyCustomAnnotation *)aView.annotation;
   
    TruckDetailViewController *truckDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TruckDetail"];
    truckDetailViewController.truck = myCustomAnn.truck;
    
    [self.navigationController pushViewController:truckDetailViewController animated:YES];
    

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
