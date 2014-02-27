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

@class SessionFreeDataController;
@class SessionFreeViewController;

@protocol SessionFreeViewControllerDelegate <NSObject>
- (void)slotsFreeViewControllerDidFinish:(UIViewController *)controller slot:(AppointmentData *)appData;
- (void)bookingsReturnHome:(UIViewController *)controller;
@end

@interface SessionFreeViewController : UITableViewController <DatesFreeViewControllerDelegate, SessionFreeDataControllerDelegate>

@property (strong, nonatomic) NSString* urlStr;

@property (strong, nonatomic) AppointmentData* appointmentData;

@property (strong, nonatomic) SessionFreeDataController * sessionFreeDataController;

@property (weak, nonatomic) id <SessionFreeViewControllerDelegate> sessionFreeDelegate;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
