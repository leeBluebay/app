//
//  TestsViewController.h
//  Clinical
//
//  Created by brian macbride on 26/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestDataAccess.h"
#import "TestsDataController.h"
#import "ClinicalConstants.h"

@class TestsViewController;

@protocol TestsViewControllerDelegate
- (void)returnHome:(UIViewController *)controller;
@end

@interface TestsViewController : UITableViewController <RequestDataDelegate>

@property (strong, nonatomic) TestsDataController *testsDataController;

@property (weak, nonatomic) id <TestsViewControllerDelegate> testsDelegate;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) NSString* urlStr;

@property (copy, nonatomic) NSString *practiceCode;
@property (copy, nonatomic) NSString *patientID;

@end
