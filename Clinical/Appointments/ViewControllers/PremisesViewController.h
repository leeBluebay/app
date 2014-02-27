//
//  PremisesViewController.h
//  Appointments1
//
//  Created by brian macbride on 07/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchTypeViewController.h"
#import "PremisesDataController.h"

@class PremisesViewController;

@protocol PremisesViewControllerDelegate <NSObject>
- (void)slotsFreeViewControllerDidFinish:(PremisesViewController *)controller slot:(AppointmentData *)appData;
- (void)bookingsReturnHome:(UIViewController *)controller;
@end

@interface PremisesViewController : UITableViewController <SearchTypeViewControllerDelegate>

@property (strong, nonatomic) NSString* urlStr;

@property (weak, nonatomic) id <PremisesViewControllerDelegate> premisesDelegate;

@property (strong, nonatomic) PremisesDataController * premisesDataController;

@property (strong, nonatomic) AppointmentData* appointmentData;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
