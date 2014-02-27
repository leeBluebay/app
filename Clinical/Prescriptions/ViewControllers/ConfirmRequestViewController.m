//
//  ConfirmRequestViewController.m
//  Clinical
//
//  Created by brian macbride on 18/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ConfirmRequestViewController.h"

@interface ConfirmRequestViewController ()

@end

@implementation ConfirmRequestViewController

@synthesize confirmRequestDelegate = _confirmRequestDelegate;
@synthesize confirmRequestDataController = _confirmRequestDataController;
@synthesize requestLabel = _requestLabel;
@synthesize errorLabel = _errorLabel;
@synthesize activityIndicator = _activityIndicator;
@synthesize doneButton = _doneButton;
@synthesize to = _to;
@synthesize subject = _subject;
@synthesize body = _body;
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
    
    self.confirmRequestDataController = [[ConfirmRequestDataController alloc] init];
    self.confirmRequestDataController.urlStr = self.urlStr;
    self.confirmRequestDataController.confirmRequestDataDelegate = self;
    [self.confirmRequestDataController sendMail:self.to forSubject:self.subject withBody:self.body];
    
    self.errorLabel.text = @"";
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;

    [self.activityIndicator setHidesWhenStopped:YES];
    [self.activityIndicator startAnimating];
    [self showToolbar];
}

- (void)viewDidUnload
{
    [self setActivityIndicator:nil];
    [self setErrorLabel:nil];
    [self setRequestLabel:nil];
    [self setDoneButton:nil];

    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (IBAction)done:(id)sender {
    [self.confirmRequestDelegate confirmRequestViewControllerDidFinish:self];
}

-(void) showError:(NSString*)error {
    [self.activityIndicator stopAnimating];
    
    self.errorLabel.text = error;
    self.navigationItem.hidesBackButton = NO;
    self.requestLabel.hidden = YES;
}

#pragma mark - confirm request data delegate

-(void) didSendMail:(ConfirmRequestDataController *)controller
{
    [self.activityIndicator stopAnimating];
    
    self.requestLabel.text = @"Your request has been sent";
    self.navigationItem.rightBarButtonItem = self.doneButton;
    
    self.errorLabel.hidden = YES;
}

-(void) sendMailError:(ConfirmRequestDataController *)controller withError:(NSString *)error
{
    [self performSelector:@selector(showError:) withObject:error afterDelay:1];
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
    [self.confirmRequestDelegate returnHome:self];
}

@end
