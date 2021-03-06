//
//  SessionFreeDataController.h
//  Appointments1
//
//  Created by brian macbride on 08/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Appointment.h"
#import "ClinicalConstants.h"

@class SessionFreeDataController;

@protocol SessionFreeDataControllerDelegate <NSObject>
- (void)sessionFreeDataControllerDidFinish;
- (void)sessionFreeDataControllerHadError;
@end

@interface SessionFreeDataController : NSObject

@property (nonatomic, strong) NSString* urlStr;

@property (strong, nonatomic) NSMutableArray * sessionFreeArray;
@property (weak, nonatomic) id <SessionFreeDataControllerDelegate> sessionFreeDataDelegate;


- (void)addSession:(NSString *)strSession;

@end
