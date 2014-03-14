//
//  ConfirmBookingViewController.m
//  Clinical
//
//  Created by brian macbride on 10/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ConfirmBookingViewController.h"

@interface ConfirmBookingViewController ()
@property (nonatomic) NSInteger requestCount;
@end

@implementation ConfirmBookingViewController

@synthesize confirmBookingDelegate = _confirmBookingDelegate;
@synthesize confirmLabel = _confirmLabel;
@synthesize errorLabel = _errorLabel;
@synthesize doneButton = _doneButton;
@synthesize activityIndicator = _activityIndicator;
@synthesize requestCount = _requestCount;
@synthesize urlStr = _urlStr;

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
    [self.navigationItem setHidesBackButton:YES];
    self.navigationItem.rightBarButtonItem = nil;
    [self.activityIndicator setHidesWhenStopped:YES];
    [self.activityIndicator startAnimating];
    [self.errorLabel setText:@""];
    [self showToolbar];
    
    [_hub on:@"getResponse" perform:self selector:@selector(getResponse:)];
    
    self.appointment.PracticePatientId = self.authResponse.Patient.PracticePatientId;
    
    NSString *appRequest = [NSString stringWithFormat:@"{Ticket: '%@' , Data : %@}", self.authResponse.Ticket, [self.appointment toJsonString]];
    
    [_hub invoke:@"bookClinicalAppointment" withArgs:@[appRequest]];
}

- (void)viewDidUnload
{
    [self setDoneButton:nil];
    [self setActivityIndicator:nil];
    [self setConfirmLabel:nil];
    [self setErrorLabel:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (IBAction)done:(id)sender {
    [self.confirmBookingDelegate confirmBookingViewControllerDidFinish:self];
}

-(void) showError:(NSString*)strError {
    self.errorLabel.text = strError;
    self.confirmLabel.hidden = YES;
    [self.activityIndicator stopAnimating];
    [self.navigationItem setHidesBackButton:NO];
}


#pragma mark - show toolbar

- (void) showToolbar
{
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
    [self.confirmBookingDelegate bookingsReturnHome:self];
}

#pragma mark - signalR responses

- (void) getResponse:(NSString *) jsonData
{
    AppResponse *appResponse = [AppResponse convertFromJson:jsonData];
    
    if([appResponse.CallbackMethod  isEqual: @"BookClinicalAppointment"])
    {
        [self processConfirmResponse:appResponse];
    }
}

-(void) processConfirmResponse:(AppResponse *) appResponse
{
    if(appResponse.IsError)
    {
        [self showError:appResponse.Error];
    }
    else
    {
        self.confirmLabel.text = @"Your booking has been confirmed";
        [self.activityIndicator stopAnimating];
        self.navigationItem.rightBarButtonItem = self.doneButton;
    }
}

@end
