//
//  SelectRepeatViewController.m
//  Clinical
//
//  Created by brian macbride on 13/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SelectRepeatViewController.h"

@interface SelectRepeatViewController ()

@end

@implementation SelectRepeatViewController

@synthesize repeatData = _repeatData;
@synthesize nameText = _nameText;
@synthesize doseText = _doseText;
@synthesize quantityText = _quantityText;
@synthesize nextIssueText = _nextIssueText;
@synthesize availableUntilText = _availableUntilText;
@synthesize issuesLeftText = _issuesLeftText;
@synthesize statusText = _statusText;

@synthesize selectRepeatDelegate = _selectRepeatDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSDate *nextIssueDate = [dateFormatter dateFromString:self.repeatData.nextIssue];
    NSDate *untilDate = [dateFormatter dateFromString:self.repeatData.untilDate];
    
    [dateFormatter setDateFormat:@"dd MMM yyyy"];

    NSString *nextIssue = @"Not Set";
    if (nextIssueDate != nil)
        nextIssue = [dateFormatter stringFromDate:nextIssueDate];
    
    NSString *until = @"Not Set";
    if (untilDate != nil)
        until = [dateFormatter stringFromDate:untilDate];

    [self.nameText setText:self.repeatData.name];
    [self.doseText setText:self.repeatData.dose];
    [self.quantityText setText:[[NSString alloc] initWithFormat:@"quantity: %@", self.repeatData.quantity]];
    [self.nextIssueText setText:[[NSString alloc] initWithFormat:@"next issue: %@", nextIssue]];
    [self.availableUntilText setText:[[NSString alloc] initWithFormat:@"available until: %@", until]];
    [self.issuesLeftText setText:[[NSString alloc] initWithFormat:@"issues left: %@", self.repeatData.issuesLeft]];
    [self.statusText setText:[[NSString alloc] initWithFormat:@"status: %@", self.repeatData.status]];
    
    [self showToolbar];
}

- (void)viewDidUnload
{
    [self setNameText:nil];
    [self setDoseText:nil];
    [self setQuantityText:nil];
    [self setNextIssueText:nil];
    [self setAvailableUntilText:nil];
    [self setIssuesLeftText:nil];
    [self setStatusText:nil];

    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        [self.selectRepeatDelegate selectRepeatViewControllerReturn:self];
    }
    [super viewWillDisappear:animated];
}

#pragma mark - show toolbar

- (void) showToolbar {
    UIImage *buttonImage = [UIImage imageNamed:kHomeImage];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton addTarget:self action:@selector(returnHome) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setImage:buttonImage forState:UIControlStateNormal];
    leftButton.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    UIBarButtonItem *spaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    NSMutableArray * arr = [NSMutableArray arrayWithObjects:leftBarButtonItem, spaceBarButtonItem, nil];
    [self setToolbarItems:arr animated:YES];
}

- (void)returnHome
{
    [self.selectRepeatDelegate returnHome:self];
}

@end
