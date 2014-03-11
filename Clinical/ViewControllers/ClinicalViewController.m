//
//  ClinicalViewController.m
//  Clinical
//
//  Created by brian macbride on 09/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ClinicalViewController.h"

@interface ClinicalViewController ()
@end

@implementation ClinicalViewController

@synthesize appointmentData = _appointmentData;
@synthesize repeatData = _repeatData;
@synthesize clinicalDataController = _clinicalDataController;

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

    [self.navigationItem setHidesBackButton:YES];
    
    self.clinicalDataController = [[ClinicalDataController alloc] initWithData:self.authResponse];
    
    self.appointmentData = [[AppointmentData alloc] initWithPractice:self.authResponse.Patient.PracticeCode
                                                          forPatient:self.authResponse.Patient.PracticePatientId
                                                           atPremise:self.authResponse.Patient.DefaultLocation];
    
    self.repeatData = [[RepeatData alloc] initWithPractice:self.authResponse.Patient.PracticeCode
                                                forPatient:self.authResponse.Patient.PracticePatientId];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (NSInteger)[self.clinicalDataController.clinicalArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* CellIdentifier;
    CellIdentifier = @"clinicalCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    int row = indexPath.row;
    NSString * strSearch = [self.clinicalDataController.clinicalArray objectAtIndex:(NSUInteger)row];
    [[cell textLabel] setText:strSearch];
    
    return cell;    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *nextStoryboard;
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSRange messageRange = [cell.textLabel.text rangeOfString:@"Messages"];
    if (messageRange.length > 0) {
        nextStoryboard = [UIStoryboard storyboardWithName:@"Messages" bundle:nil];
        UINavigationController *navController = [nextStoryboard instantiateInitialViewController];
        [navController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        
        MessagesViewController *messagesViewController = [navController.viewControllers objectAtIndex:0];
        
        MessageData *messData = [[MessageData alloc] init];
        /**
        messData.url = self.loginData.url;
        messData.practiceCode = self.loginData.practiceCode;
        messData.patID = [self.loginData.patID stringValue];
        messagesViewController.messageData = messData;
         **/
        messagesViewController.messagesDelegate = self;

        [self presentModalViewController:navController animated:YES];
    }
    if ([cell.textLabel.text isEqualToString:@"Appointments"]) {
        nextStoryboard = [UIStoryboard storyboardWithName:@"Appointments" bundle:nil];
        UINavigationController *navController = [nextStoryboard instantiateInitialViewController];
        [navController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        
        BookingsViewController *bookingsViewController = [navController.viewControllers objectAtIndex:0];
        
        AppointmentData* appData = [[AppointmentData alloc] initWithData:self.appointmentData];
         /**
        bookingsViewController.urlStr = self.loginData.url;
        bookingsViewController.appointmentData = appData;
        bookingsViewController.bookings = self.loginData.bookings;
          **/
        bookingsViewController.bookingsDelegate = self;
        
        [self presentModalViewController:navController animated:YES];
    }
    else if ([cell.textLabel.text isEqualToString:@"Prescriptions"]) {
        nextStoryboard = [UIStoryboard storyboardWithName:@"Prescriptions" bundle:nil];
        UINavigationController *navController = [nextStoryboard instantiateInitialViewController];
        [navController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        
        RepeatsViewController *repeatsViewController = [navController.viewControllers objectAtIndex:0];
         /**
        repeatsViewController.urlStr = self.loginData.url;
          **/
        repeatsViewController.repeatData = [[RepeatData alloc] initWithData:self.repeatData];
        repeatsViewController.repeatsDelegate = self;
        
        [self presentModalViewController:navController animated:YES];
    }
    else if ([cell.textLabel.text isEqualToString:@"Test results"]) {
        nextStoryboard = [UIStoryboard storyboardWithName:@"TestResults" bundle:nil];
        UINavigationController *navController = [nextStoryboard instantiateInitialViewController];
        [navController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        
        TestsViewController *testsViewController = [navController.viewControllers objectAtIndex:0];
         /**
        testsViewController.urlStr = self.loginData.url;
        testsViewController.practiceCode = self.loginData.practiceCode;
        testsViewController.patientID = self.loginData.patientID;
          **/
        testsViewController.testsDelegate = self;
        
        [self presentModalViewController:navController animated:YES];
    }
}

#pragma mark - child view controller delegate

-(void) returnHome:(UIViewController *)controller {
    [self dismissModalViewControllerAnimated:YES];
}

-(void) bookingsReturnHome:(UIViewController *)controller {
    BookingsViewController *bookingsViewController = (BookingsViewController*)controller;
    self.appointmentData.premise = bookingsViewController.appointmentData.premise;
    [self dismissModalViewControllerAnimated:YES];
}

-(void) messagesReturnHome:(UIViewController *)controller withNew:(NSUInteger)newMessages {
    [self dismissModalViewControllerAnimated:YES];
    [self.clinicalDataController showNewMessages:newMessages];
    [self.tableView reloadData];
}

@end
