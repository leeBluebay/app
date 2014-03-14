//
//  SessionFreeViewController.h
//  Appointments1
//
//  Created by brian macbride on 07/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatesFreeViewController.h"
#import "SessionFreeDataController.h"

#import "Appointment.h"
#import "SignalR.h"
#import "AppResponse.h"
#import "AuthResponse.h"



@class SessionFreeDataController;
@class SessionFreeViewController;

@protocol SessionFreeViewControllerDelegate <NSObject>
- (void)slotsFreeViewControllerDidFinish:(UIViewController *)controller slot:(AppointmentData *)appData;
- (void)bookingsReturnHome:(UIViewController *)controller;
@end

@interface SessionFreeViewController : UITableViewController <DatesFreeViewControllerDelegate, SessionFreeDataControllerDelegate>

@property (strong, nonatomic) NSString* urlStr;

@property (strong, nonatomic) Appointment* appointment;

@property (strong, nonatomic) SessionFreeDataController * sessionFreeDataController;

@property (weak, nonatomic) id <SessionFreeViewControllerDelegate> sessionFreeDelegate;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


@property (strong, nonatomic) AppResponse *appResponse;
@property (strong, nonatomic) AuthResponse *authResponse;
@property (strong, nonatomic) SRHubConnection *connection;
@property (strong, nonatomic) SRHubProxy *hub;

@end
