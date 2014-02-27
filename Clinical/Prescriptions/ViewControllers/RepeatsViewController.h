//
//  RepeatsViewController.h
//  Clinical
//
//  Created by brian macbride on 11/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RepeatData.h"
#import "RepeatStatusData.h"
#import "RequestDataAccess.h"
#import "RepeatsDataController.h"
#import "SelectRepeatViewController.h"
#import "OrderRepeatsViewController.h"
#import "RequestRepeatsViewController.h"
#import "ClinicalConstants.h"

@class RepeatsViewController;

@protocol RepeatsViewControllerDelegate
- (void)returnHome:(UIViewController *)controller;
@end

@interface RepeatsViewController : UITableViewController <RequestDataDelegate, OrderRepeatsViewControllerDelegate, RequestRepeatsViewControllerDelegate, UIActionSheetDelegate, SelectRepeatViewControllerDelegate>

@property (strong, nonatomic) NSString* urlStr;

@property (strong, nonatomic) RepeatsDataController *repeatsDataController;

@property (strong, nonatomic) RepeatData* repeatData;

@property (weak, nonatomic) id <RepeatsViewControllerDelegate> repeatsDelegate;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
