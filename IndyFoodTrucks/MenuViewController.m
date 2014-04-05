//
//  MenuViewController.m
//  IndyFoodTrucks
//
//  Created by Manny on 4/4/14.
//  Copyright (c) 2014 AppDar. All rights reserved.
//

#import "MenuViewController.h"
#import "MSMenuTableViewHeader.h"
#import "MSMenuCell.h"
#import "TruckSingleton.h"
#import "CCActionSheet.h"
#import "TruckForm.h"
#import "TruckDetailViewController.h"
#import "TrucksViewController.h"
#import "YelpTruckViewController.h"

#define ARCHIVE_FAV_TRUCKS_KEY @"ARCHIVE_FAV_TRUCKS_KEY"

NSString * const MSMenuCellReuseIdentifier = @"Drawer Cell";
NSString * const MSDrawerHeaderReuseIdentifier = @"Drawer Header";

@interface MenuViewController () <UIActionSheetDelegate, YelpTruckViewControllerDelegate> {
    NSDate *pickerDate;
    NSMutableArray *favTrucks;
}

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIButton *manageTrucksBtn;

@end

@implementation MenuViewController

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
    // Do any additional setup after loading the view.
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:ARCHIVE_FAV_TRUCKS_KEY];
    favTrucks = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if (!favTrucks) favTrucks = [NSMutableArray new];
    
    [self.tableView registerClass:[MSMenuCell class] forCellReuseIdentifier:MSMenuCellReuseIdentifier];
    [self.tableView registerClass:[MSMenuTableViewHeader class] forHeaderFooterViewReuseIdentifier:MSDrawerHeaderReuseIdentifier];
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, self.manageTrucksBtn.frame.size.height, 0.0);
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2) return favTrucks.count+1;
    return 1;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor colorWithRed:46.0f/255.0f green:62.0f/255.0f blue:82.0f/255.0f alpha:1.0f]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MSMenuCellReuseIdentifier forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        NSDate *selectedDate = [TruckSingleton singleton].selectedDate;
        
        if (!selectedDate){
            cell.textLabel.text = @"Today";
        }else{
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"MMM d, YYYY"];
            cell.textLabel.text = [dateFormat stringFromDate:selectedDate];
        }
        
    } else if (indexPath.section == 1) {
        
        NSInteger selectedTime = [TruckSingleton singleton].selectedTime;
        if (selectedTime == TruckTimeTypeAnytime){
           cell.textLabel.text = @"Anytime";
        }else if(selectedTime == TruckTimeTypeBreakfast){
            cell.textLabel.text = @"Breakfast";
        }else if(selectedTime == TruckTimeTypeLunch){
            cell.textLabel.text = @"Lunch";
        }else if(selectedTime == TruckTimeTypeDinner){
            cell.textLabel.text = @"Dinner";
        }
        
    } else if (indexPath.section == 2) {
        
        if (indexPath.row == favTrucks.count) {
            
            cell.textLabel.text = @"+ Add a Truck";
            
        } else {
            TruckForm *truck = [favTrucks objectAtIndex:indexPath.row];
            cell.textLabel.text = truck.truckName;
        }
        
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0){
        NSString *title = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? @"\n\n\n\n\n\n\n\n\n" : @"\n\n\n\n\n\n\n\n\n\n\n\n" ;
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:[NSString stringWithFormat:@"%@%@", title, NSLocalizedString(@"Select Date", @"")]
                                      delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [actionSheet showInView:self.view.superview];
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        datePicker.datePickerMode = UIDatePickerModeDate;
        [datePicker addTarget:self
                            action:@selector(showdate:)
                  forControlEvents:UIControlEventValueChanged];

        [actionSheet addSubview:datePicker];

    }else if (indexPath.section == 1){
        CCActionSheet *actionSheet = [[CCActionSheet alloc] initWithTitle:@"Select Time"];
        
        [actionSheet addButtonWithTitle:@"Anytime" block:^{
            [TruckSingleton singleton].selectedTime = TruckTimeTypeAnytime;
            [_tableView reloadData];
            UINavigationController *controller = (UINavigationController*)self.dynamicsDrawerViewController.paneViewController;
            [controller popToRootViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTruckLocations" object:nil];
            [_tableView reloadData];
            [self.dynamicsDrawerViewController setPaneState:MSDynamicsDrawerPaneStateClosed animated:YES allowUserInterruption:NO completion:^{
                
            }];
            
        }];
        
        [actionSheet addButtonWithTitle:@"Breakfast" block:^{
            [TruckSingleton singleton].selectedTime = TruckTimeTypeBreakfast;
            [_tableView reloadData];
            
            UINavigationController *controller = (UINavigationController*)self.dynamicsDrawerViewController.paneViewController;
            [controller popToRootViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTruckLocations" object:nil];
            [_tableView reloadData];
            [self.dynamicsDrawerViewController setPaneState:MSDynamicsDrawerPaneStateClosed animated:YES allowUserInterruption:NO completion:^{
                
            }];
        }];
        
        [actionSheet addButtonWithTitle:@"Lunch" block:^{
            [TruckSingleton singleton].selectedTime = TruckTimeTypeLunch;
            [_tableView reloadData];
            
            UINavigationController *controller = (UINavigationController*)self.dynamicsDrawerViewController.paneViewController;
            [controller popToRootViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTruckLocations" object:nil];
            [_tableView reloadData];
            [self.dynamicsDrawerViewController setPaneState:MSDynamicsDrawerPaneStateClosed animated:YES allowUserInterruption:NO completion:^{
                
            }];
        }];
        
        [actionSheet addButtonWithTitle:@"Dinner" block:^{
            [TruckSingleton singleton].selectedTime = TruckTimeTypeDinner;
            [_tableView reloadData];
            
            UINavigationController *controller = (UINavigationController*)self.dynamicsDrawerViewController.paneViewController;
            [controller popToRootViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTruckLocations" object:nil];
            [_tableView reloadData];
            [self.dynamicsDrawerViewController setPaneState:MSDynamicsDrawerPaneStateClosed animated:YES allowUserInterruption:NO completion:^{
                
            }];
        }];
        
        [actionSheet addCancelButtonWithTitle:@"Cancel"];
        
        [actionSheet showInView:self.view.superview];
        
    } else if (indexPath.section == 2) {
        
        if (indexPath.row == favTrucks.count) {
            
            YelpTruckViewController *yelpTruckViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"YelpTruckViewController"];
            yelpTruckViewController.delegate = self;
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:yelpTruckViewController];
            [self.dynamicsDrawerViewController.paneViewController presentViewController:navigationController animated:YES completion:nil];
            
        } else {
            
            TruckForm *truck = [favTrucks objectAtIndex:indexPath.row];
            TruckDetailViewController *truckDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TruckDetail"];
            truckDetailViewController.truck = truck;
            
            UINavigationController *controller = (UINavigationController*)self.dynamicsDrawerViewController.paneViewController;
            [controller pushViewController:truckDetailViewController animated:YES];
            [self.dynamicsDrawerViewController setPaneViewController:controller animated:YES completion:nil];
            
        }
        

    }
}

#pragma mark - Yelp Truck View Controller 

- (void)truckSelected:(YLBusiness *)truck
{
    [self.dynamicsDrawerViewController.paneViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    PFObject *theTruck = [PFObject objectWithClassName:@"Trucks"];
    theTruck[@"truckName"] = truck.name;
    if (truck.image_url) theTruck[@"truckAvatarURL"] = truck.image_url;
    if (truck.phone) theTruck[@"truckPhone"] = truck.phone;
    if (truck.url) theTruck[@"truckWebsite"] = truck.url;
    
    TruckForm *truckObject = [TruckForm new];
    truckObject.truckName = truck.name;
    
    if (truck.image_url) truckObject.truckAvatarURL = truck.image_url;
    if (truck.phone) truckObject.truckPhone = truck.phone;
    if (truck.url) truckObject.truckWebsite = truck.url;
    
    [favTrucks addObject:truckObject];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:favTrucks];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:ARCHIVE_FAV_TRUCKS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.tableView reloadData];
}

