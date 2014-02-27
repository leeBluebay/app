//
//  BookingViewController.h
//  Clinical
//
//  Created by brian macbride on 03/08/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import "CancelBookingViewController.h"
#import "ClinicalConstants.h"

@class BookingViewController;

@protocol BookingViewControllerDelegate <NSObject>
- (void)cancelBookingViewControllerDidFinish:(BookingViewController *)controller;
- (void)bookingsReturnHome:(UIViewController *)controller;
@end

@interface BookingViewController : UIViewController <CancelBookingViewControllerDelegate, UIActionSheetDelegate, EKEventEditViewDelegate>

@property (weak, nonatomic) id <BookingViewControllerDelegate> bookingDelegate;

@property (strong, nonatomic) NSString* urlStr;

@property (strong, nonatomic) AppointmentData* appointmentData;

@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *staffLabel;
@property (strong, nonatomic) IBOutlet UILabel *sessionLabel;
@property (strong, nonatomic) IBOutlet UIButton *cancelBookingButton;
@property (strong, nonatomic) IBOutlet UIButton *calendarButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)calendar:(id)sender;
- (IBAction)cancelBooking:(id)sender;

@end
