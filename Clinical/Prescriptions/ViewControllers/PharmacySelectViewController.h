//
//  PharmacySelectViewController.h
//  Clinical Demo
//
//  Created by Lee Daniel on 04/03/2014.
//
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ClinicalConstants.h"

@class PharmacySelectViewController;

@protocol PharmacySelectViewControllerDelegate <NSObject>
//- (void)sendRequestViewControllerDidFinish:(PharmacySelectViewController *)controller;
//- (void)sendRequestViewControllerReturn:(PharmacySelectViewController *)controller;
- (void)returnHome:(UIViewController *)controller;
@end

@interface PharmacySelectViewController : UITableViewController<CLLocationManagerDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) id <PharmacySelectViewControllerDelegate> pharmacySelectViewControllerDelegate;

@end
