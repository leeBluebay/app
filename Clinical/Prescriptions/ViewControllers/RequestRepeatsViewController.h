//
//  RequestRepeatsViewController.h
//  Clinical
//
//  Created by brian macbride on 17/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RepeatStatusData.h"
#import "RepeatsDataController.h"
#import "SendRequestViewController.h"
#import "ClinicalConstants.h"

@class RequestRepeatsViewController;

@protocol RequestRepeatsViewControllerDelegate <NSObject>
- (void)requestRepeatsViewControllerDidFinish:(RequestRepeatsViewController *)controller;
- (void)requestRepeatsViewControllerReturn:(RequestRepeatsViewController *)controller;
- (void)returnHome:(UIViewController *)controller;
@end

@interface RequestRepeatsViewController : UITableViewController <SendRequestViewControllerDelegate>

@property (weak, nonatomic) id <RequestRepeatsViewControllerDelegate> requestRepeatsDelegate;

@property (strong, nonatomic) RepeatsDataController *repeatsDataController;

@property (strong, nonatomic) NSString* urlStr;

@property (strong, nonatomic) NSString *practiceCode;
@property (strong, nonatomic) NSString *patientID;
@property (nonatomic) BOOL isRequestMore;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *requestButton;

- (IBAction)request:(id)sender;

@end
