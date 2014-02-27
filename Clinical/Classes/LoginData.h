//
//  LoginData.h
//  Appointments1
//
//  Created by brian macbride on 05/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginData : NSObject

@property (nonatomic, copy) NSString *url;
@property (nonatomic) NSNumber *patID;
@property (nonatomic, copy) NSString *practiceCode;
@property (nonatomic, copy) NSString *patientID;
@property (nonatomic, copy) NSString *premise;
@property (nonatomic) BOOL isAppointments;
@property (nonatomic) BOOL isRepeats;
@property (nonatomic) BOOL isTests;
@property (nonatomic) NSNumber *bookings;
@property (nonatomic) NSNumber *messages;

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;

@property (nonatomic, copy) NSString *error;

-(LoginData*)initWithData:(LoginData *)loginData;

@end
