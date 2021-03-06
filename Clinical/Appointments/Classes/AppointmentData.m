//
//  AppointmentData.m
//  Clinical
//
//  Created by brian macbride on 09/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppointmentData.h"

@implementation AppointmentData

@synthesize practiceCode = _practiceCode;
@synthesize patientID = _patientID;
@synthesize appointmentDate = _appointmentDate;
@synthesize staff = _staff;
@synthesize session = _session;
@synthesize slot = _slot;
@synthesize premise = _premise;

-(id)init
{
    if (self = [super init]){
        _practiceCode = @"";
        _patientID = @"";
        _appointmentDate = @"";
        _staff = @"";
        _session = @"";
        _slot = @"";
        _premise = @"";
    }
    return self;
}

-(AppointmentData*)initWithData:(AppointmentData *)appointmentData
{
    if (self = [self init]) {
        _practiceCode = appointmentData.practiceCode;
        _patientID = appointmentData.patientID;
        _appointmentDate = appointmentData.appointmentDate;
        _staff = appointmentData.staff;
        _session = appointmentData.session;
        _slot = appointmentData.slot;
        _premise = appointmentData.premise;
    }
    
    return self;
}

-(AppointmentData*)initWithPractice:(NSString*)practiceCode forPatient:(NSString*)patientID atPremise:(NSString*)premise
{
    if (self = [self init]) {
        _practiceCode = practiceCode;
        _patientID = patientID;
        _premise = premise;
    }
    
    return self;
}

@end