-(void)showdate:(id)sender{
    UIDatePicker *datePicker = (UIDatePicker *)sender;
    pickerDate = datePicker.date;
    NSLog(@"Sender: %@", datePicker.date);
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0){
        if (![pickerDate isEqualToDate:[TruckSingleton singleton].selectedDate]){
            [TruckSingleton singleton].selectedDate = pickerDate;
            UINavigationController *controller = (UINavigationController*)self.dynamicsDrawerViewController.paneViewController;
            [controller popToRootViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTruckLocations" object:nil];
            [_tableView reloadData];
            [self.dynamicsDrawerViewController setPaneState:MSDynamicsDrawerPaneStateClosed animated:YES allowUserInterruption:NO completion:^{
                
            }];
            //Refersh mapview
        }
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:MSDrawerHeaderReuseIdentifier];
    
    if (section == 0) {
        headerView.textLabel.text = @"Date";
        
    } else if (section == 1) {
        headerView.textLabel.text = @"Time";
        
    } else if (section == 2) {
        headerView.textLabel.text = @"Favorites";
        
    }
    return headerView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)manageTrucks:(id)sender {
    TrucksViewController *trucksViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TrucksViewController"];
   
    
    UINavigationController *controller = (UINavigationController*)self.dynamicsDrawerViewController.paneViewController;
    [controller pushViewController:trucksViewController animated:YES];
    [self.dynamicsDrawerViewController setPaneViewController:controller animated:YES completion:nil];
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
