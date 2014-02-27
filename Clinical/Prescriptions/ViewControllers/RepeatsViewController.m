//
//  RepeatsViewController.m
//  Clinical
//
//  Created by brian macbride on 11/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RepeatsViewController.h"

@interface RepeatsViewController ()
@property (nonatomic, strong) RequestDataAccess *requestDataAccess;
@property (nonatomic, strong) RequestData *requestData;
@property (nonatomic) BOOL isSearching;
@property (nonatomic) BOOL hasRepeats;
@property (nonatomic) BOOL isError;
@property (nonatomic) BOOL hasRequestMore;
@property (nonatomic) BOOL isRequestMore;
@property (nonatomic) NSInteger requestCount;
@property (nonatomic, strong) NSIndexPath *selectedIndex;
@property (nonatomic, strong) UIActionSheet *sheet;
@property (nonatomic, strong) UIBarButtonItem *orderButton;
@property (nonatomic) NSInteger orient;
@end

@implementation RepeatsViewController

@synthesize urlStr = _urlStr;
@synthesize repeatsDelegate = _repeatsDelegate;
@synthesize activityIndicator = _activityIndicator;
@synthesize requestDataAccess = _requestDataAccess;
@synthesize requestData = _requestData;
@synthesize repeatData = _repeatData;
@synthesize repeatsDataController = _repeatsDataController;
@synthesize isSearching = _isSearching;
@synthesize hasRepeats = _hasRepeats;
@synthesize isError = _isError;
@synthesize hasRequestMore = _hasRequestMore;
@synthesize isRequestMore = _isRequestMore;
@synthesize requestCount = _requestCount;
@synthesize selectedIndex = _selectedIndex;
@synthesize sheet = _sheet;
@synthesize orderButton = _orderButton;
@synthesize orient = _orient;

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

    [self showToolbar];
    
    self.orient = 0;
    
    self.orderButton = [[UIBarButtonItem alloc] initWithTitle:@"Order" style:UIBarButtonItemStyleBordered target:self action:@selector(order:)];
    self.navigationItem.rightBarButtonItem = self.orderButton;
    
    [self.activityIndicator setHidesWhenStopped:YES];
    
    if (self.repeatsDataController == nil)
    {
        self.requestDataAccess = [[RequestDataAccess alloc] init];
        self.requestDataAccess.requestDataDelegate = self;
        self.requestDataAccess.urlStr = self.urlStr;
        
        self.requestData = [[RequestData alloc] initWithPractice:self.repeatData.practiceCode forPatient:self.repeatData.patientID withRequest:@"5"];
        
        self.repeatsDataController = [[RepeatsDataController alloc] init];
        [self.repeatsDataController addRepeat:@"Searching for repeats..." withStatus:@""];
        
        [self setSearching:YES hasRepeats:NO isError:NO];
        
        self.requestCount = 0;
        [self setRequest];
    }
}

- (void)viewDidUnload
{
    [self setActivityIndicator:nil];
    
    self.orderButton = nil;
    self.requestDataAccess = nil;
    self.requestData = nil;
    self.sheet = nil;
    self.selectedIndex = nil;

    self.toolbarItems = nil;
    self.navigationItem.rightBarButtonItem = nil;

    [super viewDidUnload];
}

