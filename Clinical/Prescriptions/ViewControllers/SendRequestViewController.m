//
//  SendRequestViewController.m
//  Clinical
//
//  Created by brian macbride on 17/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SendRequestViewController.h"
#import "RepeatData.h"

@interface SendRequestViewController ()

@end

@implementation SendRequestViewController

@synthesize sendRequestDelegate = _sendRequestDelegate;
@synthesize commentsTextField = _commentsTextField;
@synthesize repeatsTextView = _repeatsTextView;
@synthesize errorLabel = _errorLabel;
@synthesize sendButton = _sendButton;
@synthesize sendRequestDataController = _sendRequestDataController;
@synthesize scrollView = _scrollView;
@synthesize activityIndicator = _activityIndicator;
@synthesize toLabel = _toLabel;
@synthesize requestLabel = _requestLabel;
@synthesize practiceCode = _practiceCode;
@synthesize patientID = _patientID;
@synthesize isRequestMore = _isRequestMore;
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
    
    self.errorLabel.text = @"";
    self.requestLabel.text = @"";
    
    self.commentsTextField.delegate = self;

    self.sendRequestDataController.sendRequestDataDelegate = self;
    self.sendRequestDataController.urlStr = self.urlStr;
    [self.sendRequestDataController getEmailValues:self.practiceCode];

    [self showToolbar];

    self.navigationItem.rightBarButtonItem = nil;
    
    [self.activityIndicator setHidesWhenStopped:YES];
    [self.activityIndicator startAnimating];
}

- (void)viewDidUnload
{
    [self setRepeatsTextView:nil];
    [self setCommentsTextField:nil];
    [self setToLabel:nil];
    [self setRequestLabel:nil];

    [self setErrorLabel:nil];
    [self setActivityIndicator:nil];
    [self setSendButton:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        [self.sendRequestDelegate sendRequestViewControllerReturn:self];
    }
    [super viewWillDisappear:animated];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (IBAction)send:(id)sender {
    [self performSegueWithIdentifier:@"confirmRequestSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"confirmRequestSegue"]) {
        NSString *strSubject;
        NSString *strBody = @"";
        
        if (![self.commentsTextField.text isEqualToString:@""]) {
            strBody = [strBody stringByAppendingString:self.commentsTextField.text];
            strBody = [strBody stringByAppendingString:@"\n\n"];
        }
        
        if (self.isRequestMore) {
            strSubject = @"Request prescription RE-ISSUE for patient: ";
            strBody = [strBody stringByAppendingString:@"Please RE-ISSUE the following prescription(s) for patient "];
        }
        else {
            strSubject = @"Request prescription REMOVAL for patient: ";
            strBody = [strBody stringByAppendingString:@"Please REMOVE the following prescription(s) for patient "];
        }

        strSubject = [strSubject stringByAppendingString:self.patientID];
        
        strBody = [strBody stringByAppendingString:self.patientID];
        strBody = [strBody stringByAppendingString:@":\n\n"];
        strBody = [strBody stringByAppendingString:self.repeatsTextView.text];
        
        ConfirmRequestViewController *confirmRequestViewController = [segue destinationViewController];
        confirmRequestViewController.urlStr = self.urlStr;
        confirmRequestViewController.to = self.toLabel.text;
        confirmRequestViewController.subject = strSubject;
        confirmRequestViewController.body = strBody;
        confirmRequestViewController.confirmRequestDelegate = self;
    }
}

-(void) returnHome:(UIViewController *)controller
{
    [self.sendRequestDelegate returnHome:self];
}

#pragma mark - send request data delegate

-(void) didGetEmailValues:(SendRequestDataController *)controller emailTo:(NSString *)to
{
    [self.activityIndicator stopAnimating];

    self.navigationItem.rightBarButtonItem = self.sendButton;

    self.toLabel.text = to;
    if (self.isRequestMore) {
        self.requestLabel.text = @"Please RE-ISSUE the following:";
    }
    else {
        self.requestLabel.text = @"Please REMOVE the following:";
    }
    
    NSString *repeatsStr = @"";
    for (NSUInteger i=0; i < [self.sendRequestDataController.repeatsArray count]; i++) {
        RepeatData *repeat = [self.sendRequestDataController.repeatsArray objectAtIndex:i];
        if (i > 0) {
            repeatsStr = [repeatsStr stringByAppendingString:@"\n\n"];
        }
        repeatsStr = [repeatsStr stringByAppendingString:repeat.name];
    }
    
    self.repeatsTextView.text = repeatsStr;

    CGSize constraint = CGSizeMake(280.0f, 3000.0f);
    
    CGSize size = [self.repeatsTextView.text sizeWithFont:[UIFont systemFontOfSize:15.0f] constrainedToSize:constraint lineBreakMode:(NSLineBreakMode)UILineBreakModeWordWrap];
    
    self.repeatsTextView.contentSize = CGSizeMake(280.0f, size.height);
    self.scrollView.contentSize = CGSizeMake(320.0f, 140.0f + size.height);
    
    self.errorLabel.hidden = YES;
}

-(void) getEmailValuesError:(SendRequestDataController *)controller withError:(NSString *)error
{
    [self.activityIndicator stopAnimating];
    
    self.errorLabel.text = error;
    
    self.toLabel.hidden = YES;
    self.commentsTextField.hidden = YES;
    self.requestLabel.hidden = YES;
    self.repeatsTextView.hidden = YES;
}

#pragma mark - confirm request data delegate

-(void) confirmRequestViewControllerDidFinish:(ConfirmRequestViewController *)controller
{
    [self.sendRequestDelegate sendRequestViewControllerDidFinish:self];
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
    [self.sendRequestDelegate returnHome:self];
}

@end
