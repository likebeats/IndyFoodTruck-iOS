//
//  YelpTruckViewController.m
//  IndyFoodTrucks
//
//  Created by sj singh on 4/5/14.
//  Copyright (c) 2014 AppDar. All rights reserved.
//

#import "YelpTruckViewController.h"
#import "YLLocalSearch.h"
#import "YLBusiness.h"

@interface YelpTruckViewController (){
    NSMutableArray *trucks;
}

@end

@implementation YelpTruckViewController

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
    
    YLLocalSearch *search = [[YLLocalSearch alloc] init];
    
    [search localSearchWithTerm:@"Food Trucks"
                            offset:@0
                        success:^(NSMutableArray *results) {
                            NSLog(@"%@",results);
                            trucks = results ;
                            [self.theTableview reloadData];
                        }
                        failure:^(NSError *error) {
                            NSLog(@"%@",error);
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
    
    YLBusiness *truck = (YLBusiness*)trucks[indexPath.row];
    
    static NSString *CellIdentifier = @"TruckCell";
    UITableViewCell *cell = [self.theTableview dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.textLabel.text = truck.name;
    __block NSString *categoryString = [NSString new];
    
    [truck.categories enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx != 0)
            categoryString = [categoryString stringByAppendingString:@", "];
        categoryString = [categoryString stringByAppendingString:obj[0]];
        

    }];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", categoryString];
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

@end
