//
//  BookingsViewController.m
//  Appointments1
//
//  Created by brian macbride on 08/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BookingsViewController.h"
#import "SignalR.h"
#import "Appointment.h"

@interface BookingsViewController ()
@property (nonatomic, strong) UIBarButtonItem *addButton;
@property (nonatomic, strong) PremisesDataController * premisesDataController;
@property (nonatomic, strong) NSIndexPath *rowIndex;
@property (nonatomic) BOOL isError;
@property (nonatomic) BOOL hasBookings;
@property (nonatomic) BOOL isSearching;
@property (nonatomic) NSInteger requestCount;
@property (nonatomic, strong) NSMutableArray *patientBookings;
@end

@implementation BookingsViewController

@synthesize urlStr = _urlStr;
@synthesize bookingsDelegate = _bookingsDelegate;
@synthesize bookings = _bookings;
@synthesize bookingsDataController = _bookingsDataController;
@synthesize activityIndicator = _activityIndicator;
@synthesize rowIndex = _rowIndex;

@synthesize addButton = _addButton;
@synthesize premisesDataController = _premisesDataController;
@synthesize isError = _isError;
@synthesize hasBookings = _hasBookings;
@synthesize isSearching = _isSearching;
@synthesize requestCount = _requestCount;

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add:)];
    
    [self showToolbar];
    
    [self.activityIndicator setHidesWhenStopped:YES];
    
    self.premisesDataController = [[PremisesDataController alloc] init];
    self.premisesDataController.premisesDataDelegate = self;
    self.premisesDataController.urlStr = self.urlStr;
    
    if (![self hasBookings])
    {
        self.bookingsDataController = [[BookingsDataController alloc] init];
        
        [self getPatientBookings];
    }
    else {
        [self.premisesDataController getPremises:self.appointment];
        [self setSearching:NO hasBookings:self.hasBookings isError:self.isError];
    }
    
    [_hub on:@"getResponse" perform:self selector:@selector(getResponse:)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    [self setPremisesDataController:nil];
    [self setRowIndex:nil];
    [self setToolbarItems:nil];
    [self setAddButton:nil];

    self.navigationItem.rightBarButtonItem = nil;

    [self setActivityIndicator:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void) setSearching:(BOOL)searching hasBookings:(BOOL)bookings isError:(BOOL)error
{
    self.isSearching = searching;
    self.hasBookings = bookings;
    self.isError = error;
    
    if (searching)
    {
        [self.activityIndicator startAnimating];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.rowHeight = 60;
        self.navigationItem.rightBarButtonItem = nil;
        self.tableView.allowsSelection = NO;
    }
    else if (error) {
        [self.activityIndicator stopAnimating];
        self.tableView.rowHeight = 120;
        self.navigationItem.rightBarButtonItem = nil;
        self.tableView.allowsSelection = NO;
        [self.tableView reloadData];
    }
    else {
        [self.activityIndicator stopAnimating];
        
        NSInteger bookingCount = [self.bookingsDataController bookingsCount];
        
        if (bookingCount < _authResponse.Patient.NumberOfBookings) {
            self.navigationItem.rightBarButtonItem = self.addButton;
        }
        else {
            self.navigationItem.rightBarButtonItem = nil;
        }
        
        if (bookings) 
        {
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            self.tableView.rowHeight = 120;
            self.tableView.allowsSelection = YES;
        }
        else {
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            self.tableView.rowHeight = 60;
            self.tableView.allowsSelection = NO;
            [self.bookingsDataController clearInfo];
            [self.bookingsDataController addInfo:@"No current bookings"];
        }
        [self.tableView reloadData];
    }
}

#pragma mark - Hub methods

- (void) getPatientBookings
{
    [self.activityIndicator startAnimating];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 60;
    self.navigationItem.rightBarButtonItem = nil;
    self.tableView.allowsSelection = NO;
    
    NSString *request = [NSString stringWithFormat:@"{Ticket: '%@', Data: { PracticePatientId : %@}}", self.authResponse.Ticket, self.authResponse.Patient.PracticePatientId];
    
    [_hub invoke:@"GetClinicalBookings" withArgs:@[request]];
}

- (BOOL) hasBookings
{
    return !(_patientBookings == nil || [_patientBookings count] == 0);
}

#pragma mark - signalR responses

- (void) getResponse:(NSString *) jsonData
{
    
    AppResponse *appResponse = [AppResponse convertFromJson:jsonData];
    
    if([appResponse.CallbackMethod  isEqual: @"GetClinicalBookings"])
    {
        [self processBookingsResponse:appResponse];
    }
}


- (void) processBookingsResponse:(AppResponse *) appResponse
{
    _patientBookings = [Appointment convertFromJsonList:appResponse.JData];
    
    [self.activityIndicator stopAnimating];
    
    NSUInteger bookingCount = [_patientBookings count];
    
    if (bookingCount < _authResponse.Patient.NumberOfBookings) {
        self.navigationItem.rightBarButtonItem = self.addButton;
    }
    else {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    if (bookingCount > 0)
    {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.rowHeight = 120;
        self.tableView.allowsSelection = YES;
    }
    else {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.rowHeight = 60;
        self.tableView.allowsSelection = NO;
    }
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(_patientBookings == nil || [_patientBookings count] == 0)
    {
        return [self.bookingsDataController infoCount];
    }
    else
    {
        return [_patientBookings count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Appointment *appData;
    
    
    if ([self hasBookings]) {
        appData = [_patientBookings objectAtIndex:indexPath.section];
    }
    else {
        //appData = [self.bookingsDataController infoAtIndex:indexPath.section];
    }
    
    static NSString *cellIdentifier;
    if (self.isError) {
        cellIdentifier = @"errorCell";
    }
    else if (!self.hasBookings) {
        cellIdentifier = @"addBookingsCell";
    }
    else {
        cellIdentifier = @"bookingsCell";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (self.isError)
    {
        UILabel *errorLabel = (UILabel *)[cell viewWithTag:100];
        errorLabel.text = appData.StaffId;
    }
    else if (self.isSearching)
    {
        UILabel *searchLabel = (UILabel *)[cell viewWithTag:100];
        searchLabel.text = appData.StaffId;
    }
    else if (!self.hasBookings) {
        UILabel *addLabel = (UILabel *)[cell viewWithTag:100];
        addLabel.text = appData.StaffId;
    }
    else {
        UILabel *slotLabel = (UILabel *)[cell viewWithTag:100];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        NSDate *slotDate = [dateFormatter dateFromString:appData.EventDate];
        [dateFormatter setDateFormat:@"EEE dd MMM yyyy"];
        NSString *strDate = [dateFormatter stringFromDate:slotDate];
        NSString *strSlot = [[NSString alloc] initWithFormat:@"%@ %@", strDate, appData.EventTime];
        slotLabel.text = strSlot;
        
        UILabel *staffLabel = (UILabel *)[cell viewWithTag:101];
        staffLabel.text = appData.StaffId;
        
        UILabel *sessionLabel = (UILabel *)[cell viewWithTag:102];
        sessionLabel.text = appData.Session;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.rowIndex = indexPath;
    
    [self performSegueWithIdentifier:@"bookingSegue" sender:self];
}
- (void)add:(id)sender {
    BOOL showPremises = YES;
    if ([self.premisesDataController.premisesArray count] == 1) {
        NSString *strPremise = [self.premisesDataController.premisesArray objectAtIndex:0];
        if ([strPremise isEqualToString:@"Unspecified"]) {
            self.appointment.Location = strPremise;
            showPremises = NO;
        }
    }

    if (showPremises) {
        [self performSegueWithIdentifier:@"premisesSegue" sender:self];
    }
    else {
        [self performSegueWithIdentifier:@"bookingsSearchSegue" sender:self];
    }
}

#pragma mark - Navigate to child view controller

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"premisesSegue"]) {
        PremisesViewController * premisesViewController = [segue destinationViewController];
        
        premisesViewController.urlStr = self.urlStr;
        premisesViewController.appointment = self.appointment;
        premisesViewController.premisesDelegate = self;
        
        premisesViewController.hub = self.hub;
        premisesViewController.authResponse = self.authResponse;
        premisesViewController.connection = self.connection;
        
        premisesViewController.premisesDataController = [[PremisesDataController alloc] initWithArray:self.premisesDataController.premisesArray];
    }
    else if ([[segue identifier] isEqualToString:@"bookingsSearchSegue"]) {
        SearchTypeViewController * searchTypeViewController = [segue destinationViewController];
        searchTypeViewController.appointment = self.appointment;
        searchTypeViewController.searchTypeDelegate = self;
        searchTypeViewController.hub = self.hub;
        searchTypeViewController.authResponse = self.authResponse;
        searchTypeViewController.connection = self.connection;
    }
    else if ([[segue identifier] isEqualToString:@"bookingSegue"]) {
        /**
        BookingViewController *bookingViewController = [segue destinationViewController];
        AppointmentData *appData = [self.bookingsDataController bookingAtIndex:self.rowIndex.section];
        AppointmentData* appointmentData = [[AppointmentData alloc] initWithData:appData];
        appointmentData.practiceCode = self.appointmentData.practiceCode;
        appointmentData.patientID = self.appointmentData.patientID;
        bookingViewController.appointmentData = appointmentData;
        bookingViewController.urlStr = self.urlStr;
        bookingViewController.bookingDelegate = self;
        **/
        BookingViewController *bookingViewController = [segue destinationViewController];
        Appointment *appointment = [_patientBookings objectAtIndex:self.rowIndex.section];
        bookingViewController.connection = _connection;
        bookingViewController.hub = _hub;
        bookingViewController.authResponse = _authResponse;
        bookingViewController.appointment = appointment;
        bookingViewController.bookingDelegate = self;
    }
}

#pragma mark - premises delegate

- (void)slotsFreeViewControllerDidFinish:(PremisesViewController *)controller slot:(Appointment *)appData;
{
    if (_patientBookings != nil)
    {
        [_patientBookings addObject:appData];
        
        [self setSearching:NO hasBookings:YES isError:NO];
    }
    self.appointment.Location = appData.Location;
}

-(void) bookingsReturnHome:(UIViewController *)controller
{
    [self.bookingsDelegate bookingsReturnHome:self];
}

#pragma mark - cancel booking delegate

- (void)cancelBookingViewControllerDidFinish:(CancelBookingViewController *)controller;
{
    if (_patientBookings != nil)
    {
        Appointment *appointmentToDelete  = [_patientBookings objectAtIndex:self.rowIndex.section];
        
        if ([_patientBookings count] > 0)
        {
            [_patientBookings removeObject:appointmentToDelete];
            [self setSearching:NO hasBookings:YES isError:NO];
        }
        else {
            [self setSearching:NO hasBookings:NO isError:NO];
        }
    }
    [self.navigationController popToViewController:self animated:YES];
}

#pragma mark - request data delegate

-(void)didSetRequest {
    self.requestCount = 1;
    [self performSelector:@selector(getRequest) withObject:nil afterDelay:2];    
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
        [self didGetBookingsRequest:jsonEventData];
    }
}

-(void)didGetBookingsRequest:(NSData *)jsonEventData 
{
    self.addButton.enabled = NO;
    [self.premisesDataController getPremises:self.appointment];

    NSError* error;
    NSArray* eventData = [NSJSONSerialization JSONObjectWithData:jsonEventData options:kNilOptions error:&error];
        
    if ([eventData count] == 0) {
        [self setSearching:NO hasBookings:NO isError:NO];
    }
    else {
        [self.bookingsDataController clearBookings];
        for (NSDictionary* timeSlot in eventData) {
            NSString* slot = [timeSlot objectForKey:@"slt"];
            NSString* date = [timeSlot objectForKey:@"ad"];
            NSString* session = [timeSlot objectForKey:@"ses"];
            NSString* staff = [timeSlot objectForKey:@"stf"];
            
            [self.bookingsDataController addBooking:slot onDate:date forSession:session withStaff:staff];
        }
        [self setSearching:NO hasBookings:YES isError:NO];
    }
}

-(void)getRequestError:(NSString *)strError {
    [self.bookingsDataController clearInfo];
    [self.bookingsDataController addInfo:strError];
    [self setSearching:NO hasBookings:NO isError:YES];
}

#pragma mark - PremisesData delegate

- (void)premisesDataControllerDidFinish
{
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
    //[self.requestDataAccess delRequest:self.requestData];
}

- (void)premisesDataControllerIsEmpty
{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    //[self.requestDataAccess delRequest:self.requestData];
}

- (void)premisesDataControllerHadError:(NSString *)strError
{
    [self.bookingsDataController clearInfo];
    [self.bookingsDataController addInfo:strError];
    [self setSearching:NO hasBookings:NO isError:YES];
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
    [self.bookingsDelegate bookingsReturnHome:self];
}

@end
