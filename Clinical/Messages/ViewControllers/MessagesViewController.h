//
//  MessagesViewController.h
//  Clinical
//
//  Created by BlueBay Medical Systems on 23/11/2012.
//
//

#import <UIKit/UIKit.h>
#import "MessagesDataController.h"
#import "MessageViewController.h"

@protocol MessagesViewControllerDelegate
- (void)returnHome:(UIViewController *)controller;
- (void)messagesReturnHome:(UIViewController *)controller withNew:(NSUInteger)newMessages;
@end

@interface MessagesViewController : UITableViewController <MessagesDataControllerDelegate, MessageViewControllerDelegate>

@property (strong, nonatomic) MessageData* messageData;

@property (strong, nonatomic) MessagesDataController * messagesDataController;

@property (weak, nonatomic) id <MessagesViewControllerDelegate> messagesDelegate;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) AuthResponse *authResponse;
@property (strong, nonatomic) SRHubConnection *connection;
@property (strong, nonatomic) SRHubProxy *hub;

@end
