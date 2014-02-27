//
//  MessageViewController.m
//  Clinical
//
//  Created by BlueBay Medical Systems on 27/11/2012.
//
//

#import "MessageViewController.h"

@interface MessageViewController ()

@end

@implementation MessageViewController

@synthesize messageDelegate = _messageDelegate;
@synthesize messageDataController = _messageDataController;
@synthesize messageData = _messageData;
@synthesize fromLabel = _fromLabel;
@synthesize titleLabel = _titleLabel;
@synthesize sentLabel = _sentLabel;
@synthesize bodyText = _bodyText;
@synthesize activityIndicator = _activityIndicator;
@synthesize errorLabel = _errorLabel;

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
    
    if ([self.messageData.body isEqualToString:@""]) {
        [self.activityIndicator setHidesWhenStopped:YES];
        [self.activityIndicator startAnimating];

        self.messageDataController = [[MessageDataController alloc] init];
        self.messageDataController.messageDataDelegate = self;
        [self.messageDataController getPatientMessage:self.messageData];
    }
    else {
        [self.activityIndicator setHidden:YES];
        [self showMessage];
    }
    
    [self showToolbar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [self setFromLabel:nil];
    [self setBodyText:nil];
    [self setErrorLabel:nil];
    [self setActivityIndicator:nil];
    [self setSentLabel:nil];
    [self setTitleLabel:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

-(void) showMessage {
    self.fromLabel.text = self.messageData.from;
    self.titleLabel.text = self.messageData.title;
    self.sentLabel.text = self.messageData.sent;
    self.bodyText.text = self.messageData.body;
    
    self.errorLabel.hidden = YES;
}


#pragma mark - Delete Message

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Yes"]) {
        [self.activityIndicator startAnimating];
        [self.messageDataController deletePatientMessage:self.messageData];
    }
}

- (IBAction)deleteMessage:(id)sender {
    NSString *strConfirm = [[NSString alloc] initWithFormat:@"Delete message?"];
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:strConfirm delegate:self cancelButtonTitle:@"No"
                                         destructiveButtonTitle:@"Yes" otherButtonTitles:nil, nil];
    
    [sheet showFromToolbar:self.navigationController.toolbar];
}

#pragma mark - Data Controller delegate

- (void)messageDataControllerDidFinish:(NSString*)body
{
    [self.activityIndicator stopAnimating];
    
    self.messageData.body = body;
    [self showMessage];
    [self.messageDelegate messageRead:body];
}

- (void)messageDataControllerDidDelete
{
    [self.activityIndicator stopAnimating];
    [self.messageDelegate messageDeleted];
    
}

-(void) showError:(NSString*)error {
    [self.activityIndicator stopAnimating];
    
    self.errorLabel.text = error;
    
    self.fromLabel.hidden = YES;
    self.titleLabel.hidden = YES;
    self.sentLabel.hidden = YES;
    self.bodyText.hidden = YES;
}

- (void)messageDataControllerHadError:(NSString*)error
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
    [self.messageDelegate messagesReturnHome:self];
}

@end
