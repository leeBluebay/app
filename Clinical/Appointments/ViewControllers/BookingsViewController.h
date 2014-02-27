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

@class BookingsViewController;

@protocol BookingsViewControllerDelegate
- (void)bookingsReturnHome:(UIViewController *)controller;
@end

@interface BookingsViewController : UITableViewController <UIActionSheetDelegate, PremisesViewControllerDelegate, SearchTypeViewControllerDelegate, RequestDataDelegate, PremisesDataControllerDelegate, BookingViewControllerDelegate>

@property (strong, nonatomic) NSString* urlStr;

@property (weak, nonatomic) id <BookingsViewControllerDelegate> bookingsDelegate;

@property (strong, nonatomic) BookingsDataController * bookingsDataController;

@property (strong, nonatomic) AppointmentData* appointmentData;

@property (nonatomic) NSNumber *bookings;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
