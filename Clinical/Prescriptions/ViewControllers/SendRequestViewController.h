//
//  SendRequestViewController.h
//  Clinical
//
//  Created by brian macbride on 17/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RepeatsDataController.h"
#import "SendRequestDataController.h"
#import "ConfirmRequestViewController.h"
#import "ClinicalConstants.h"

@class SendRequestViewController;

@protocol SendRequestViewControllerDelegate <NSObject>
- (void)sendRequestViewControllerDidFinish:(SendRequestViewController *)controller;
- (void)sendRequestViewControllerReturn:(SendRequestViewController *)controller;
- (void)returnHome:(UIViewController *)controller;
@end

@interface SendRequestViewController : UIViewController <SendRequestDataControllerDelegate, ConfirmRequestViewControllerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) id <SendRequestViewControllerDelegate> sendRequestDelegate;

@property (strong, nonatomic) NSString *urlStr;
@property (strong, nonatomic) NSString *practiceCode;
@property (strong, nonatomic) NSString *patientID;
@property (nonatomic) BOOL isRequestMore;
@property (strong, nonatomic) SendRequestDataController *sendRequestDataController;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UILabel *toLabel;
@property (strong, nonatomic) IBOutlet UILabel *requestLabel;
@property (strong, nonatomic) IBOutlet UITextField *commentsTextField;
@property (strong, nonatomic) IBOutlet UITextView *repeatsTextView;
@property (strong, nonatomic) IBOutlet UILabel *errorLabel;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *sendButton;

- (IBAction)send:(id)sender;

@end
