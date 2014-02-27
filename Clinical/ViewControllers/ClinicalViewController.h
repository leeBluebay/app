//
//  ClinicalViewController.h
//  Clinical
//
//  Created by brian macbride on 09/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "LoginData.h"
#import "AppointmentData.h"
#import "RepeatData.h"
#import "ClinicalDataController.h"
#import "BookingsViewController.h"
#import "RepeatsViewController.h"
#import "TestsViewController.h"
#import "MessagesViewController.h"
#import "SignalR.h"
#import "AuthResponse.h"
@interface ClinicalViewController : UITableViewController <BookingsViewControllerDelegate, RepeatsViewControllerDelegate, TestsViewControllerDelegate, MessagesViewControllerDelegate>

@property (strong, nonatomic) AuthResponse *authresponse;
@property (strong, nonatomic, readwrite) SRHubConnection *connection;
@property (strong, nonatomic, readwrite) SRHubProxy *hub;

@property (strong, nonatomic) AppointmentData *appointmentData;
@property (strong, nonatomic) RepeatData *repeatData;

@property (strong, nonatomic) ClinicalDataController *clinicalDataController;

@end
