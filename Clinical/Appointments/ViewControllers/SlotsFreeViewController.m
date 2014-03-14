//
//  SlotsFreeViewController.m
//  Appointments1
//
//  Created by brian macbride on 07/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SlotsFreeViewController.h"
#import "SlotsFreeDataController.h"
#import "SlotFreeData.h"
#import "RequestDataAccess.h"

@interface SlotsFreeViewController ()
@property (nonatomic, copy) NSString* slotBooked;
@property (nonatomic) NSInteger requestCount;
@property (nonatomic) BOOL isError;
@end

@implementation SlotsFreeViewController

@synthesize slotsFreeDataController;
@synthesize activityIndicator;
@synthesize slotsFreeDelegate;
@synthesize slotBooked;
@synthesize requestCount = _requestCount;
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
    
    [_hub on:@"getResponse" perform:self selector:@selector(getResponse:)];
    
    self.appointment.PracticePatientId = self.authResponse.Patient.PracticePatientId;
    
    NSString *appRequest = [NSString stringWithFormat:@"{Ticket: '%@' , Data : %@}", self.authResponse.Ticket, [self.appointment toJsonString]];
    
    [_hub invoke:@"getClinicalAppointments" withArgs:@[appRequest]];

    SlotsFreeDataController * aDataController = [[SlotsFreeDataController alloc] init];
    self.slotsFreeDataController = aDataController;
    [self.slotsFreeDataController addSlot:@"Searching for slots..." toSession:@""];
    
    [self showToolbar];
    [self setSearching:YES hasBookings:NO isError:NO];
    [self.activityIndicator setHidesWhenStopped:YES];
}

- (void)viewDidUnload
{
    self.slotsFreeDataController = nil;
    
    [self setActivityIndicator:nil];
    [super viewDidUnload];
}

- (void)viewDidDisappear:(BOOL)animated
{
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void) setSearching:(BOOL)searching hasBookings:(BOOL)bookings isError:(BOOL)error
{
    self.isError = error;
    if (searching)
    {
        [self.activityIndicator startAnimating];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.navigationItem.hidesBackButton = YES;
        self.tableView.allowsSelection = NO;
        self.tableView.rowHeight = 44;
    }
    else if (error) {
        [self.activityIndicator stopAnimating];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.navigationItem.hidesBackButton = NO;
        self.tableView.allowsSelection = NO;
        self.tableView.rowHeight = 120;
    }
    else {
        [self.activityIndicator stopAnimating];
        self.navigationItem.hidesBackButton = NO;
        self.tableView.allowsSelection = YES;
        self.tableView.rowHeight = 44;
        if (bookings) {
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        }
        else {
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        }
    }
}    

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return (NSInteger)[self.slotsFreeDataController.slotsFreeArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SlotFreeData * slotFreeData = [self.slotsFreeDataController.slotsFreeArray objectAtIndex:(NSUInteger)section];

    return (NSInteger)[slotFreeData.slotsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* CellIdentifier;
    if (self.isError) {
        CellIdentifier = @"errorCell";
    }
    else {
        CellIdentifier = @"slotsFreeCell";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    SlotFreeData * slotFreeData = [self.slotsFreeDataController.slotsFreeArray objectAtIndex:(NSUInteger)indexPath.section];
    NSString * strStaff = [slotFreeData.slotsArray objectAtIndex:(NSUInteger)indexPath.row];

    UILabel *label = [cell textLabel];
    label.text = strStaff;
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont fontWithName:@"System" size:17];
    
    return cell;    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    SlotFreeData * slotFreeData = [self.slotsFreeDataController.slotsFreeArray objectAtIndex:(NSUInteger)section];
    return slotFreeData.session;
}

#pragma mark - select row

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SlotFreeData * slotFreeData = [self.slotsFreeDataController.slotsFreeArray objectAtIndex:(NSUInteger)indexPath.section];
    self.appointment.EventTime = [slotFreeData.slotsArray objectAtIndex:indexPath.row];
    self.appointment.Session = slotFreeData.session;
    
    self.slotBooked = [[NSString alloc] initWithFormat:@"%@ %@", self.appointment.EventDate, self.appointment.EventTime];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSDate *slotDate = [dateFormatter dateFromString:self.appointment.EventDate];
    [dateFormatter setDateFormat:@"EEE dd MMM yyyy"];
    NSString *strDate = [dateFormatter stringFromDate:slotDate];

    NSString *strConfirm;
    if ([self.appointment.Location isEqualToString:@"Unspecified"]){
        strConfirm = [[NSString alloc] initWithFormat:@"Please confirm %@ booking with %@ on %@ at %@", self.appointment.Session , self.appointment.StaffId, strDate,
                      self.appointment.EventTime];
    }
    else {
        strConfirm = [[NSString alloc] initWithFormat:@"Please confirm %@ booking at %@ with %@ on %@ at %@", self.appointment.Session, self.appointment.Location, self.appointment.StaffId, strDate, self.appointment.EventTime];
    }

    UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:strConfirm delegate:self cancelButtonTitle:@"Cancel" 
                          destructiveButtonTitle:nil otherButtonTitles:@"Confirm", nil];
    
    [sheet showFromToolbar:self.navigationController.toolbar];
}

#pragma mark - perform segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"confirmBookingSegue"]) {
        ConfirmBookingViewController *confirmBookingViewController = [segue destinationViewController];
        confirmBookingViewController.appointment = self.appointment;
        confirmBookingViewController.confirmBookingDelegate = self;
        confirmBookingViewController.authResponse = self.authResponse;
        confirmBookingViewController.connection = self.connection;
        confirmBookingViewController.hub = self.hub;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ((buttonIndex == 0) && (![self.slotBooked isEqual: @""])) {
        [self performSegueWithIdentifier:@"confirmBookingSegue" sender:self];
    }
    else {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)confirmBookingViewControllerDidFinish:(ConfirmBookingViewController *)controller;
{
    [[self slotsFreeDelegate] slotsFreeViewControllerDidFinish:self slot:self.appointment];
    [[self navigationController] popToRootViewControllerAnimated:YES];
}

-(void)bookingsReturnHome:(UIViewController *)controller {
    [self.slotsFreeDelegate bookingsReturnHome:self];
}

#pragma mark - signalR responses

- (void) getResponse:(NSString *) jsonData
{
    AppResponse *appResponse = [AppResponse convertFromJson:jsonData];
    
    if([appResponse.CallbackMethod  isEqual: @"GetClinicalAppointments"])
    {
        [self processResponse:appResponse];
    }
}

-(void)processResponse:(AppResponse*)appResponse
{
    if (appResponse.IsError) {
        [self getRequestError:appResponse.Error];
    }
    else
    {
        NSMutableArray * appointments = [Appointment convertFromJsonList:appResponse.JData];
        
        if([appointments count] == 0)
        {
            [self.slotsFreeDataController addSlot:@"No slots available" toSession:@""];
            [self setSearching:NO hasBookings:NO isError:NO];
        }
        else
        {
            for (Appointment* app in appointments)
            {
                [self.slotsFreeDataController addSlot:app.EventTime toSession:app.Session];
            }
            [self setSearching:NO hasBookings:YES isError:NO];
        }
        
        [self.tableView reloadData];
    }
}

-(void)getRequestError:(NSString *)strError {
    [self.slotsFreeDataController clearSlots];
    [self.slotsFreeDataController addSlot:strError toSession:@"Request failed"];
    
    [self setSearching:NO hasBookings:NO isError:YES];
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
    [self.slotsFreeDelegate bookingsReturnHome:self];
}

@end
