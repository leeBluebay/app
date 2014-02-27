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

@property (strong, nonatomic) NSString* urlStr;

@property (strong, nonatomic) SearchTypeDataController *searchTypeDataController;

@property (strong, nonatomic) AppointmentData* appointmentData;

@property (weak, nonatomic) id <SearchTypeViewControllerDelegate> searchTypeDelegate;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
