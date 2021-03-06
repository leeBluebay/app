//
//  OrderRepeatsViewController.m
//  Clinical
//
//  Created by brian macbride on 16/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OrderRepeatsViewController.h"
#import "PharmacySelectViewController.h"

@interface OrderRepeatsViewController ()
@property (nonatomic) NSInteger requestCount;
@property (nonatomic, strong) RequestDataAccess *requestDataAccess;
@property (nonatomic, strong) RequestData *requestData;
@end

@implementation OrderRepeatsViewController

@synthesize orderRepeatsDelegate = _orderRepeatsDelegate;
@synthesize orderLabel = _orderLabel;
@synthesize errorLabel = _errorLabel;
@synthesize doneButton = _doneButton;
@synthesize activityIndicator = _activityIndicator;
@synthesize repeatsArray = _repeatsArray;
@synthesize practiceCode = _practiceCode;
@synthesize patientID = _patientID;
@synthesize requestCount = _requestCount;
@synthesize requestDataAccess = _requestDataAccess;
@synthesize requestData = _requestData;
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
    
    
    self.pharmacyLabel.hidden = true;
    self.yesButton.hidden = true;
    self.noButton.hidden = true;

    [self.navigationItem setHidesBackButton:YES];
    self.navigationItem.rightBarButtonItem = nil;
    [self.activityIndicator setHidesWhenStopped:YES];
    [self.activityIndicator startAnimating];
    [self.errorLabel setText:@""];
    
    self.requestDataAccess = [[RequestDataAccess alloc] init];
    self.requestDataAccess.requestDataDelegate = self;
    self.requestDataAccess.urlStr = self.urlStr;
    
    self.requestData = [[RequestData alloc] initWithPractice:self.practiceCode forPatient:self.patientID withRequest:@"6"];

    NSData *jsonEventData = [NSJSONSerialization dataWithJSONObject:self.repeatsArray options:0 error:nil];
    NSString *eventData = [[NSString alloc]initWithData:jsonEventData encoding:NSUTF8StringEncoding];
    self.requestData.eventData = eventData;
    
    [self.requestDataAccess setRequest:self.requestData];
    [self showToolbar];
}

- (void)viewDidUnload
{
    [self setOrderLabel:nil];
    [self setDoneButton:nil];
    [self setActivityIndicator:nil];

    [self setErrorLabel:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (IBAction)done:(id)sender {
    [self.orderRepeatsDelegate orderRepeatsViewControllerDidFinish:self];
}

- (void)getRequest {
    [self.requestDataAccess getRequest:self.requestData];
}

-(void) showError:(NSString*)strError {
    self.orderLabel.text = @"";
    self.errorLabel.text = strError;
    [self.activityIndicator stopAnimating];
    [self.navigationItem setHidesBackButton:NO];
}


- (IBAction)returnHome:(id)sender {
    [self.orderRepeatsDelegate returnHome:self];
}

#pragma mark - request data delegate

-(void)didSetRequest {
    self.requestCount = 1;
    [self performSelector:@selector(getRequest) withObject:nil afterDelay:2];    
}

-(void)setRequestError:(NSString *)strError {
    [self performSelector:@selector(showError:) withObject:strError afterDelay:1];
}

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
        self.orderLabel.text = @"Your repeats have been ordered";
        [self.activityIndicator stopAnimating];
        self.navigationItem.rightBarButtonItem = self.doneButton;
        [self.requestDataAccess delRequest:self.requestData];
        
        self.pharmacyLabel.hidden = false;
        self.yesButton.hidden = false;
        self.noButton.hidden = false;
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
    [self.orderRepeatsDelegate returnHome:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PharmacySelectViewController * pharmacySelectViewController = [segue destinationViewController];
    pharmacySelectViewController.pharmacySelectViewControllerDelegate = self;
}

@end
