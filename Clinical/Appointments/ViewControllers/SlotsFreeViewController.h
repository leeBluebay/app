//
//  SlotsFreeViewController.h
//
//  Created by brian macbride on 07/06/2012.
//

#import <UIKit/UIKit.h>
#import "RequestDataAccess.h"
#import "ConfirmBookingViewController.h"
#import "ClinicalConstants.h"
#import "Appointment.h"

@class SlotsFreeDataController;

@protocol SlotsFreeViewControllerDelegate <NSObject>
- (void)slotsFreeViewControllerDidFinish:(UIViewController *)controller slot:(Appointment*)appData;
- (void)bookingsReturnHome:(UIViewController *)controller;
@end

@interface SlotsFreeViewController : UITableViewController <UIActionSheetDelegate, UIAlertViewDelegate, ConfirmBookingViewControllerDelegate>

@property (strong, nonatomic) Appointment* appointment;

@property (weak, nonatomic) id <SlotsFreeViewControllerDelegate> slotsFreeDelegate;

@property (strong, nonatomic) SlotsFreeDataController * slotsFreeDataController;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


@property (strong, nonatomic) AppResponse *appResponse;
@property (strong, nonatomic) AuthResponse *authResponse;
@property (strong, nonatomic) SRHubConnection *connection;
@property (strong, nonatomic) SRHubProxy *hub;

@end
