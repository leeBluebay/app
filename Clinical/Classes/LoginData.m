//
//  LoginData.m
//  Appointments1
//
//  Created by brian macbride on 05/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginData.h"

@implementation LoginData

@synthesize url = _url;
@synthesize patID = _patID;
@synthesize practiceCode = _practiceCode;
@synthesize patientID = _patientID;
@synthesize premise = _premise;
@synthesize isAppointments = _isAppointments;
@synthesize isRepeats = _isRepeats;
@synthesize isTests = _isTests;
@synthesize bookings = _bookings;
@synthesize messages = _messages;

@synthesize username = _username;
@synthesize password = _password;

@synthesize error = _error;

-(id)init
{
    self = [super init];
    if (self){
        _url = @"";
        _patID = 0;
        _practiceCode = @"";
        _patientID = @"";
        _premise = @"";
        _bookings = 0;
        _messages = 0;
    }
    return self;
}

-(LoginData*)initWithData:(LoginData *)loginData
{
    self = [self init];
    if (self){
        _url = loginData.url;
        _patID = loginData.patID;
        _practiceCode = loginData.practiceCode;
        _patientID = loginData.patientID;
        _premise = loginData.premise;
        _isAppointments = loginData.isAppointments;
        _isRepeats = loginData.isRepeats;
        _isTests = loginData.isTests;
        _bookings = loginData.bookings;
        _messages = loginData.messages;
    }
    
    return self;
}


@end
