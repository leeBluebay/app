//
//  StaffFreeViewController.h
//  Appointments1
//
//  Created by brian macbride on 07/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlotsFreeViewController.h"
#import "StaffFreeDataController.h"

#import "Appointment.h"
#import "SignalR.h"
#import "AppResponse.h"
#import "AuthResponse.h"


@class StaffFreeDataController;
@class StaffFreeViewController;

@protocol StaffFreeViewControllerDelegate <NSObject>
- (void)slotsFreeViewControllerDidFinish:(UIViewController *)controller slot:(AppointmentData *)appData;
- (void)bookingsReturnHome:(UIViewController *)controller;
@end

@interface StaffFreeViewController : UITableViewController <SlotsFreeViewControllerDelegate, StaffFreeDataControllerDelegate>

@property (strong, nonatomic) Appointment* appointment;

@property (strong, nonatomic) StaffFreeDataController * staffFreeDataController;

@property (weak, nonatomic) id <StaffFreeViewControllerDelegate> staffFreeDelegate;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


@property (strong, nonatomic) AppResponse *appResponse;
@property (strong, nonatomic) AuthResponse *authResponse;
@property (strong, nonatomic) SRHubConnection *connection;
@property (strong, nonatomic) SRHubProxy *hub;

@end