-(void) dealloc {
    [self.sheet dismissWithClickedButtonIndex:(self.sheet.numberOfButtons - 1) animated:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if ((toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight))
    {
        self.orient = 1;
    }
    else {
        self.orient = 2;
    }
    [self.tableView reloadData];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    self.orient = 0;
}

- (void) setSearching:(BOOL)searching hasRepeats:(BOOL)repeats isError:(BOOL)error
{
    self.isSearching = searching;
    self.hasRepeats = repeats;
    self.isError = error;
    
    if (searching)
    {
        [self.activityIndicator startAnimating];
        [self enableToolbar:NO];
        [self.orderButton setEnabled:NO];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.navigationItem.rightBarButtonItem = nil;
        self.tableView.allowsSelection = NO;
    }
    else if (error) {
        [self.activityIndicator stopAnimating];
        [self enableToolbar:YES];
        self.navigationItem.rightBarButtonItem = nil;
        self.tableView.allowsSelection = NO;
        [self.tableView reloadData];
    }
    else {
        [self.activityIndicator stopAnimating];
        [self enableToolbar:YES];
        
        if (repeats) 
        {
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            self.navigationItem.rightBarButtonItem = self.orderButton;
            self.tableView.allowsSelection = YES;
        }
        else {
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            self.navigationItem.rightBarButtonItem = nil;
            self.tableView.allowsSelection = NO;
            [self.repeatsDataController clearRepeats];
            [self.repeatsDataController addError:@"No current repeats"];
        }
        [self.tableView reloadData];
    }
}

-(void) setOrderEnable {
    BOOL isEnable = NO;
    for (RepeatStatusData *repeatStatusData in self.repeatsDataController.repeatsArray) {
        for (RepeatData *repeatData in repeatStatusData.repeatsArray) {
            if (repeatData.isSelected) {
                isEnable = YES;
            }
        }
    }
    
    self.orderButton.enabled = isEnable;
}

#pragma mark - order prescription

- (void)order:(id)sender {
    NSString *strConfirm = @"Order selected repeats?";
    self.sheet = [[UIActionSheet alloc] initWithTitle:strConfirm delegate:self cancelButtonTitle:@"Cancel" 
                                         destructiveButtonTitle:nil otherButtonTitles:@"Confirm", nil];
    
    [self.sheet showFromToolbar:self.navigationController.toolbar];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Confirm"]) {
        [self performSegueWithIdentifier:@"orderRepeatsSegue" sender:self];
    }
    else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Request more"]) {
        self.isRequestMore = YES;
        [self performSegueWithIdentifier:@"requestRepeatsSegue" sender:self];
    }
    else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Request removal"]) {
        self.isRequestMore = NO;
        [self performSegueWithIdentifier:@"requestRepeatsSegue" sender:self];
    }
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    RepeatStatusData *repeatStatusData = [self.repeatsDataController.repeatsArray objectAtIndex:(NSUInteger)section];
    return [repeatStatusData.status capitalizedString];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return (NSInteger)[self.repeatsDataController.repeatsArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    RepeatStatusData *repeatStatusData = [self.repeatsDataController.repeatsArray objectAtIndex:(NSUInteger)section];
    
    return (NSInteger)[repeatStatusData.repeatsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RepeatStatusData *repeatStatusData = [self.repeatsDataController.repeatsArray objectAtIndex:(NSUInteger)indexPath.section];
    RepeatData *repeatData = [repeatStatusData.repeatsArray objectAtIndex:(NSUInteger)indexPath.row];

    static NSString *cellIdentifier;
    if (self.isError) {
        cellIdentifier = @"errorCell";
    }
    else if (self.hasRepeats) {
        cellIdentifier = @"repeatsCell";
    }
    else {
        cellIdentifier = @"searchingCell";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    UILabel *drugLabel = (UILabel *)[cell viewWithTag:100];
    drugLabel.text = repeatData.name;
    
    UIButton *drugButton = (UIButton*)[cell viewWithTag:300];

    if (self.hasRepeats) {
        CGFloat labelWidth;
        if (self.orient == 1) {
            labelWidth = 380.0f;
        }
        else if (self.orient == 2) {
            labelWidth = 220.0f;
        }
        else if ((self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight))
        {
            labelWidth = 380.0f;
        }
        else {
            labelWidth = 220.0f;
        }
        CGSize constraint = CGSizeMake(labelWidth, 300.0f);
        
        CGSize size = [drugLabel.text sizeWithFont:[UIFont systemFontOfSize:17.0f] constrainedToSize:constraint lineBreakMode:(NSLineBreakMode)UILineBreakModeWordWrap];
        
        float labelHeight;
        if (size.height > 24.0f) {
            labelHeight = size.height;
        }
        else {
            labelHeight = 24.0f;
        }
        
        [drugLabel setFrame:CGRectMake(50.0f, 10.0f, labelWidth, labelHeight)];

        if ([repeatData.status isEqualToString:@"due"]) {
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
        else {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }

        UIImageView *drugImageView = (UIImageView *)[cell viewWithTag:200];
        UIImage *drugImage;
        if ([repeatData.status isEqualToString:@"due"]) {
            if (repeatData.isSelected) {
                drugImage = [UIImage imageNamed:@"tick.png"];
            }
            else {
                drugImage = [UIImage imageNamed:@"untick.png"];
            }
        }

        drugImageView.image = drugImage;
        drugImageView.center = CGPointMake(drugImageView.center.x, (labelHeight/2) + 10.0f);
        
        [drugButton addTarget:self action:@selector(accessoryButtonTapped:withEvent:) forControlEvents:UIControlEventTouchUpInside];
        drugButton.center = CGPointMake(drugButton.center.x, (labelHeight/2) + 10.0f);
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        drugButton.hidden = YES;
        drugLabel.textAlignment =  UITextAlignmentCenter;
    }

    return cell;    
}

- (void) accessoryButtonTapped: (UIControl *) button withEvent: (UIEvent *) event
{
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: [[[event touchesForView: button] anyObject] locationInView: self.tableView]];

    if (indexPath != nil) {
        self.selectedIndex = indexPath;
        [self performSegueWithIdentifier:@"selectRepeatSegue" sender:self];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    float cellHeight;
    
    if (self.hasRepeats) {
        RepeatStatusData *repeatStatusData = [self.repeatsDataController.repeatsArray objectAtIndex:(NSUInteger)indexPath.section];
        RepeatData *repeatData = [repeatStatusData.repeatsArray objectAtIndex:(NSUInteger)indexPath.row];
        
        NSString *text = repeatData.name;
        
        CGFloat labelWidth;
        if (self.orient == 1) {
            labelWidth = 380.0f;
        }
        else if (self.orient == 2) {
            labelWidth = 220.0f;
        }
        else if ((self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight))
        {
            labelWidth = 380.0f;
        }
        else {
            labelWidth = 220.0f;
        }
        CGSize constraint = CGSizeMake(labelWidth, 300.0f);
        
        CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:17.0f] constrainedToSize:constraint lineBreakMode:(NSLineBreakMode)UILineBreakModeWordWrap];
        
        if (size.height > 24.0f) {
            cellHeight = size.height + 20.0f;
        }
        else {
            cellHeight = 44.0f;
        }
    }
    else if (self.isError) {
        cellHeight = 120.0f;
    }
    else {
        cellHeight = 44.0f;
    }
    
    return cellHeight;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RepeatStatusData *repeatStatusData = [self.repeatsDataController.repeatsArray objectAtIndex:(NSUInteger)indexPath.section];
    RepeatData *repeatData = [repeatStatusData.repeatsArray objectAtIndex:(NSUInteger)indexPath.row];
    
    if ([repeatData.status isEqualToString:@"due"]) {
        repeatData.isSelected = !repeatData.isSelected;
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];

        [self setOrderEnable];
    }
}

