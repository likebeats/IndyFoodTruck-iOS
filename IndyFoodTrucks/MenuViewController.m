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


NSString * const MSMenuCellReuseIdentifier = @"Drawer Cell";
NSString * const MSDrawerHeaderReuseIdentifier = @"Drawer Header";

@interface MenuViewController ()

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
    
    [self.tableView registerClass:[MSMenuCell class] forCellReuseIdentifier:MSMenuCellReuseIdentifier];
    [self.tableView registerClass:[MSMenuTableViewHeader class] forHeaderFooterViewReuseIdentifier:MSDrawerHeaderReuseIdentifier];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
        cell.textLabel.text = @"Date";
        
    } else if (indexPath.section == 1) {
        cell.textLabel.text = @"Anytime";
        
    } else if (indexPath.section == 2) {
        cell.textLabel.text = @"View Fav Trucks";
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
