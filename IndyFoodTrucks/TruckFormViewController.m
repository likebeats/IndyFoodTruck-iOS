//
//  TruckFormViewController.m
//  IndyFoodTrucks
//
//  Created by Manny on 4/4/14.
//  Copyright (c) 2014 AppDar. All rights reserved.
//

#import "TruckFormViewController.h"
#import "TruckForm.h"

@interface TruckFormViewController () <FXFormControllerDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) FXFormController *formController;

@end

@implementation TruckFormViewController

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
    
    self.formController = [[FXFormController alloc] init];
    self.formController.tableView = self.tableView;
    self.formController.delegate = self;
    
    if (self.editTruckForm) {
        self.title = @"Edit Truck";
        self.formController.form = self.editTruckForm;
    } else {
        self.title = @"Add Truck";
        self.formController.form = [[TruckForm alloc] init];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.editTruckForm) {
        UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", nil)
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(onSaveBtnClicked:)];
        
        self.navigationItem.rightBarButtonItem = saveBtn;
    } else {
        UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Add", nil)
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(onAddBtnClicked:)];
        self.navigationItem.rightBarButtonItem = addBtn;
    }
    
    [self.tableView reloadData];
}

- (void)onSaveBtnClicked:(id)sender
{
    TruckForm *truckForm = self.formController.form;
    NSLog(@"SAVE TRUCK BTN CLICKED %@", truckForm.truckName);
}

- (void)onAddBtnClicked:(id)sender
{
    TruckForm *truckForm = self.formController.form;
    NSLog(@"ADD TRUCK BTN CLICKED %@", truckForm.truckName);
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