#pragma mark - request data

-(void) setRequest {
    [self.requestDataAccess setRequest:self.requestData];
}

- (void)getRequest {
    [self.requestDataAccess getRequest:self.requestData];
}    

#pragma mark - request data delegate

-(void)didSetRequest {
    self.requestCount = 1;
    [self performSelector:@selector(getRequest) withObject:nil afterDelay:2];    
}

-(void)setRequestError:(NSString *)strError {
    [self performSelector:@selector(getRequestError:) withObject:strError afterDelay:1.0];    
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
            [self getRequestError:@"The request has timed out"];
        }
    }
    else {
        NSData* jsonEventData = [strEventData dataUsingEncoding:NSUTF8StringEncoding];
        [self didGetRepeatsRequest:jsonEventData];
    }
}

-(void)didGetRepeatsRequest:(NSData *)jsonEventData 
{
    NSError* error;
    NSArray* eventData = [NSJSONSerialization JSONObjectWithData:jsonEventData options:kNilOptions error:&error];
    
    if ([eventData count] == 0) {
        [self setSearching:NO hasRepeats:NO isError:NO];
    }
    else {
        self.hasRequestMore = NO;
        [self.repeatsDataController clearRepeats];
        [self addRepeats:eventData];
        [self setSearching:NO hasRepeats:YES isError:NO];
    }
    
    [self.requestDataAccess delRequest:self.requestData];
}

-(void)addRepeats: (NSArray*)addArray {
    NSMutableArray *sortArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary* repeat in addArray) {
        RepeatData *repeatData = [[RepeatData alloc] init];
        repeatData.name = [repeat objectForKey:@"nam"];
        repeatData.status = [repeat objectForKey:@"sta"];
        repeatData.prescriptionID = [repeat objectForKey:@"id"];
        repeatData.dose = [repeat objectForKey:@"dos"];
        repeatData.quantity = [repeat objectForKey:@"qua"];
        repeatData.nextIssue = [repeat objectForKey:@"ni"];
        repeatData.untilDate = [repeat objectForKey:@"ud"];
        repeatData.issuesLeft = [repeat objectForKey:@"il"];
        repeatData.status = [repeat objectForKey:@"sta"];
        
        [sortArray addObject:repeatData];
        
        if ([repeatData.status isEqualToString:@"request more"]) {
            self.hasRequestMore = YES;
        }
    }
    
    [self.repeatsDataController addSortedWithArray:sortArray];
}

-(void)getRequestError:(NSString *)strError {
    [self.repeatsDataController clearRepeats];
    [self.repeatsDataController addError:strError];
    [self setSearching:NO hasRepeats:NO isError:YES];
}

