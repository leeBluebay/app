//
//  ConfirmBookingViewController.h
//  Clinical
//
//  Created by brian macbride on 10/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppointmentData.h"
#import "Appointment.h"
#import "SignalR.h"
#import "AppResponse.h"
#import "AuthResponse.h"
#import "ClinicalConstants.h"

@class ConfirmBookingViewController;

@protocol ConfirmBookingViewControllerDelegate <NSObject>
- (void)confirmBookingViewControllerDidFinish:(ConfirmBookingViewController *)controller;
- (void)bookingsReturnHome:(UIViewController *)controller;
@end

@interface ConfirmBookingViewController : UIViewController

@property (weak, nonatomic) id <ConfirmBookingViewControllerDelegate> confirmBookingDelegate;

@property (strong, nonatomic) NSString* urlStr;

@property (strong, nonatomic) IBOutlet UILabel *confirmLabel;
@property (strong, nonatomic) IBOutlet UILabel *errorLabel;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


@property (strong, nonatomic) Appointment* appointment;
@property (strong, nonatomic) AppResponse *appResponse;
@property (strong, nonatomic) AuthResponse *authResponse;
@property (strong, nonatomic) SRHubConnection *connection;
@property (strong, nonatomic) SRHubProxy *hub;


- (IBAction)done:(id)sender;

@end
