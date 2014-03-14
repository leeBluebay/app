//
//  DatesFreeViewController.h
//  Appointments1
//
//  Created by brian macbride on 07/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StaffFreeViewController.h"
#import "SlotsFreeViewController.h"
#import "DatesFreeDataController.h"
#import "ClinicalConstants.h"

#import "Appointment.h"
#import "SignalR.h"
#import "AppResponse.h"
#import "AuthResponse.h"

@class DatesFreeViewController;

@protocol DatesFreeViewControllerDelegate <NSObject>
- (void)slotsFreeViewControllerDidFinish:(UIViewController *)controller slot:(AppointmentData*)appData;
- (void)bookingsReturnHome:(UIViewController *)controller;
@end

@interface DatesFreeViewController : UITableViewController <StaffFreeViewControllerDelegate, SlotsFreeViewControllerDelegate, DatesFreeDataControllerDelegate>

@property (strong, nonatomic) Appointment* appointment;

@property (strong, nonatomic) DatesFreeDataController * datesFreeDataController;

@property (weak, nonatomic) id <DatesFreeViewControllerDelegate> datesFreeDelegate;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


@property (strong, nonatomic) AppResponse *appResponse;
@property (strong, nonatomic) AuthResponse *authResponse;
@property (strong, nonatomic) SRHubConnection *connection;
@property (strong, nonatomic) SRHubProxy *hub;

@end
