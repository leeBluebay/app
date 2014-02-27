//
//  RequestData.m
//  Clinical
//
//  Created by brian macbride on 11/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RequestData.h"

@implementation RequestData

@synthesize practiceCode = _practiceCode;
@synthesize patientID = _patientID;
@synthesize requestType = _requestType;
@synthesize eventData = _eventData;

-(id)init
{
    if (self = [super init]){
        _practiceCode = @"";
        _patientID = @"";
        _requestType = @"";
        _eventData = @"";
    }
    return self;
}

-(RequestData*)initWithData:(RequestData *)requestData
{
    if (self = [self init]) {
        _practiceCode = requestData.practiceCode;
        _patientID = requestData.patientID;
        _requestType = requestData.requestType;
    }
    
    return self;
}

-(RequestData*)initWithPractice:(NSString*)practiceCode forPatient:(NSString*)patientID withRequest:(NSString*)requestType
{
    if (self = [self init]) {
        _practiceCode = practiceCode;
        _patientID = patientID;
        _requestType = requestType;
    }
    
    return self;
}

@end
