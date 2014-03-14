//
//  CancelBookingViewController.m
//  Clinical
//
//  Created by brian macbride on 09/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CancelBookingViewController.h"
#import "AppRequest.h"

@interface CancelBookingViewController ()
@property (nonatomic, strong) RequestDataAccess *requestDataAccess;
@property (nonatomic, strong) RequestData *requestData;
@property (nonatomic) NSInteger requestCount;
@end

@implementation CancelBookingViewController

@synthesize cancelBookingDelegate = _cancelBookingDelegate;
@synthesize cancelLabel = _cancelLabel;
@synthesize errorLabel = _errorLabel;
@synthesize activityIndicator = _activityIndicator;
@synthesize doneButton = _doneButton;
@synthesize requestDataAccess = _requestDataAccess;
@synthesize requestData = _requestData;
@synthesize requestCount = _requestCount;


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

    self.requestDataAccess = [[RequestDataAccess alloc] init];
    self.requestDataAccess.requestDataDelegate = self;
    
    [_hub on:@"getResponse" perform:self selector:@selector(getResponse:)];
    
    self.appointment.PracticePatientId = self.authResponse.Patient.PracticePatientId;
    
    NSString *appRequest = [NSString stringWithFormat:@"{Ticket: '%@' , Data : %@}", self.authResponse.Ticket, [self.appointment toJsonString]];
    
        
    [_hub invoke:@"cancelClinicalAppointment" withArgs:@[appRequest]];
  
}

- (void)viewDidUnload
{
    [self setActivityIndicator:nil];
    [self setDoneButton:nil];
    [self setCancelLabel:nil];
    [self setErrorLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

-(void) showError:(NSString*)strError {
    self.errorLabel.text = strError;
    self.cancelLabel.hidden = YES;
    [self.activityIndicator stopAnimating];
    [self.navigationItem setHidesBackButton:NO];
}

- (IBAction)done:(id)sender {
    [self.cancelBookingDelegate cancelBookingViewControllerDidFinish:self];
}

#pragma mark - request data delegate


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
            [self showError:@"The request has timed out"];
        }
    }
    else {
        if ([strEventData isEqualToString:@"Cancellation failed"]) {
            [self showError:strEventData];
        }
        else {
            self.cancelLabel.text = @"Your booking has been cancelled";
            self.errorLabel.hidden = YES;
            [self.activityIndicator stopAnimating];
            self.navigationItem.rightBarButtonItem = self.doneButton;
        }
    }
}

-(void)getRequestError:(NSString *)strError {
    [self showError:strError];
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
    [self.cancelBookingDelegate bookingsReturnHome:self];
}

#pragma mark - signalR responses

- (void) getResponse:(NSString *) jsonData
{
    
    AppResponse *appResponse = [AppResponse convertFromJson:jsonData];
    
    if([appResponse.CallbackMethod  isEqual: @"CancelClinicalAppointment"])
    {
        [self processCancelResponse:appResponse];
    }
}

-(void) processCancelResponse:(AppResponse *) appResponse
{
    
    if(appResponse.IsError)
    {
        [self showError:appResponse.Error];
    }
    else
    {
        self.cancelLabel.text = @"Your booking has been cancelled";
        self.errorLabel.hidden = YES;
        [self.activityIndicator stopAnimating];
        self.navigationItem.rightBarButtonItem = self.doneButton;
    }
}

@end