#pragma mark - Navigate to child view controller

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"selectRepeatSegue"]) {
        RepeatStatusData *repeatStatusData = [self.repeatsDataController.repeatsArray objectAtIndex:(NSUInteger)self.selectedIndex.section];
        RepeatData *repeatData = [repeatStatusData.repeatsArray objectAtIndex:(NSUInteger)self.selectedIndex.row];

        SelectRepeatViewController * selectRepeatViewController = [segue destinationViewController];
        selectRepeatViewController.repeatData = [[RepeatData alloc] initWithData:repeatData];
        selectRepeatViewController.selectRepeatDelegate = self;
    }
    else if ([[segue identifier] isEqualToString:@"orderRepeatsSegue"]) {
        OrderRepeatsViewController *orderRepeatsViewController = [segue destinationViewController];
        orderRepeatsViewController.orderRepeatsDelegate = self;
        orderRepeatsViewController.urlStr = self.urlStr;
        orderRepeatsViewController.practiceCode = self.repeatData.practiceCode;
        orderRepeatsViewController.patientID = self.repeatData.patientID;
        orderRepeatsViewController.repeatsArray = [[NSMutableArray alloc] init];

        for (RepeatStatusData *repeatStatusData in self.repeatsDataController.repeatsArray) {
            for (RepeatData *repeatData in repeatStatusData.repeatsArray) {
                if (repeatData.isSelected) {
                    [orderRepeatsViewController.repeatsArray addObject:repeatData.prescriptionID];
                }
            }
        }
    }
    else if ([[segue identifier] isEqualToString:@"requestRepeatsSegue"]) {
        RequestRepeatsViewController *requestRepeatsViewController = [segue destinationViewController];
        requestRepeatsViewController.repeatsDataController = [[RepeatsDataController alloc] initWithArray:self.repeatsDataController.repeatsArray forRequestMore:self.isRequestMore];
        requestRepeatsViewController.urlStr = self.urlStr;
        requestRepeatsViewController.practiceCode = self.repeatData.practiceCode;
        requestRepeatsViewController.patientID = self.repeatData.patientID;
        requestRepeatsViewController.isRequestMore = self.isRequestMore;
        requestRepeatsViewController.requestRepeatsDelegate = self;
    }
}

#pragma mark - order repeats delegate

-(void) orderRepeatsViewControllerDidFinish:(OrderRepeatsViewController *)controller
{
    if (self.repeatsDataController != nil)
    {
        NSMutableArray *selectedArray = [[NSMutableArray alloc] init];
        
        for (RepeatStatusData *repeatStatusData in self.repeatsDataController.repeatsArray) {
            for (RepeatData *repeatData in repeatStatusData.repeatsArray) {
                [selectedArray addObject:repeatData];
            }
        }
        
        [self.repeatsDataController clearRepeats];
        
        for (RepeatData *repeatData in selectedArray) {
            if (repeatData.isSelected) {
                repeatData.status = @"ordered";
            }
        }
        
        [self.repeatsDataController addSortedWithArray:selectedArray];
        
        [self.tableView reloadData];
        
        self.orderButton.enabled = NO;
    }
    [self.navigationController popToViewController:self animated:YES];
}

#pragma mark - request repeats delegate

-(void) requestRepeatsViewControllerDidFinish:(RequestRepeatsViewController *)controller
{
    [self.navigationController popToViewController:self animated:YES];
    [self.tableView reloadData];
}

-(void) requestRepeatsViewControllerReturn:(RequestRepeatsViewController *)controller
{
    [self.tableView reloadData];
}

-(void) returnHome:(UIViewController *)controller
{
    [self.repeatsDelegate returnHome:self];
}

#pragma mark - select repeat delegate

-(void) selectRepeatViewControllerReturn:(SelectRepeatViewController *)controller
{
    [self.tableView reloadData];
}

#pragma mark - action sheet

- (void)showActions
{
    if (self.hasRequestMore) {
        self.sheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Request more", @"Request removal", nil];
    }
    else {
        self.sheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Request removal", nil];
    }
    
    [self.sheet showFromToolbar:self.navigationController.toolbar];
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
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showActions)];
    
    NSMutableArray * arr = [NSMutableArray arrayWithObjects:leftBarButtonItem, spaceBarButtonItem, rightBarButtonItem, nil];
    [self setToolbarItems:arr animated:YES];
}

-(void)enableToolbar:(BOOL) isEnable
{
    UIBarButtonItem *rightBarButtonItem = [self.toolbarItems objectAtIndex:2];
    rightBarButtonItem.enabled = isEnable && self.hasRepeats;
}

- (void)returnHome
{
    [self.repeatsDelegate returnHome:self];
}

@end
