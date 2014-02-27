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
@property (nonatomic, strong) RequestDataAccess* requestDataAccess;
@property (nonatomic, strong) RequestData *requestData;
@property (nonatomic) NSInteger requestCount;
@property (nonatomic) BOOL isError;
@end

@implementation SlotsFreeViewController

@synthesize urlStr = _urlStr;
@synthesize slotsFreeDataController;
@synthesize activityIndicator;
@synthesize slotsFreeDelegate;
@synthesize slotBooked;
@synthesize appointmentData = _appointmentData;
@synthesize requestDataAccess;
@synthesize requestData = _requestData;
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
    
    RequestDataAccess* reqDataAccess = [[RequestDataAccess alloc] init];
    self.requestDataAccess = reqDataAccess;
    self.requestDataAccess.requestDataDelegate = self;
    self.requestDataAccess.urlStr = self.urlStr;
    
    self.requestData = [[RequestData alloc] initWithPractice:self.appointmentData.practiceCode forPatient:self.appointmentData.patientID withRequest:@"1"];

    SlotsFreeDataController * aDataController = [[SlotsFreeDataController alloc] init];
    self.slotsFreeDataController = aDataController;
    [self.slotsFreeDataController addSlot:@"Searching for slots..." toSession:@""];
    
    [self showToolbar];
    [self setSearching:YES hasBookings:NO isError:NO];
    [self.activityIndicator setHidesWhenStopped:YES];
    
    [self setSlotsRequest];
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
    self.appointmentData.slot = [slotFreeData.slotsArray objectAtIndex:indexPath.row];
    self.appointmentData.session = slotFreeData.session;
    
    self.slotBooked = [[NSString alloc] initWithFormat:@"%@ %@", self.appointmentData.appointmentDate, self.appointmentData.slot];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSDate *slotDate = [dateFormatter dateFromString:self.appointmentData.appointmentDate];
    [dateFormatter setDateFormat:@"EEE dd MMM yyyy"];
    NSString *strDate = [dateFormatter stringFromDate:slotDate];

    NSString *strConfirm;
    if ([self.appointmentData.premise isEqualToString:@"Unspecified"]){
        strConfirm = [[NSString alloc] initWithFormat:@"Please confirm %@ booking with %@ on %@ at %@", self.appointmentData.session, self.appointmentData.staff, strDate, self.appointmentData.slot];
    }
    else {
        strConfirm = [[NSString alloc] initWithFormat:@"Please confirm %@ booking at %@ with %@ on %@ at %@", self.appointmentData.session, self.appointmentData.premise, self.appointmentData.staff, strDate, self.appointmentData.slot];
    }

    UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:strConfirm delegate:self cancelButtonTitle:@"Cancel" 
                          destructiveButtonTitle:nil otherButtonTitles:@"Confirm", nil];
    
    [sheet showFromToolbar:self.navigationController.toolbar];
}

#pragma mark - perform segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"confirmBookingSegue"]) {
        ConfirmBookingViewController *confirmBookingViewController = [segue destinationViewController];
        confirmBookingViewController.appointmentData = self.appointmentData;
        confirmBookingViewController.confirmBookingDelegate = self;
        confirmBookingViewController.urlStr = self.urlStr;
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
    [[self slotsFreeDelegate] slotsFreeViewControllerDidFinish:self slot:self.appointmentData];
    [[self navigationController] popToRootViewControllerAnimated:YES];
}

-(void)bookingsReturnHome:(UIViewController *)controller {
    [self.slotsFreeDelegate bookingsReturnHome:self];
}

#pragma mark - request data

-(void) setSlotsRequest {
    self.requestData.eventData = [self.requestDataAccess getAppointmentEventData:self.appointmentData];
    [self.requestDataAccess setRequest:self.requestData];
}

- (void)getRequest {
    [self.requestDataAccess getRequest:self.requestData];
}    

#pragma mark - request data delegate

-(void)didSetRequest {
    self.requestCount = 1;
    [self performSelector:@selector(getRequest) withObject:nil afterDelay:1];    
}

-(void)setRequestError:(NSString *)strError {
    [self performSelector:@selector(getRequestError:) withObject:strError afterDelay:1.0];    
}

-(void)didGetRequest:(NSData *)responseData {
    NSError* error;
    NSDictionary* requestData = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    NSString* strEventData = [requestData objectForKey:@"EventData"];
    
    if ([strEventData isEqualToString:@"false"]) {
        if (self.requestCount < 20) {
            self.requestCount++;
            [self performSelector:@selector(getRequest) withObject:nil afterDelay:1];    
        }
        else {
            [self getRequestError:@"The request has timed out"];
        }
    }
    else {
        NSData* jsonEventData = [strEventData dataUsingEncoding:NSUTF8StringEncoding];
        [self didGetSlotRequest:jsonEventData];
    }
}

-(void)getRequestError:(NSString *)strError {
    [self.slotsFreeDataController clearSlots];
    [self.slotsFreeDataController addSlot:strError toSession:@"Request failed"];
    
    [self setSearching:NO hasBookings:NO isError:YES];
    [self.requestDataAccess delRequest:self.requestData];
    [self.tableView reloadData];
}

-(void)didGetSlotRequest:(NSData *)jsonEventData {
    NSError* error;
    NSArray* eventData = [NSJSONSerialization JSONObjectWithData:jsonEventData options:kNilOptions error:&error];
    
    [self.slotsFreeDataController clearSlots];
    if ([eventData count] == 0) {
        self.isError = YES;
        [self.slotsFreeDataController addSlot:@"No slots available" toSession:@""];
        [self setSearching:NO hasBookings:NO isError:NO];
    }
    else {
        for (NSDictionary* timeSlot in eventData) {
            NSString* session = [timeSlot objectForKey:@"ses"];
            NSString* slot = [timeSlot objectForKey:@"slt"];
            [self.slotsFreeDataController addSlot:slot toSession:session];
        }
        [self setSearching:NO hasBookings:YES isError:NO];
    }
    
    [self.requestDataAccess delRequest:self.requestData];
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
