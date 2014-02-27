//
//  SessionFreeViewController.m
//  Appointments1
//
//  Created by brian macbride on 07/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SessionFreeViewController.h"
#import "SessionFreeDataController.h"

@interface SessionFreeViewController ()
@property (nonatomic) BOOL isError;
@end

@implementation SessionFreeViewController

@synthesize sessionFreeDataController = _sessionFreeDataController;
@synthesize sessionFreeDelegate = _sessionFreeDelegate;
@synthesize activityIndicator = _activityIndicator;
@synthesize appointmentData = _appointmentData;
@synthesize urlStr = _urlStr;

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

    SessionFreeDataController * aDataController = [[SessionFreeDataController alloc] init];
    self.sessionFreeDataController = aDataController;
    self.sessionFreeDataController.sessionFreeDataDelegate = self;
    self.sessionFreeDataController.urlStr = self.urlStr;
    [self.sessionFreeDataController getAppointmentSessions:self.appointmentData];
    
    [self showToolbar];
}

- (void)viewDidUnload
{
    [self setSessionFreeDataController:nil];
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
    return (NSInteger)[self.sessionFreeDataController.sessionFreeArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* CellIdentifier;
    if (self.isError) {
        CellIdentifier = @"errorCell";
    }
    else {
        CellIdentifier = @"sessionFreeCell";
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSString * strSession = [self.sessionFreeDataController.sessionFreeArray objectAtIndex:(NSUInteger)indexPath.row];
    [[cell textLabel] setText:strSession];
    
    return cell;    
}

#pragma mark - select row

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - SessionFree delegate

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"sessionDatesSegue"]) {
        NSIndexPath* indexPath = [[self tableView] indexPathForSelectedRow];
        NSString * strSession = [self.sessionFreeDataController.sessionFreeArray objectAtIndex:(NSUInteger)indexPath.row];
        self.appointmentData.session = strSession;

        DatesFreeViewController * datesFreeViewController = [segue destinationViewController];
        datesFreeViewController.datesFreeDelegate = self;
        datesFreeViewController.urlStr = self.urlStr;
        AppointmentData* appData = [[AppointmentData alloc] initWithData:self.appointmentData];
        datesFreeViewController.appointmentData = appData;
    }
}

- (void)slotsFreeViewControllerDidFinish:(UIViewController *)controller slot:(AppointmentData *)appData;
{
    [[self sessionFreeDelegate] slotsFreeViewControllerDidFinish:self slot:appData];
}

-(void)bookingsReturnHome:(UIViewController *)controller {
    //[self.navigationController popViewControllerAnimated:YES];
    [self.sessionFreeDelegate bookingsReturnHome:self];
}

#pragma mark - SessionFreeData delegate

- (void)sessionFreeDataControllerDidFinish;
{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.rowHeight = 44;
    [self.tableView reloadData];
    
    [self.activityIndicator stopAnimating];
}

-(void)sessionFreeDataControllerHadError
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
    [self.sessionFreeDelegate bookingsReturnHome:self];
}

@end
