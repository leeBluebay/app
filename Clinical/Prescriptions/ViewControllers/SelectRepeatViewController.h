//
//  SelectRepeatViewController.h
//  Clinical
//
//  Created by brian macbride on 13/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RepeatData.h"
#import "ClinicalConstants.h"

@class SelectRepeatViewController;

@protocol SelectRepeatViewControllerDelegate <NSObject>
- (void)selectRepeatViewControllerReturn:(SelectRepeatViewController *)controller;
- (void)returnHome:(UIViewController *)controller;
@end

@interface SelectRepeatViewController : UIViewController

@property (weak, nonatomic) id <SelectRepeatViewControllerDelegate> selectRepeatDelegate;

@property (strong, nonatomic) RepeatData* repeatData;

@property (strong, nonatomic) IBOutlet UILabel *nameText;
@property (strong, nonatomic) IBOutlet UILabel *doseText;
@property (strong, nonatomic) IBOutlet UILabel *quantityText;
@property (strong, nonatomic) IBOutlet UILabel *nextIssueText;
@property (strong, nonatomic) IBOutlet UILabel *availableUntilText;
@property (strong, nonatomic) IBOutlet UILabel *issuesLeftText;
@property (strong, nonatomic) IBOutlet UILabel *statusText;

@end
