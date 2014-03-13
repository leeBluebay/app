//
//  CancelBookingViewController.h
//  Clinical
//
//  Created by brian macbride on 09/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestDataAccess.h"
#import "Appointment.h"
#import "SignalR.h"
#import "AppResponse.h"
#import "AuthResponse.h"

@class CancelBookingViewController;

@protocol CancelBookingViewControllerDelegate <NSObject>
- (void)cancelBookingViewControllerDidFinish:(CancelBookingViewController *)controller;
- (void)bookingsReturnHome:(UIViewController *)controller;
@end

@interface CancelBookingViewController : UIViewController <RequestDataDelegate>

@property (weak, nonatomic) id <CancelBookingViewControllerDelegate> cancelBookingDelegate;


@property (strong, nonatomic) Appointment* appointment;

@property (strong, nonatomic) IBOutlet UILabel *cancelLabel;
@property (strong, nonatomic) IBOutlet UILabel *errorLabel;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;


@property (strong, nonatomic) AppResponse *appResponse;
@property (strong, nonatomic) AuthResponse *authResponse;
@property (strong, nonatomic) SRHubConnection *connection;
@property (strong, nonatomic) SRHubProxy *hub;

- (IBAction)done:(id)sender;

@end
