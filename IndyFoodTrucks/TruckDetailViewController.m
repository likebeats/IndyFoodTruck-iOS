//
//  TruckDetailViewController.m
//  IndyFoodTrucks
//
//  Created by Manny on 4/4/14.
//  Copyright (c) 2014 AppDar. All rights reserved.
//

#import "TruckDetailViewController.h"
#import "TruckFormViewController.h"
#import "CCActionSheet.h"
#import "UIImageView+AFNetworking.h"
#import "LocationMapCell.h"
#import "TruckManualCheckInViewController.h"
#import "TruckAutomaticCheckInViewController.h"
#import "TruckFutureLocationsViewController.h"
#import "WebviewViewController.h"

@interface TruckDetailViewController () <UITableViewDelegate>
{
    NSMutableArray *locations;
    PFObject *currentLocationObject;
}

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end

@implementation TruckDetailViewController

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
    
    self.title = self.truck.truckName;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIBarButtonItem *favBtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"+Fav", nil)
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(onFavBtnClick:)];
    self.navigationItem.rightBarButtonItem = favBtn;
    
    PFQuery *query = [PFQuery queryWithClassName:@"Truck_Locations"];
    [query whereKey:@"truck" equalTo:[PFObject objectWithoutDataWithClassName:@"Trucks" objectId:self.truck.truckId]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            locations = [[NSMutableArray alloc] initWithArray:[[objects reverseObjectEnumerator] allObjects]];
            [locations enumerateObjectsUsingBlock:^(PFObject *location, NSUInteger idx, BOOL *stop) {
                NSDate *fromTime = [location objectForKey:@"fromTime"];
                NSDate *toTime = [location objectForKey:@"toTime"];
                
                if (([[NSDate date] compare:fromTime] == NSOrderedDescending) &&
                    ([[NSDate date] compare:toTime] == NSOrderedAscending)) {
                    currentLocationObject = location;
                    *stop = YES;
                }
            }];
            
            NSLog(@"Locations %@", locations);
            NSLog(@"currentLocationObject %@", currentLocationObject);
            
            [self.tableView reloadData];
        }
    }];
}

- (void)onFavBtnClick:(id)sender
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"ARCHIVE_FAV_TRUCKS_KEY"];
    NSMutableArray *favTrucks = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if (!favTrucks) favTrucks = [NSMutableArray new];
    
    [favTrucks addObject:self.truck];
    
    NSData *data2 = [NSKeyedArchiver archivedDataWithRootObject:favTrucks];
    [[NSUserDefaults standardUserDefaults] setObject:data2 forKey:@"ARCHIVE_FAV_TRUCKS_KEY"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadMenuView" object:nil];
}

- (IBAction)onCheckBtnClick:(id)sender
{
    CCActionSheet *sheet = [[CCActionSheet alloc] initWithTitle:NSLocalizedString(@"Select check-in method", nil)];
    [sheet addButtonWithTitle:@"Automatic" block:^{
        
        TruckAutomaticCheckInViewController *checkInViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TruckAutomaticCheckIn"];
        checkInViewController.truck = self.truck;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:checkInViewController];
        [self.navigationController presentViewController:navigationController animated:YES completion:nil];
        
    }];
    [sheet addButtonWithTitle:@"Manual" block:^{
        
        TruckManualCheckInViewController *checkInViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TruckManualCheckIn"];
        checkInViewController.truck = self.truck;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:checkInViewController];
        [self.navigationController presentViewController:navigationController animated:YES completion:nil];
        
    }];
    
    [sheet addCancelButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
    [sheet showInView:self.view];
}

