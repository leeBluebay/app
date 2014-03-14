//
//  SearchTypeViewController.m
//  Appointments1
//
//  Created by brian macbride on 07/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SearchTypeViewController.h"
#import "AppointmentData.h"

@interface SearchTypeViewController ()

@end

@implementation SearchTypeViewController

@synthesize searchTypeDelegate = _searchTypeDelegate;
@synthesize activityIndicator = _activityIndicator;
@synthesize searchTypeDataController = _searchTypeDataController;

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
    
    self.searchTypeDataController = [[SearchTypeDataController alloc] init];
    
    [self.activityIndicator setHidesWhenStopped:YES];
    
    [self showToolbar];
}

- (void)viewDidUnload
{
    [self setSearchTypeDataController:nil];
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
    return (NSInteger)[self.searchTypeDataController.searchTypeArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* CellIdentifier;
    CellIdentifier = @"searchTypeCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    int row = indexPath.row;
    NSString * strSearch = [self.searchTypeDataController.searchTypeArray objectAtIndex:(NSUInteger)row];
    [[cell textLabel] setText:strSearch];
    
    return cell;    
}

#pragma mark - DatesFree / StaffFree / SessionFree delegate

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([[segue identifier] isEqualToString:@"datesFreeSegue"]) {
        DatesFreeViewController * datesFreeViewController = [segue destinationViewController];
        datesFreeViewController.datesFreeDelegate = self;
        datesFreeViewController.appointment = self.appointment;
        
        datesFreeViewController.connection = self.connection;
        datesFreeViewController.hub = self.hub;
        datesFreeViewController.authResponse = self.authResponse;
    }
    else if ([[segue identifier] isEqualToString:@"staffFreeSegue"]) {
        StaffFreeViewController * staffFreeViewController = [segue destinationViewController];
        staffFreeViewController.staffFreeDelegate = self;
        staffFreeViewController.appointment = self.appointment;
        
        staffFreeViewController.connection = self.connection;
        staffFreeViewController.hub = self.hub;
        staffFreeViewController.authResponse = self.authResponse;
    }
    else if ([[segue identifier] isEqualToString:@"sessionFreeSegue"]) {
        SessionFreeViewController * sessionFreeViewController = [segue destinationViewController];
        sessionFreeViewController.sessionFreeDelegate = self;
        sessionFreeViewController.appointment = self.appointment;
        sessionFreeViewController.connection = self.connection;
        sessionFreeViewController.hub = self.hub;
        sessionFreeViewController.authResponse = self.authResponse;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:@"datesFreeSegue" sender:self];
    }
    if (indexPath.row == 1) {
        [self performSegueWithIdentifier:@"staffFreeSegue" sender:self];
    }
    if (indexPath.row == 2) {
        [self performSegueWithIdentifier:@"sessionFreeSegue" sender:self];
    }
}

- (void)slotsFreeViewControllerDidFinish:(UIViewController *)controller slot:(AppointmentData*)appData
{
    [[self searchTypeDelegate] slotsFreeViewControllerDidFinish:self slot:appData];
}

-(void)bookingsReturnHome:(UIViewController *)controller {
    [self.searchTypeDelegate bookingsReturnHome:self];
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
    [self.searchTypeDelegate bookingsReturnHome:self];
}

@end
