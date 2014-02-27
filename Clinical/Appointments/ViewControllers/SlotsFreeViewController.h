//
//  SlotsFreeViewController.h
//
//  Created by brian macbride on 07/06/2012.
//

#import <UIKit/UIKit.h>
#import "RequestDataAccess.h"
#import "ConfirmBookingViewController.h"
#import "ClinicalConstants.h"

//@class SlotsFreeViewController;
@class SlotsFreeDataController;
//@class BookingsDataController;

@protocol SlotsFreeViewControllerDelegate <NSObject>
- (void)slotsFreeViewControllerDidFinish:(UIViewController *)controller slot:(AppointmentData*)appData;
- (void)bookingsReturnHome:(UIViewController *)controller;
@end

@interface SlotsFreeViewController : UITableViewController <UIActionSheetDelegate, UIAlertViewDelegate, RequestDataDelegate, ConfirmBookingViewControllerDelegate>

@property (strong, nonatomic) NSString* urlStr;

@property (strong, nonatomic) AppointmentData* appointmentData;

@property (weak, nonatomic) id <SlotsFreeViewControllerDelegate> slotsFreeDelegate;

@property (strong, nonatomic) SlotsFreeDataController * slotsFreeDataController;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