#pragma mark -
#pragma mark Datasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (currentLocationObject || locations.count > 0) return 2;
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)index
{
    if (index == 0 && currentLocationObject) return @"Current Location";
    if (index == 0 && locations.count > 0) return @" ";
    return @"Truck Information";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)index
{
    if (index == 0 && locations.count > 1) return 2;
    if (index == 0 && locations.count > 0) return 1;
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0 && currentLocationObject) return 150;
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (currentLocationObject || locations.count > 0) {
        if (indexPath.section == 0) {
            
            if (indexPath.row == 0 && currentLocationObject) {
                
                return [self currentLocationCell];
                
            } else if (indexPath.row == 1 && currentLocationObject) {
                
                return [self futureLocationsCell];
            }
            
            if (indexPath.row == 0 && locations.count > 0) {
                
                return [self futureLocationsCell];
                
            }
            
            return nil;
            
        } else if (indexPath.section == 1) {
            
            return [self truckDetailsCell:indexPath];
            
        }
    } else {
        
        return [self truckDetailsCell:indexPath];
        
    }
    
    return nil;
}

- (LocationMapCell *)currentLocationCell
{
    static NSString *CellIdentifier = @"LocationMapCell";
    LocationMapCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [self.tableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellReuseIdentifier:CellIdentifier];
        cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMM d h:mm a"];
    
    PFGeoPoint *currentLocationGeoPoint = [currentLocationObject objectForKey:@"truckLocation"];
    NSDate *currentFromTime = [currentLocationObject objectForKey:@"fromTime"];
    NSDate *currentToTime = [currentLocationObject objectForKey:@"toTime"];
    
    NSString *string = @"%7C";
    NSString *mapURL = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/staticmap?center=%f,%f&zoom=14&size=320x150&maptype=roadmap&markers=color:green%@%f,%f&sensor=false", currentLocationGeoPoint.latitude, currentLocationGeoPoint.longitude, string, currentLocationGeoPoint.latitude, currentLocationGeoPoint.longitude];
    [cell.mapImageView setImageWithURL:[NSURL URLWithString:mapURL]
                      placeholderImage:nil];
    [cell.mapCaptionLabel setText:[NSString stringWithFormat:@"%@ to %@", [dateFormat stringFromDate:currentFromTime], [dateFormat stringFromDate:currentToTime]]];
    
    return cell;
}

- (UITableViewCell *)futureLocationsCell
{
    static NSString *CellIdentifier = @"TruckDetailCell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = @"Future Locations";
    cell.detailTextLabel.text = @"";
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (UITableViewCell *)truckDetailsCell:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TruckDetailCell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Name";
        cell.detailTextLabel.text = self.truck.truckName;
        
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"Description";
        cell.detailTextLabel.text = self.truck.truckInfo;
        
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"Menu URL";
        cell.detailTextLabel.text = self.truck.truckMenuURL;
        
    } else if (indexPath.row == 3) {
        cell.textLabel.text = @"Phone";
        cell.detailTextLabel.text = self.truck.truckPhone;
        
    } else if (indexPath.row == 4) {
        cell.textLabel.text = @"Website";
        cell.detailTextLabel.text = self.truck.truckWebsite;
        
    }
    
    return cell;
}

#pragma mark -
#pragma mark Delegate methods

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
     if (indexPath.row == 2) {
         WebviewViewController *webviewViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"webview"];
         webviewViewController.url = self.truck.truckMenuURL;
         
         [self.navigationController pushViewController:webviewViewController animated:YES];
         NSLog(@"Open URL");
     }else if(indexPath.row == 4){
         WebviewViewController *webviewViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"webview"];
         webviewViewController.url = self.truck.truckWebsite;
         
         [self.navigationController pushViewController:webviewViewController animated:YES];
     }
    
    if (locations.count > 1) {
        if (indexPath.section == 0 && indexPath.row == 1) {
            
            [self openFutureLocationsController];
            
        }
    } else if (locations.count > 0) {
        if (indexPath.section == 0 && indexPath.row == 0) {
            
            [self openFutureLocationsController];
            
        }
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)openFutureLocationsController
{
    TruckFutureLocationsViewController *truckFutureViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TruckFutureLocationsViewController"];
    truckFutureViewController.locations = locations;
    truckFutureViewController.currentLocationObject = currentLocationObject;
    [self.navigationController pushViewController:truckFutureViewController animated:YES];
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
