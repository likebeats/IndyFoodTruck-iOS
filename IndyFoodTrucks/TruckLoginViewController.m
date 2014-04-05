//
//  TruckLoginViewController.m
//  IndyFoodTrucks
//
//  Created by sj singh on 4/4/14.
//  Copyright (c) 2014 AppDar. All rights reserved.
//

#import "TruckLoginViewController.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import <Twitter/Twitter.h>
#import "CCActionSheet.h"
#import <Parse/Parse.h>
#import "TrucksViewController.h"

@interface TruckLoginViewController () {
    ACAccount *twitterAccount;
    ACAccountStore *accountStore;
    NSDictionary *userInfo;
}

@end

@implementation TruckLoginViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)twitter:(UIButton *)sender {

    accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
        if(granted) {
            NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
            
            if ([accountsArray count] > 0) {
                if (accountsArray.count > 1) {
                    CCActionSheet *sheet = [[CCActionSheet alloc] initWithTitle:NSLocalizedString(@"Select Twitter Account", nil)];
                    [accountsArray enumerateObjectsUsingBlock:^(ACAccount *ta, NSUInteger idx, BOOL *stop) {
                        [sheet addButtonWithTitle:ta.username block:^{
                            twitterAccount = ta;
                            [self fetchTwitterAccountInfo];
                        }];
                    }];
                    
                    [sheet addCancelButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [sheet showInView:self.view];
                    });
                } else {
                    twitterAccount = [accountsArray firstObject];
                    [self fetchTwitterAccountInfo];
                }
            }else{
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [[[UIAlertView alloc] initWithTitle:@"No Twitter Account Found" message:@"No twitter account found on your device. Please go to Twitter under iOS settings app and add an account." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                });
            }
        }else{
            dispatch_sync(dispatch_get_main_queue(), ^{
                [[[UIAlertView alloc] initWithTitle:@"Permission Required" message:@"We needs your permission to your twitter account so you can add trucks and update location. Please enable location is iOS Settings app" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];

            });
            
        }
    }];
}

-(void)fetchTwitterAccountInfo {
    
    ACAccountType *twitterAccountType =
    [accountStore accountTypeWithAccountTypeIdentifier:
     ACAccountTypeIdentifierTwitter];
    
    [accountStore
     requestAccessToAccountsWithType:twitterAccountType
     options:NULL
     completion:^(BOOL granted, NSError *error) {
         if (granted) {

    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1/users/lookup.json"];
    NSString *userId = [[twitterAccount valueForKey:@"properties"] valueForKey:@"user_id"];
    NSDictionary *params = @{@"user_id" : userId};
    SLRequest *request =
    [SLRequest requestForServiceType:SLServiceTypeTwitter
                       requestMethod:SLRequestMethodGET
                                 URL:url
                          parameters:params];
    
    //  Attach an account to the request
    [request setAccount:twitterAccount];
    
    //  Step 3:  Execute the request
    [request performRequestWithHandler:
     ^(NSData *responseData,
       NSHTTPURLResponse *urlResponse,
       NSError *error) {
         
         if (responseData) {
             if (urlResponse.statusCode >= 200 &&
                 urlResponse.statusCode < 300) {
                 
                 NSError *jsonError;
                 NSDictionary *timelineData =
                 [NSJSONSerialization
                  JSONObjectWithData:responseData
                  options:NSJSONReadingAllowFragments error:&jsonError];
                 if (timelineData) {
                     userInfo = timelineData;
                     
                     dispatch_sync(dispatch_get_main_queue(), ^{
                         [self fetchTrucks];
                     });
                     
                     NSLog(@"Timeline Response: %@\n", timelineData);
                 }
                 else {
                     // Our JSON deserialization went awry
                     dispatch_sync(dispatch_get_main_queue(), ^{
                     [[[UIAlertView alloc] initWithTitle:@"Twitter Login Failed" message:@"Twitter login failed. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                     });
                     NSLog(@"JSON Error: %@", [jsonError localizedDescription]);
                 }
             }
             else {
                 // The server did not respond ... were we rate-limited?
                 NSLog(@"The response status code is %ld",
                       (long)urlResponse.statusCode);
                 dispatch_sync(dispatch_get_main_queue(), ^{
                 [[[UIAlertView alloc] initWithTitle:@"Twitter Login Failed" message:@"Twitter login failed. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                 });
             }
         }
     }];
         }
     }];
}

-(void) fetchTrucks  {
    [TruckSingleton singleton].twitterAccount = twitterAccount;
    [TruckSingleton singleton].twitterUserInfo = userInfo;
    
    //Load Trucks Controller
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone"bundle:nil];
    TrucksViewController *trucksViewController = [storyboard instantiateViewControllerWithIdentifier:@"TrucksViewController"];
    [self.navigationController pushViewController:trucksViewController animated:YES];
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
