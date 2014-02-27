//
//  MessageViewController.h
//  Clinical
//
//  Created by BlueBay Medical Systems on 27/11/2012.
//
//

#import <UIKit/UIKit.h>
#import "MessageData.h"
#import "ClinicalConstants.h"
#import "MessageDataController.h"

@protocol MessageViewControllerDelegate
- (void)messagesReturnHome:(UIViewController *)controller;
- (void)messageRead:(NSString*)body;
- (void)messageDeleted;
@end

@interface MessageViewController : UIViewController <MessageDataControllerDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) id <MessageViewControllerDelegate> messageDelegate;

@property (strong, nonatomic) MessageData* messageData;

@property (strong, nonatomic) MessageDataController * messageDataController;

@property (strong, nonatomic) IBOutlet UILabel *fromLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *sentLabel;
@property (strong, nonatomic) IBOutlet UITextView *bodyText;

@property (strong, nonatomic) IBOutlet UILabel *errorLabel;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)deleteMessage:(id)sender;

@end
