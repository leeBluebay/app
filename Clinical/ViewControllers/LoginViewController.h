//
//  LoginViewController.h
//  Appointments1
//
//  Created by brian macbride on 02/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginDataController.h"
#import "LoginData.h"
#import "SignalR.h"
#import "AuthResponse.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate, LoginDataControllerDelegate>

@property (nonatomic, copy) NSString* strUrl;
@property (strong, nonatomic) AuthResponse *authResponse;

@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *password;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@property (strong, nonatomic, readwrite) SRHubConnection *connection;
@property (strong, nonatomic, readwrite) SRHubProxy *hub;

- (IBAction)editChange:(id)sender;
- (IBAction)passwordChange:(id)sender;

- (IBAction)login:(id)sender;

@end
