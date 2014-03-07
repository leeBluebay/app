//
//  OrderRepeatsViewController.h
//  Clinical
//
//  Created by brian macbride on 16/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestDataAccess.h"
#import "PharmacySelectViewController.h"

@class OrderRepeatsViewController;

@protocol OrderRepeatsViewControllerDelegate <NSObject>
- (void)orderRepeatsViewControllerDidFinish:(OrderRepeatsViewController *)controller;
- (void)returnHome:(UIViewController *)controller;
@end

@interface OrderRepeatsViewController : UIViewController <RequestDataDelegate, PharmacySelectViewControllerDelegate>

@property (weak, nonatomic) id <OrderRepeatsViewControllerDelegate> orderRepeatsDelegate;

@property (strong, nonatomic) NSString *urlStr;
@property (strong, nonatomic) NSString *practiceCode;
@property (strong, nonatomic) NSString *patientID;
@property (strong, nonatomic) NSMutableArray *repeatsArray;

@property (strong, nonatomic) IBOutlet UILabel *orderLabel;
@property (strong, nonatomic) IBOutlet UILabel *errorLabel;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) IBOutlet UILabel *pharmacyLabel;
@property (strong, nonatomic) IBOutlet UIButton *yesButton;
@property (strong, nonatomic) IBOutlet UIButton *noButton;





- (IBAction)done:(id)sender;

@end
