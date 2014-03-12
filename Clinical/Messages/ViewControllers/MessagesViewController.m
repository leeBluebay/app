//
//  MessagesViewController.m
//  Clinical
//
//  Created by BlueBay Medical Systems on 23/11/2012.
//
//

#import "MessagesViewController.h"
#import "AppResponse.h"
#import "PatientMessage.h"

@interface MessagesViewController ()
@property (nonatomic, strong) NSIndexPath *rowIndex;
@property (nonatomic) BOOL isError;

@end

@implementation MessagesViewController

@synthesize messagesDelegate = _messagesDelegate;
@synthesize messagesDataController = _messagesDataController;
@synthesize messageData = _messageData;
@synthesize activityIndicator = _activityIndicator;

@synthesize rowIndex = _rowIndex;
@synthesize isError = _isError;

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

    self.isError = NO;
    [self.activityIndicator startAnimating];
    [self.activityIndicator setHidesWhenStopped:YES];
    
    MessagesDataController * aDataController = [[MessagesDataController alloc] init];
    self.messagesDataController = aDataController;
    self.messagesDataController.messagesDataDelegate = self;
    /**[self.messagesDataController getPatientMessages:self.messageData];**/
    

    [_hub on:@"getResponse" perform:self selector:@selector(getResponse:)];
    
    NSString *appRequest = [NSString stringWithFormat:@"{Ticket: '%@', Data: { Top : 0, PatientId : '%@', NewOnly : false}}", self.authResponse.Ticket, self.authResponse.Patient.PatientId];
    
    [_hub invoke:@"getPatientMessages" withArgs:@[appRequest]];
    
    [self showToolbar];
}

- (void)viewDidUnload {
    [self setToolbarItems:nil];
    
    [self setActivityIndicator:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (NSInteger)[self.messagesDataController messageCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* CellIdentifier;
    if (self.isError) {
        CellIdentifier = @"errorCell";
    }
    else {
        CellIdentifier = @"messagesCell";
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    MessageData *messData = [self.messagesDataController messageAtIndex:indexPath.row];
    if (self.isError)
    {
        UILabel *errorLabel = (UILabel *)[cell viewWithTag:100];
        errorLabel.text = messData.body;
    }
    else {
        UILabel *fromLabel = (UILabel *)[cell viewWithTag:100];
        fromLabel.text = messData.from;
        
        UILabel *titleLabel = (UILabel *)[cell viewWithTag:101];
        titleLabel.text = messData.title;
        
        UILabel *sentLabel = (UILabel *)[cell viewWithTag:102];
        sentLabel.text = messData.sent;
        
        if (messData.read) {
            fromLabel.font = [UIFont systemFontOfSize:17];
            titleLabel.font = [UIFont systemFontOfSize:17];
            sentLabel.font = [UIFont systemFontOfSize:17];
        }
        else {
            fromLabel.font = [UIFont boldSystemFontOfSize:17];
            titleLabel.font = [UIFont boldSystemFontOfSize:17];
            sentLabel.font = [UIFont boldSystemFontOfSize:17];
        }
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.rowIndex = indexPath;
    [self performSegueWithIdentifier:@"messageSegue" sender:self];
}

#pragma mark - Navigate to child view controller

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"messageSegue"]) {
        MessageViewController *messageViewController = [segue destinationViewController];
        
        // clear down event handlers
        [_hub on:@"getResponse" perform:self selector:nil];
        
        messageViewController.connection = _connection;
        messageViewController.hub = _hub;
        messageViewController.authResponse = _authResponse;
        
        
        MessageData *messData = [self.messagesDataController messageAtIndex:self.rowIndex.row];
        messData.read = YES;
        messData.patID = self.messageData.patID;
        MessageData* messageData = [[MessageData alloc] initWithData:messData];
        messageViewController.messageData = messageData;
        messageViewController.messageDelegate = self;

        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:self.rowIndex] withRowAnimation:UITableViewRowAnimationNone];
    }
}

-(void)messagesReturnHome:(UIViewController *)controller {
    if (self.isError)
        [self.messagesDelegate returnHome:self];
    else
        [self.messagesDelegate messagesReturnHome:self withNew:[self.messagesDataController newMessageCount]];
}

-(void)messageRead:(NSString*)body;
{
    MessageData *messData = [self.messagesDataController messageAtIndex:self.rowIndex.row];
    messData.body = body;
}

-(void)messageDeleted
{
    [self.messagesDataController removeMessageAtIndex:self.rowIndex.row];
    [self.tableView reloadData];
    [self.navigationController popToViewController:self animated:YES];
}

#pragma mark - MessagesData delegate

- (void)messagesDataControllerDidFinish;
{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.rowHeight = 120;
    [self.tableView reloadData];
    
    [self.activityIndicator stopAnimating];
}

-(void)messagesDataControllerHadError
{
    [self.activityIndicator stopAnimating];
    
    self.isError = YES;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 120;
    [self.tableView reloadData];
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
    if (self.isError)
        [self.messagesDelegate returnHome:self];
    else
        [self.messagesDelegate messagesReturnHome:self withNew:[self.messagesDataController newMessageCount]];
}

#pragma mark - signalR responses

- (void) getResponse:(NSString *) jsonData
{
    
    AppResponse *appResponse = [AppResponse convertFromJson:jsonData];
    
    if([appResponse.CallbackMethod  isEqual: @"GetPatientMessages"])
    {
        [self processMessagesResponse:appResponse];
    }
}

- (void) processMessagesResponse:(AppResponse *) appResponse
{
    if(appResponse.IsError)
    {
        [self.messagesDataController addMessage:appResponse.Error];
        [self.messagesDataController.messagesDataDelegate messagesDataControllerHadError];
    }
    else
    {
        NSData *nsData = [appResponse.JData dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:nsData options:0 error:nil];
        
        NSDictionary *messagesJson = [json valueForKey:@"Items"];
        
        NSMutableArray *messages = [PatientMessage convertFromJsonArray:messagesJson];
        
        if([messages count] == 0)
        {
            [self.messagesDataController addMessage:@"No messages found"];
            [self.messagesDataController.messagesDataDelegate messagesDataControllerHadError];
        }
        else
        {
            for(PatientMessage *message in messages)
            {
                MessageData *messData = [self.messagesDataController addMessage:[NSString stringWithFormat:@"%d", (int)message.MessageId]];
                
                messData.practiceCode = message.PracticeCode;
                messData.patID = [NSString stringWithFormat:@"%d", (int)message.PatientId];
                messData.title = message.Title;
                messData.from = message.From;
                messData.read = message.Read;
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"]];
                [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
                NSString *sentStr = message.Sent;
                NSDate *sentDate = [dateFormatter dateFromString:sentStr];
                NSDate *todayDate = [self.messagesDataController normalisedDate];
                
                NSTimeInterval elapsed = [sentDate timeIntervalSinceDate:todayDate];
                if (elapsed > 0)
                    [dateFormatter setDateFormat:@"EEE dd MMM yyyy HH:mm"];
                else
                    [dateFormatter setDateFormat:@"EEE dd MMM yyyy"];
                
                messData.sent = [dateFormatter stringFromDate:sentDate];
                
            }
            
            [self.messagesDataController.messagesDataDelegate messagesDataControllerDidFinish];
        }
    }
}

@end
