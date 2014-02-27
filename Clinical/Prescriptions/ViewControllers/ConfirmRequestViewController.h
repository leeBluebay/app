//
//  ConfirmRequestViewController.h
//  Clinical
//
//  Created by brian macbride on 18/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfirmRequestDataController.h"

@class ConfirmRequestViewController;

@protocol ConfirmRequestViewControllerDelegate <NSObject>
- (void)confirmRequestViewControllerDidFinish:(ConfirmRequestViewController *)controller;
- (void)returnHome:(UIViewController *)controller;
@end

@interface ConfirmRequestViewController : UIViewController <ConfirmRequestDataControllerDelegate>

@property (weak, nonatomic) id <ConfirmRequestViewControllerDelegate> confirmRequestDelegate;

@property (strong, nonatomic) NSString *urlStr;
@property (strong, nonatomic) NSString *to;
@property (strong, nonatomic) NSString *subject;
@property (strong, nonatomic) NSString *body;

@property (strong, nonatomic) ConfirmRequestDataController *confirmRequestDataController;

@property (strong, nonatomic) IBOutlet UILabel *requestLabel;
@property (strong, nonatomic) IBOutlet UILabel *errorLabel;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;

- (IBAction)done:(id)sender;

@end
