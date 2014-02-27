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

    if (self.activityIndicator.hidden)
    {
        [self.activityIndicator startAnimating];
        [self doLogin];
    }
}

#pragma mark - Login Data delegate

- (void) authenticationResult:(NSString *) jsonData
{
   
    AuthResponse *authResponse = [AuthResponse convertFromJson:jsonData];
    
    if(authResponse.Success)
    {
        self.authResponse = authResponse;
        [self.activityIndicator stopAnimating];
        [self performSegueWithIdentifier:@"clinicalSegue" sender:self];
        
    }
    else
    {
        UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"Fail" message:@"Invalid credentials" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        [a show];
        
        
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
    
    
    [self.username setEnabled:false ];
    [self.password setEnabled:false ];
    
}

@end
