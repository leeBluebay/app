//
//  RequestDataAccess.h
//  Appointments1
//
//  Created by brian macbride on 14/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppointmentData.h"
#import "RequestData.h"
#import "ClinicalConstants.h"

@class RequestDataAccess;

@protocol RequestDataDelegate <NSObject>
-(void)didSetRequest;
-(void)setRequestError:(NSString*)strError;
-(void)didGetRequest:(NSData*)responseData;
-(void)getRequestError:(NSString*)strError;
@end

@interface RequestDataAccess : NSObject

@property (weak, nonatomic) id <RequestDataDelegate> requestDataDelegate;

@property (nonatomic, copy) NSString* urlStr;

- (void)setRequest:(RequestData*)requestData;
- (void)getRequest:(RequestData*)requestData;
- (void)delRequest:(RequestData*)requestData;

-(NSString*)getAppointmentEventData:(AppointmentData*)appointmentData;

@end

