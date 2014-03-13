//
//  LoginViewController.m
//  Appointments1
//
//  Created by brian macbride on 02/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "ClinicalViewController.h"
#import "SignalR.h"
#import "Router.h"

@interface LoginViewController ()
@property (strong, nonatomic) NSTimer *connectionTimer;
@end

@implementation LoginViewController

@synthesize username = _username;
@synthesize password = _password;
@synthesize activityIndicator = _activityIndicator;
@synthesize messageLabel = _messageLabel;
@synthesize doneButton = _doneButton;
@synthesize strUrl = _strUrl;

bool isConnected = false;
bool isLoggedIn = false;


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
    
    [self.username becomeFirstResponder];
    
    self.messageLabel.text = @"";
    
    [self.activityIndicator setHidesWhenStopped:YES];
    
    self.navigationItem.rightBarButtonItem = nil;
    
    self.username.delegate = self;
    self.password.delegate = self;
    
    [self setupSignalR];
    
    _connectionTimer = [NSTimer scheduledTimerWithTimeInterval: 15
                                                        target: self
                                                      selector:@selector(onConnectionTimerTick:)
                                                      userInfo: nil repeats:NO];
}

- (void) setupSignalR
{
    _connection = [SRHubConnection connectionWithURL: [Router sharedRouter].server_url];
    _hub = [_connection createHubProxy:@"GatewayHub"];
    
    
    __weak __typeof(&*self)weakSelf = self;
    
    _connection.started = ^{
        __strong __typeof(&*weakSelf)strongSelf = weakSelf;
        [strongSelf.username setEnabled:true ];
        [strongSelf.password setEnabled:true ];
        
        [strongSelf.username becomeFirstResponder];
        
        isConnected = true;
    };
    
    [_connection start];
    
    [_hub on:@"authenticationResult" perform:self selector:@selector(authenticationResult:)];
}

- (void)viewDidUnload
{
    [self setUsername:nil];
    [self setPassword:nil];
    [self setActivityIndicator:nil];
    [self setMessageLabel:nil];
    [self setDoneButton:nil];
    
    _connectionTimer = nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.username){
        [self.password becomeFirstResponder];
    }
    else if (textField == self.password){
        [self login:self];
    }
    
    return YES;
}

-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.password) {
        if (!self.navigationItem.rightBarButtonItem) {
            self.navigationItem.rightBarButtonItem = self.doneButton;
        }
    }
    
    return YES;
}

#pragma mark - Bookings view delegate

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if(!isLoggedIn) return;
    
    if ([[segue identifier] isEqualToString:@"clinicalSegue"]) {
        ClinicalViewController *clinicalViewController = [segue destinationViewController];
        clinicalViewController.connection = _connection;
        clinicalViewController.hub = _hub;
        clinicalViewController.authResponse = self.authResponse;
    }
}

- (IBAction)editChange:(id)sender {
    self.messageLabel.text = @"";
}

- (IBAction)passwordChange:(id)sender {
    self.messageLabel.text = @"";
}

- (IBAction)login:(id)sender {
    
    if (self.activityIndicator.hidden)
    {
        [self.activityIndicator startAnimating];
        [self doLogin];
    }
}

#pragma mark - Login Data delegate


-(void) stopTimer
{
    [_connectionTimer invalidate];
    _connectionTimer = nil;
}

- (void) authenticationResult:(NSString *) jsonData
{
    isLoggedIn = true;
    [self stopTimer];
    
    AuthResponse *authResponse = [AuthResponse convertFromJson:jsonData];
    
    if(authResponse.Success)
    {
        self.authResponse = authResponse;
        [self.activityIndicator stopAnimating];
        [self performSegueWithIdentifier:@"clinicalSegue" sender:self];
    }
    else
    {
        NSString *message = @"Invalid credentials";
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                   message:message
                                  delegate:self
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil, nil];
        
        
        
        [alert show];
        
        self.messageLabel.text = @"Login failed";
        
        [self.username setEnabled:true ];
        [self.password setEnabled:true ];
        
        [self.activityIndicator stopAnimating];
    }
    
}

- (void) doLogin
{
    if([self.username.text length] == 0 && [self.password.text length] == 0)
    {
        return;
    }
    
    NSString *request = [NSString stringWithFormat:@"{Username: '%@', Password: '%@'}", self.username.text, self.password.text];
    
    [_hub invoke:@"AuthenticatePatient" withArgs:@[request]];
    
    [self stopTimer];
    
    _connectionTimer = [NSTimer scheduledTimerWithTimeInterval: [Router sharedRouter].methodTimeout
                                                        target: self
                                                      selector:@selector(onLoginTick:)
                                                      userInfo: nil repeats:NO];
    
    
    [self.username setEnabled:false ];
    [self.password setEnabled:false ];
    
}


-(void)onConnectionTimerTick:(NSTimer *)timer {
    if(!isConnected)
    {
        NSString *message = @"Unable to connect to server";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        
        
        
        [alert show];
        
        [self.username setEnabled:false ];
        [self.password setEnabled:false ];
        
        [self.activityIndicator stopAnimating];
    }
}

-(void)onLoginTick:(NSTimer *)timer {
    if(!isLoggedIn)
    {
        NSString *message = @"Unable to login";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        
        
        
        [alert show];
        
        [self.username setEnabled:false ];
        [self.password setEnabled:false ];
        
        [self.activityIndicator stopAnimating];
    }
}
@end

