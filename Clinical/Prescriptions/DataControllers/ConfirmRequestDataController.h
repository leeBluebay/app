//
//  ConfirmRequestDataController.h
//  Clinical
//
//  Created by brian macbride on 18/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClinicalConstants.h"

@class ConfirmRequestDataController;

@protocol ConfirmRequestDataControllerDelegate <NSObject>
- (void) didSendMail:(ConfirmRequestDataController *)controller;
- (void) sendMailError:(ConfirmRequestDataController *)controller withError:(NSString*)error;
@end

@interface ConfirmRequestDataController : NSObject

@property (nonatomic, strong) NSString* urlStr;

@property (weak, nonatomic) id <ConfirmRequestDataControllerDelegate> confirmRequestDataDelegate;

- (void)sendMail:(NSString *)to forSubject:(NSString*)subject withBody:(NSString*)body;

@end
