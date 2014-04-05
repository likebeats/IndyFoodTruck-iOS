//
//  TruckSelectionViewController.m
//  IndyFoodTrucks
//
//  Created by Manny on 4/4/14.
//  Copyright (c) 2014 AppDar. All rights reserved.
//

#define ARCHIVE_TRUCKS_KEY @"ARCHIVE_TRUCKS_KEY2"

#import "TrucksViewController.h"
#import "TruckFormViewController.h"
#import "YelpTruckViewController.h"
#import "TruckForm.h"
#import "TruckDetailViewController.h"

@interface TrucksViewController () <YelpTruckViewControllerDelegate>{
    NSMutableArray *trucks;
    BOOL noTrucks;
    
}

@end

@implementation TrucksViewController
@synthesize theTableview;

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
    
    self.title = @"My Trucks";
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Add", nil)
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:@selector(onAddBtnClicked:)];
    self.navigationItem.rightBarButtonItem = addBtn;
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:ARCHIVE_TRUCKS_KEY];
    trucks = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if (!trucks) trucks = [NSMutableArray new];

}

- (void)onAddBtnClicked:(id)sender
{
   // TruckFormViewController *truckFormViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TruckForm"];
    //[self.navigationController pushViewController:truckFormViewController animated:YES];
    
    
    YelpTruckViewController *yelpTruckViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"YelpTruckViewController"];
    yelpTruckViewController.delegate = self;
    [self.navigationController pushViewController:yelpTruckViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (trucks.count == 0 && trucks != nil) return 1;
    return [trucks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (trucks.count == 0){
        return [self noTrucksCell];
    }
    
    TruckForm *truck = (TruckForm*)trucks[indexPath.row];

    static NSString *CellIdentifier = @"TruckCell";
    UITableViewCell *cell = [self.theTableview dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.textLabel.text = truck.truckName;
    return cell;
}

- (UITableViewCell *) noTrucksCell  {
    static NSString *CellIdentifier = @"NoTruckCell";
    UITableViewCell *cell = [self.theTableview dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.textLabel.text = @"No trucks found. Please add a truck";
    return cell;

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TruckForm *truck = (TruckForm*)trucks[indexPath.row];
    [theTableview deselectRowAtIndexPath:indexPath animated:YES];
    TruckDetailViewController *truckDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TruckDetail"];
    truckDetailViewController.truck = truck;
    [self.navigationController pushViewController:truckDetailViewController animated:YES];
}

#pragma mark - Yelp Truck View Controller 

-(void)truckSelected:(YLBusiness *)truck {
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
    
    [trucks addObject:truckObject];
    
    [theTableview reloadData];
    
    [theTruck saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        truckObject.truckId = theTruck.objectId;
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:trucks];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:ARCHIVE_TRUCKS_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
    

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

/*
 
 
 ACAccount *twitterAccount = [[TruckSingleton singleton] twitterAccount];
 NSString *userId = [[twitterAccount valueForKey:@"properties"] valueForKey:@"user_id"];
 
 PFQuery *query = [PFQuery queryWithClassName:@"Trucks"];
 [query whereKey:@"truckTwitterId" equalTo:@([userId integerValue])];
 [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
 if (!error) {
 trucks = [objects mutableCopy];
 NSLog(@"Successfully retrieved %lu trucks.", (unsigned long)objects.count);
 [self.theTableview reloadData];
 } else {
 // Log details of the failure
 NSLog(@"Error: %@ %@", error, [error userInfo]);
 }
 }];
 
 */

@end
