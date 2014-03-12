//
//  MessagesDataController.h
//  Clinical
//
//  Created by BlueBay Medical Systems on 23/11/2012.
//
//

#import <Foundation/Foundation.h>
#import "AppointmentData.h"
#import "ClinicalConstants.h"
#import "MessageData.h"

@protocol MessagesDataControllerDelegate <NSObject>
- (void)messagesDataControllerDidFinish;
- (void)messagesDataControllerHadError;
@end

@interface MessagesDataController : NSObject

@property (weak, nonatomic) id <MessagesDataControllerDelegate> messagesDataDelegate;

-(NSInteger)messageCount;
-(MessageData*)messageAtIndex:(NSInteger)index;
-(void)removeMessageAtIndex:(NSInteger)index;
-(NSUInteger)newMessageCount;
- (MessageData*)addMessage:(NSString *)strMessage;
/*
- (void)getPatientMessages: (MessageData*)messageData;
*/
-(NSDate *) normalisedDate;

@end
