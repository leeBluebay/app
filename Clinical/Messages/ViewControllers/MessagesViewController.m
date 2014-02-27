//
//  MessagesViewController.m
//  Clinical
//
//  Created by BlueBay Medical Systems on 23/11/2012.
//
//

#import "MessagesViewController.h"

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
    [self.messagesDataController getPatientMessages:self.messageData];
    
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
        MessageData *messData = [self.messagesDataController messageAtIndex:self.rowIndex.row];
        messData.read = YES;
        messData.url = self.messageData.url;
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


@end
