//
//  LoginViewController.m
//  Appointments1
//
//  Created by brian macbride on 02/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "ClinicalViewController.h"
#import "AuthResponse.h"
#import "Router.h"

@interface LoginViewController ()
@property (nonatomic, strong) LoginDataController *loginDataController;

@end

@implementation LoginViewController

//@synthesize loginData = _loginData;
@synthesize loginDataController = _loginDataController;
@synthesize username = _username;
@synthesize password = _password;
@synthesize activityIndicator = _activityIndicator;
@synthesize messageLabel = _messageLabel;
@synthesize doneButton = _doneButton;
@synthesize strUrl = _strUrl;


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
    
    self.loginDataController = [[LoginDataController alloc] init];
    self.loginDataController.loginDataDelegate = self;
    
    /*
    self.loginData = [[LoginData alloc] init];
    self.loginData.url = self.strUrl;
    self.loginData.practiceCode = @"EMIS12";
    self.loginData.patientID = @"30";
    */
    
    self.username.delegate = self;
    self.password.delegate = self;
    
    
    _connection = [SRHubConnection connectionWithURL: [Router sharedRouter].server_url];
    _hub = [_connection createHubProxy:@"GatewayHub"];
    
    
    __weak __typeof(&*self)weakSelf = self;
    
    _connection.started = ^{
        __strong __typeof(&*weakSelf)strongSelf = weakSelf;
        [strongSelf.username setEnabled:true ];
        [strongSelf.password setEnabled:true ];
        
        [strongSelf.username becomeFirstResponder];
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
    if ([[segue identifier] isEqualToString:@"clinicalSegue"]) {
        ClinicalViewController *clinicalViewController = [segue destinationViewController];
        //clinicalViewController.loginData = [[LoginData alloc] initWithData:self.loginData];
        clinicalViewController.authresponse = self.authResponse;
    }
}

- (IBAction)editChange:(id)sender {
    self.messageLabel.text = @"";
}

- (IBAction)passwordChange:(id)sender {
    self.messageLabel.text = @"";
}

- (IBAction)login:(id)sender {
    /*
    NSString *username;
    if (![self.username.text isEqualToString:@""]) {
        username = self.username.text;
    }
    else {
        username = kTestLogin;
    }
    
    NSString *password;
    if (![self.password.text isEqualToString:@""]) {
        password = self.password.text;
    }
    else if (![kTestPassword isEqualToString:@""]) {
        password = kTestPassword;
    }
    else {
        password = @"xxx";
    }
    */

    if (self.activityIndicator.hidden)
    {
        [self.activityIndicator startAnimating];
        /*[self.loginDataController checkLogin:username withPassword:password at:self.strUrl];*/
        [self doLogin];
    }
}

#pragma mark - Login Data delegate



-(void) didFailLogin:(LoginDataController *)controller withLogin:(LoginData *)loginData
{
    [self.activityIndicator stopAnimating];

    self.messageLabel.text = loginData.error;
}

- (void) loginWasSuccessful:(AuthResponse *) authResponse
{
  
    [self.activityIndicator stopAnimating];
    
    [self performSegueWithIdentifier:@"clinicalSegue" sender:self];
}

- (void) authenticationResult:(NSString *) jsonData
{
   
    AuthResponse *authResponse = [AuthResponse convertFromJson:jsonData];
    
    if(authResponse.Success)
    {
        self.authResponse = authResponse;
        [self loginWasSuccessful:authResponse];
        
    }
    else
    {
        UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"Fail" message:@"Invalid credentials" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        [a show];
        
        [self.username setEnabled:true ];
        [self.password setEnabled:true ];
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
    
    
    [self.username setEnabled:false ];
    [self.password setEnabled:false ];
    
}

-(void) didCheckLogin:(LoginDataController *)controller withLogin:(LoginData *)loginData
{
    /*
     self.loginData.patID = loginData.patID;
     self.loginData.practiceCode = loginData.practiceCode;
     self.loginData.patientID = loginData.patientID;
     self.loginData.premise = loginData.premise;
     self.loginData.isAppointments = loginData.isAppointments;
     self.loginData.isRepeats = loginData.isRepeats;
     self.loginData.isTests = loginData.isTests;
     self.loginData.bookings = loginData.bookings;
     self.loginData.messages = loginData.messages;
     */
    [self.activityIndicator stopAnimating];
    
    [self performSegueWithIdentifier:@"clinicalSegue" sender:self];
}


@end
