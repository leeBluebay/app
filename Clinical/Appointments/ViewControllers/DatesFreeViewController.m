//
//  DatesFreeViewController.m
//  Appointments1
//
//  Created by brian macbride on 07/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DatesFreeViewController.h"

@interface DatesFreeViewController ()
@property (nonatomic) BOOL isError;
@end

@implementation DatesFreeViewController

@synthesize datesFreeDataController = _datesFreeDataController;
@synthesize datesFreeDelegate = _datesFreeDelegate;
@synthesize activityIndicator = _activityIndicator;

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
    
    DatesFreeDataController * aDataController = [[DatesFreeDataController alloc] init];
    self.datesFreeDataController = aDataController;
    self.datesFreeDataController.datesFreeDataDelegate = self;
    
    [_hub on:@"getResponse" perform:self selector:@selector(getResponse:)];
    
    self.appointment.PracticePatientId = self.authResponse.Patient.PracticePatientId;
    
    NSString *appRequest = [NSString stringWithFormat:@"{Ticket: '%@' , Data : %@}", self.authResponse.Ticket, [self.appointment toJsonString]];
    
    [_hub invoke:@"getAppointmentDates" withArgs:@[appRequest]];
    
    [self showToolbar];
}

- (void)viewDidUnload
{
    [self setDatesFreeDataController:nil];
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
    return (NSInteger)[self.datesFreeDataController.datesFreeArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    if (self.isError) {
        CellIdentifier = @"errorCell";
    }
    else {
        CellIdentifier = @"datesFreeCell";
    }

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSUInteger row = (NSUInteger)indexPath.row;
    
    if (self.isError) 
    {
        [[cell textLabel] setText:[self.datesFreeDataController.datesFreeArray objectAtIndex:row]];
    }
    else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        NSDate *slotDate = [dateFormatter dateFromString:[self.datesFreeDataController.datesFreeArray objectAtIndex:row]];
        
        [dateFormatter setDateFormat:@"EEE dd MMM yyyy"];
        NSString *strDate = [dateFormatter stringFromDate:slotDate];
        [[cell textLabel] setText:strDate];
    }

    return cell;    
}

#pragma mark - StaffFree / SlotsFree view delegate

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [[self tableView] indexPathForSelectedRow];
    NSString *strDate = [self.datesFreeDataController.datesFreeArray objectAtIndex:(NSUInteger)indexPath.row];
    self.appointment.EventDate = strDate;
    
    if ([[segue identifier] isEqualToString:@"datesClinicianSegue"]) {
        StaffFreeViewController *staffFreeViewController = [segue destinationViewController];
        staffFreeViewController.connection = self.connection;
        staffFreeViewController.hub = self.hub;
        staffFreeViewController.staffFreeDelegate = self;
        staffFreeViewController.authResponse = self.authResponse;
        staffFreeViewController.appointment = self.appointment;
    }
    else if ([[segue identifier] isEqualToString:@"datesSlotsSegue"]) {
        SlotsFreeViewController *slotsFreeViewController = [segue destinationViewController];
        slotsFreeViewController.slotsFreeDelegate = self;
        slotsFreeViewController.appointment = self.appointment;
        slotsFreeViewController.authResponse = self.authResponse;
        slotsFreeViewController.connection = self.connection;
        slotsFreeViewController.hub = self.hub;
    }
}

- (void)slotsFreeViewControllerDidFinish:(UIViewController *)controller slot:(AppointmentData *)appData;
{
    [[self datesFreeDelegate] slotsFreeViewControllerDidFinish:self slot:appData];
}

-(void)bookingsReturnHome:(UIViewController *)controller {
    [self.datesFreeDelegate bookingsReturnHome:self];
}

#pragma mark - DatesFreeData delegate

- (void)datesFreeDataControllerDidFinish;
{
    [self.activityIndicator stopAnimating];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.rowHeight = 44;
    [self.tableView reloadData];    
}

- (void)datesFreeDataControllerHadError;
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
    [self.datesFreeDelegate bookingsReturnHome:self];
}

#pragma mark - signalR responses

- (void) getResponse:(NSString *) jsonData
{
    
    AppResponse *appResponse = [AppResponse convertFromJson:jsonData];
    
    if([appResponse.CallbackMethod  isEqual: @"GetAppointmentDates"])
    {
        [self processResponse:appResponse];
    }
}

-(void) processResponse:(AppResponse *) appResponse
{
    if(appResponse.IsError)
    {
        [self.datesFreeDataController addDate:appResponse.Error];
        [self.datesFreeDataController.datesFreeDataDelegate datesFreeDataControllerHadError];
    }
    else
    {
        NSMutableArray * appointments = [Appointment convertFromAppResponse:appResponse];
        
        if([appointments count] == 0)
        {
            [self.datesFreeDataController addDate:@"No dates found"];
        }
        else
        {
            for (Appointment* app in appointments)
            {
                [self.datesFreeDataController addDate:app.EventDate];
            }
        }
        
        [self.datesFreeDataController.datesFreeDataDelegate datesFreeDataControllerDidFinish];
        [self.tableView reloadData];
        [self.activityIndicator stopAnimating];
    }
}

@end
