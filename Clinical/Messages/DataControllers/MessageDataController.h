//
//  MessageDataController.h
//  Clinical
//
//  Created by BlueBay Medical Systems on 27/11/2012.
//
//

#import <Foundation/Foundation.h>
#import "AppointmentData.h"
#import "ClinicalConstants.h"
#import "MessageData.h"

@protocol MessageDataControllerDelegate <NSObject>
- (void)messageDataControllerDidFinish:(NSString*)body;
- (void)messageDataControllerDidDelete;
- (void)messageDataControllerHadError:(NSString*)error;
@end

@interface MessageDataController : NSObject

@property (weak, nonatomic) id <MessageDataControllerDelegate> messageDataDelegate;
@property (nonatomic, strong) NSString* urlStr;

- (void)deletePatientMessage: (MessageData*)messageData;
- (void)getPatientMessage: (MessageData*)messageData;

@end
