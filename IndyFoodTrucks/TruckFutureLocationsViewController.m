//
//  TruckFutureLocationsViewController.m
//  IndyFoodTrucks
//
//  Created by Manny on 4/5/14.
//  Copyright (c) 2014 AppDar. All rights reserved.
//

#import "TruckFutureLocationsViewController.h"
#import "LocationMapCell.h"
#import "UIImageView+AFNetworking.h"

@interface TruckFutureLocationsViewController ()
{
    NSMutableArray *futureLocations;
}

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end

@implementation TruckFutureLocationsViewController

@synthesize locations, currentLocationObject;

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
    
    futureLocations = [NSMutableArray arrayWithArray:locations];
    [futureLocations removeObjectAtIndex:[locations indexOfObject:currentLocationObject]];
}

#pragma mark -
#pragma mark Datasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return futureLocations.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)index
{
    PFObject *object = [futureLocations objectAtIndex:index];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMM d h:mm a"];
    
    NSDate *currentFromTime = [object objectForKey:@"fromTime"];
    NSDate *currentToTime = [object objectForKey:@"toTime"];
    
    return [NSString stringWithFormat:@"%@ to %@", [dateFormat stringFromDate:currentFromTime], [dateFormat stringFromDate:currentToTime]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)index
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LocationMapCell";
    LocationMapCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [self.tableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellReuseIdentifier:CellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.mapCaptionLabel.text = @"";
    cell.mapCaptionBgView.hidden = YES;
    
    PFObject *object = [futureLocations objectAtIndex:indexPath.section];
    PFGeoPoint *geoPoint = [object objectForKey:@"truckLocation"];
    
    NSString *string = @"%7C";
    NSString *mapURL = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/staticmap?center=%f,%f&zoom=14&size=320x150&maptype=roadmap&markers=color:green%@%f,%f&sensor=false", geoPoint.latitude, geoPoint.longitude, string, geoPoint.latitude, geoPoint.longitude];
    [cell.mapImageView setImageWithURL:[NSURL URLWithString:mapURL]
                      placeholderImage:nil];
    
    return cell;
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
