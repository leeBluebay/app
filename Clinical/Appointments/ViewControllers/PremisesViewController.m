//
//  PremisesViewController.m
//  Appointments1
//
//  Created by brian macbride on 07/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PremisesViewController.h"
#import "PremisesDataController.h"
#import "AppointmentData.h"

@interface PremisesViewController ()
@end

@implementation PremisesViewController

@synthesize urlStr = _urlStr;
@synthesize premisesDataController = _premisesDataController;
@synthesize premisesDelegate = _premisesDelegate;
@synthesize activityIndicator = _activityIndicator;

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
    
    [self.activityIndicator setHidesWhenStopped:YES];
    [self showToolbar];
    
    [_hub on:@"getResponse" perform:self selector:@selector(getResponse:)];
    
    self.appointment.PracticePatientId = self.authResponse.Patient.PracticePatientId;
    
    NSString *appRequest = [NSString stringWithFormat:@"{Ticket: '%@' , Data : %@}", self.authResponse.Ticket, [self.appointment toJsonString]];
    
    
    [_hub invoke:@"getAppointmentPremises" withArgs:@[appRequest]];
}

- (void)viewDidUnload
{
    //self.premisesDataController = nil;
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
    return (NSInteger)[self.premisesDataController.premisesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* CellIdentifier;
    CellIdentifier = @"premisesCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    int row = indexPath.row;
    NSString * strPremise = [self.premisesDataController.premisesArray objectAtIndex:(NSUInteger)row];
    
    UILabel *premiseLabel = (UILabel *)[cell viewWithTag:100];
    premiseLabel.text = strPremise;

    if ([strPremise isEqualToString:self.appointment.Location]){
        UIImageView *premiseImageView = (UIImageView *)[cell viewWithTag:200];
        UIImage *premiseImage = [UIImage imageNamed:@"greentick.png"];
        premiseImageView.image = premiseImage;
    }
    
    return cell;    
}

#pragma mark - SearchType view delegate

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"searchTypeSegue"]) {
        NSIndexPath* indexPath = [[self tableView] indexPathForSelectedRow];
        NSString * strPremise = [self.premisesDataController.premisesArray objectAtIndex:(NSUInteger)indexPath.row];
        self.appointment.Location = strPremise;
        
        SearchTypeViewController * searchTypeViewController = [segue destinationViewController];
        searchTypeViewController.searchTypeDelegate = self;
        
        self.appointment.Location = strPremise;
        
        searchTypeViewController.appointment = self.appointment;
        searchTypeViewController.connection = self.connection;
        searchTypeViewController.hub = self.hub;
        searchTypeViewController.authResponse = self.authResponse;
    }
}

- (void)slotsFreeViewControllerDidFinish:(SearchTypeViewController *)controller slot:(AppointmentData *)appData;
{
    [[self premisesDelegate] slotsFreeViewControllerDidFinish:self slot:appData];
}

-(void)bookingsReturnHome:(SearchTypeViewController *)controller {
    [self.premisesDelegate bookingsReturnHome:self];
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
    [self.premisesDelegate bookingsReturnHome:self];
}

#pragma mark - signalR responses

- (void) getResponse:(NSString *) jsonData
{
    
    AppResponse *appResponse = [AppResponse convertFromJson:jsonData];
    
    if([appResponse.CallbackMethod  isEqual: @"GetAppointmentPremises"])
    {
        [self processResponse:appResponse];
    }
}

-(void)processResponse:(AppResponse*)appResponse
{
    if (appResponse.IsError) {
        [self.premisesDataController.premisesDataDelegate premisesDataControllerHadError:appResponse.Error];
    }
    else
    {
        NSMutableArray * appointments = [Appointment convertFromAppResponse:appResponse];
        
        if([appointments count] == 0)
        {
            [[self.premisesDataController premisesDataDelegate] premisesDataControllerIsEmpty];
        }
        else
        {
            for (Appointment* app in appointments)
            {
                [self.premisesDataController addPremise:app.Location];
            }
        }
        
        [[self.premisesDataController premisesDataDelegate] premisesDataControllerDidFinish];
        [self.tableView reloadData];
    }
}

@end
