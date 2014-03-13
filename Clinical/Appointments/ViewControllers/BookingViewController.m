//
//  BookingViewController.m
//  Clinical
//
//  Created by brian macbride on 03/08/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BookingViewController.h"

@interface BookingViewController ()
@property (nonatomic, strong) EKEventStore *eventStore;
@end

@implementation BookingViewController

@synthesize bookingDelegate = _bookingDelegate;
@synthesize dateLabel = _dateLabel;
@synthesize staffLabel = _staffLabel;
@synthesize sessionLabel = _sessionLabel;
@synthesize cancelBookingButton = _cancelBookingButton;
@synthesize calendarButton = _calendarButton;
@synthesize activityIndicator = _activityIndicator;

@synthesize eventStore = _eventStore;

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
    
    self.eventStore = [[EKEventStore alloc] init];
    
    [self.activityIndicator setHidesWhenStopped:YES];

    if  ([self.eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)])
    {
        self.calendarButton.hidden = YES;
        [self.activityIndicator startAnimating];
        [self.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error){
            if (granted) {
                self.calendarButton.hidden = NO;
            }
            [self.activityIndicator stopAnimating];
        }];
    }
    
    [self showToolbar];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSDate *slotDate = [dateFormatter dateFromString:self.appointment.EventDate];
    [dateFormatter setDateFormat:@"EEE dd MMM yyyy"];
    NSString *strDate = [dateFormatter stringFromDate:slotDate];
    NSString *strSlot = [NSString stringWithFormat:@"%@ %@", strDate, self.appointment.EventTime];

    self.dateLabel.text = strSlot;
    self.staffLabel.text = self.appointment.StaffId;
    self.sessionLabel.text = self.appointment.Session;
    
    self.cancelBookingButton.hidden = ([[NSDate date] timeIntervalSinceDate:slotDate] > 0);
}

- (void)viewDidUnload
{
    [self setDateLabel:nil];
    [self setStaffLabel:nil];
    [self setSessionLabel:nil];
    [self setCancelBookingButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (IBAction)calendar:(id)sender {
    [self addCalendarEvent];
}

- (IBAction)cancelBooking:(id)sender {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSDate *slotDate = [dateFormatter dateFromString:self.appointment.EventDate];
    [dateFormatter setDateFormat:@"EEE dd MMM yyyy"];
    NSString *strDate = [dateFormatter stringFromDate:slotDate];
    
    NSString *strConfirm = [[NSString alloc] initWithFormat:@"Cancel %@ booking with %@ on %@ at %@",
                            self.appointment.Session,
                            self.appointment.StaffId,
                            strDate,
                            self.appointment.EventTime];
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:strConfirm delegate:self cancelButtonTitle:@"No" 
                                         destructiveButtonTitle:@"Yes" otherButtonTitles:nil, nil];
    
    [sheet showFromToolbar:self.navigationController.toolbar];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Yes"]) {
        [self performSegueWithIdentifier:@"cancelBookingSegue" sender:self];
    }
}

#pragma mark - Navigate to child view controller

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"cancelBookingSegue"]) {
        CancelBookingViewController *cancelBookingViewController = [segue destinationViewController];
        cancelBookingViewController.appointment = self.appointment;
        cancelBookingViewController.cancelBookingDelegate = self;
        cancelBookingViewController.connection = _connection;
        cancelBookingViewController.hub = _hub;
        cancelBookingViewController.authResponse = _authResponse;
        
    }
}

#pragma mark - cancel booking delegate

- (void)cancelBookingViewControllerDidFinish:(CancelBookingViewController *)controller;
{
    [self.bookingDelegate cancelBookingViewControllerDidFinish:self];
}

-(void)bookingsReturnHome:(UIViewController *)controller {
    [self.bookingDelegate bookingsReturnHome:self];
}

#pragma mark - calendar

-(void) addCalendarEvent
{
   
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"]];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm"];
    NSString *strStartDate = [NSString stringWithFormat:@"%@ %@", self.appointment.EventDate, self.appointment.EventTime];
    NSDate *startDate = [dateFormatter dateFromString:strStartDate];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.second = 1;
    NSDate *oneSecondLater = [calendar dateByAddingComponents:dateComponents
                                                       toDate:startDate
                                                      options:0];
    
    NSPredicate *predicate = [self.eventStore predicateForEventsWithStartDate:startDate
                                                                      endDate:oneSecondLater
                                                                    calendars:nil];
    EKEvent *event;
    NSArray *events = [self.eventStore eventsMatchingPredicate:predicate];
    if ([events count] == 1) {
        event = [events objectAtIndex:0];
    }
    else {
        event = [EKEvent eventWithEventStore:self.eventStore];
        event.startDate = startDate;
        event.endDate = startDate;
        event.title = [NSString stringWithFormat:@"%@ - %@", self.appointment.StaffId, self.appointment.Session];
    }
    
    EKEventEditViewController *addController = [[EKEventEditViewController alloc] init];
    addController.eventStore = self.eventStore;
    addController.editViewDelegate = self;
    addController.event = event;
    
    [self presentModalViewController:addController animated:YES];
}

#pragma mark EKEventEditViewDelegate

- (void)eventEditViewController:(EKEventEditViewController *)controller 
          didCompleteWithAction:(EKEventEditViewAction)action {
    
    NSError *error = nil;
    EKEvent *thisEvent = controller.event;
    
    switch (action) {
        case EKEventEditViewActionCanceled:
            break;
            
        case EKEventEditViewActionSaved:
            [controller.eventStore saveEvent:controller.event span:EKSpanThisEvent error:&error];
            break;
            
        case EKEventEditViewActionDeleted:
            [controller.eventStore removeEvent:thisEvent span:EKSpanThisEvent error:&error];
            break;
            
        default:
            break;
    }
    
    [controller dismissModalViewControllerAnimated:YES];
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
    [self.bookingDelegate bookingsReturnHome:self];
}

@end
