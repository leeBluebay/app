//
//  StaffFreeViewController.m
//  Appointments1
//
//  Created by brian macbride on 07/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StaffFreeViewController.h"
#import "StaffFreeDataController.h"
#import "DatesFreeViewController.h"
#import "AppointmentData.h"

@interface StaffFreeViewController () <DatesFreeViewControllerDelegate>
@property (nonatomic) BOOL isError;
@end

@implementation StaffFreeViewController

@synthesize staffFreeDataController;
@synthesize staffFreeDelegate;
@synthesize activityIndicator;

@synthesize isError = _isError;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.isError = NO;
    
    [self.activityIndicator startAnimating];
    [self.activityIndicator setHidesWhenStopped:YES];

    StaffFreeDataController * aDataController = [[StaffFreeDataController alloc] init];
    self.staffFreeDataController = aDataController;
    self.staffFreeDataController.staffFreeDataDelegate = self;
    
    [_hub on:@"getResponse" perform:self selector:@selector(getResponse:)];
    
    self.appointment.PracticePatientId = self.authResponse.Patient.PracticePatientId;
    
    NSString *appRequest = [NSString stringWithFormat:@"{Ticket: '%@' , Data : %@}", self.authResponse.Ticket, [self.appointment toJsonString]];
    
    
    [_hub invoke:@"getAppointmentStaff" withArgs:@[appRequest]];
    
    [self showToolbar];
}

- (void)viewDidUnload
{
    [self setStaffFreeDataController:nil];
    [self setToolbarItems:nil];

    [self setActivityIndicator:nil];

    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (NSInteger)[self.staffFreeDataController.staffFreeArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* CellIdentifier;
    if (self.isError) {
        CellIdentifier = @"errorCell";
    }
    else {
        CellIdentifier = @"staffFreeCell";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSString * strStaff = [self.staffFreeDataController.staffFreeArray objectAtIndex:(NSUInteger)indexPath.row];
    [[cell textLabel] setText:strStaff];
    
    return cell;    
}

#pragma mark - DatesFree / SlotsFree view delegate

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath* indexPath = [[self tableView] indexPathForSelectedRow];
    NSString * strStaff = [self.staffFreeDataController.staffFreeArray objectAtIndex:(NSUInteger)indexPath.row];
    self.appointment.StaffId = strStaff;
    
    if ([[segue identifier] isEqualToString:@"clinicianSlotsSegue"]) {
        SlotsFreeViewController * slotsFreeViewController = [segue destinationViewController];
        slotsFreeViewController.slotsFreeDelegate = self;
        slotsFreeViewController.appointment = self.appointment;
        slotsFreeViewController.connection = self.connection;
        slotsFreeViewController.hub = self.hub;
        slotsFreeViewController.authResponse = self.authResponse;
    }
    else if ([[segue identifier] isEqualToString:@"clinicianDatesSegue"]) {
        DatesFreeViewController * datesFreeViewController = [segue destinationViewController];
        datesFreeViewController.datesFreeDelegate = self;
        datesFreeViewController.appointment = self.appointment;
        datesFreeViewController.connection = self.connection;
        datesFreeViewController.hub = self.hub;
        datesFreeViewController.authResponse = self.authResponse;
    }
}

- (void)slotsFreeViewControllerDidFinish:(UIViewController *)controller slot:(AppointmentData *)appData;
{
    [[self staffFreeDelegate] slotsFreeViewControllerDidFinish:self slot:appData];
}

-(void)bookingsReturnHome:(UIViewController *)controller {
    [self.staffFreeDelegate bookingsReturnHome:self];
}

#pragma mark - DatesFreeData delegate

- (void)staffFreeDataControllerDidFinish;
{
    [self.activityIndicator stopAnimating];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.rowHeight = 44;
    
    [self.tableView reloadData];    
}

- (void)staffFreeDataControllerHadError;
{
    [self.activityIndicator stopAnimating];
    
    self.isError = YES;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 120;
    
    [self.tableView reloadData];    
}

#pragma mark - show toolbar

- (void) showToolbar {
    UIImage *buttonImage = [UIImage imageNamed:kHomeImage];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton addTarget:self action:@selector(returnHome) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setImage:buttonImage forState:UIControlStateNormal];
    leftButton.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    UIBarButtonItem *spaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    NSMutableArray * arr = [NSMutableArray arrayWithObjects:leftBarButtonItem, spaceBarButtonItem, nil];
    [self setToolbarItems:arr animated:YES];
}

- (void)returnHome
{
    [self.staffFreeDelegate bookingsReturnHome:self];
}


#pragma mark - signalR responses

- (void) getResponse:(NSString *) jsonData
{
    
    AppResponse *appResponse = [AppResponse convertFromJson:jsonData];
    
    if([appResponse.CallbackMethod  isEqual: @"GetAppointmentStaff"])
    {
        [self processResponse:appResponse];
    }
}

-(void)processResponse:(AppResponse*)appResponse
{
    if (appResponse.IsError) {
        [self.staffFreeDataController addStaff:appResponse.Error];
        [self.staffFreeDataController.staffFreeDataDelegate staffFreeDataControllerHadError];
    }
    else
    {
        NSMutableArray * appointments = [Appointment convertFromAppResponse:appResponse];
        
        if([appointments count] == 0)
        {
            [self.staffFreeDataController addStaff:@"No clinicians found"];
        }
        else
        {
            for (Appointment* app in appointments)
            {
                [self.staffFreeDataController addStaff:app.StaffId];
            }
        }
        
        [self.tableView reloadData];
        
        [self.staffFreeDataController.staffFreeDataDelegate staffFreeDataControllerDidFinish];
    }
}

@end
