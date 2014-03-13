//
//  BookingsViewController.h
//  Appointments1
//
//  Created by brian macbride on 08/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "PremisesViewController.h"
#import "BookingsDataController.h"
#import "BookingViewController.h"
#import "ClinicalConstants.h"
#import "SignalR.h"
#import "AppResponse.h"
#import "AuthResponse.h"

@class BookingsViewController;

@protocol BookingsViewControllerDelegate
- (void)bookingsReturnHome:(UIViewController *)controller;
@end

@interface BookingsViewController : UITableViewController <UIActionSheetDelegate, PremisesViewControllerDelegate, SearchTypeViewControllerDelegate, PremisesDataControllerDelegate, BookingViewControllerDelegate>

@property (strong, nonatomic) NSString* urlStr;

@property (weak, nonatomic) id <BookingsViewControllerDelegate> bookingsDelegate;

@property (strong, nonatomic) BookingsDataController * bookingsDataController;

@property (strong, nonatomic) AppointmentData* appointmentData;

@property (nonatomic) NSInteger *bookings;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) AppResponse *appResponse;
@property (strong, nonatomic) AuthResponse *authResponse;
@property (strong, nonatomic) SRHubConnection *connection;
@property (strong, nonatomic) SRHubProxy *hub;


@end
