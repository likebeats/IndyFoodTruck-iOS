//
//  TruckSelectionViewController.m
//  IndyFoodTrucks
//
//  Created by Manny on 4/4/14.
//  Copyright (c) 2014 AppDar. All rights reserved.
//

#import "TrucksViewController.h"


@interface TrucksViewController (){
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
    
    self.title = @"Trucks";
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Add", nil)
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:@selector(onAddBtnClicked:)];
    self.navigationItem.rightBarButtonItem = addBtn;
    
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
    
    PFObject *truck = trucks[indexPath.row];

    static NSString *CellIdentifier = @"TruckCell";
    UITableViewCell *cell = [self.theTableview dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.textLabel.text = truck[@"truckName"];
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
//    // Navigation logic may go here, for example:
//    // Create the next view controller.
//    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
//    
//    // Pass the selected object to the new view controller.
//    
//    // Push the view controller.
//    [self.navigationController pushViewController:detailViewController animated:YES];
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
