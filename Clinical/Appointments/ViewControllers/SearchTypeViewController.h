//
//  SearchTypeViewController.h
//  Appointments1
//
//  Created by brian macbride on 07/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatesFreeViewController.h"
#import "StaffFreeViewController.h"
#import "SessionFreeViewController.h"
#import "SearchTypeDataController.h"

@class SearchTypeViewController;

@protocol SearchTypeViewControllerDelegate <NSObject>
- (void)slotsFreeViewControllerDidFinish:(SearchTypeViewController *)controller slot:(AppointmentData *)appData;
- (void)bookingsReturnHome:(UIViewController *)controller;
@end

@interface SearchTypeViewController : UITableViewController <UIActionSheetDelegate, DatesFreeViewControllerDelegate, StaffFreeViewControllerDelegate, SessionFreeViewControllerDelegate>

@property (strong, nonatomic) SearchTypeDataController *searchTypeDataController;

@property (strong, nonatomic) Appointment* appointment;

@property (weak, nonatomic) id <SearchTypeViewControllerDelegate> searchTypeDelegate;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


@property (strong, nonatomic) AuthResponse *authResponse;
@property (strong, nonatomic) SRHubConnection *connection;
@property (strong, nonatomic) SRHubProxy *hub;

@end
