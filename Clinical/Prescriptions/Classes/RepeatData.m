//
//  RepeatData.m
//  Clinical
//
//  Created by brian macbride on 11/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RepeatData.h"

@implementation RepeatData

@synthesize practiceCode = _practiceCode;
@synthesize patientID = _patientID;
@synthesize prescriptionID = _prescriptionID;
@synthesize isSelected = _isSelected;
@synthesize name = _name;
@synthesize dose = _dose;
@synthesize quantity = _quantity;
@synthesize nextIssue = _nextIssue;
@synthesize untilDate = _untilDate;
@synthesize issuesLeft = _issuesLeft;
@synthesize status = _status;

-(id)init
{
    if (self = [super init]){
        _practiceCode = @"";
        _patientID = @"";
        _prescriptionID = @"";
        _isSelected = NO;
        _name = @"";
        _dose = @"";
        _quantity = @"";
        _nextIssue = @"";
        _untilDate = @"";
        _issuesLeft = @"";
        _status = @"";
    }
    return self;
}

-(RepeatData*)initWithData:(RepeatData *)repeatData
{
    if (self = [self init]) {
        _practiceCode = repeatData.practiceCode;
        _patientID = repeatData.patientID;
        _prescriptionID = repeatData.prescriptionID;
        _isSelected = NO;
        _name = repeatData.name;
        _dose = repeatData.dose;
        _quantity = repeatData.quantity;
        _nextIssue = repeatData.nextIssue;
        _untilDate = repeatData.untilDate;
        _issuesLeft = repeatData.issuesLeft;
        _status = repeatData.status;
    }
    
    return self;
}

-(RepeatData*)initWithPractice:(NSString*)practiceCode forPatient:(NSString*)patientID
{
    if (self = [self init]) {
        _practiceCode = practiceCode;
        _patientID = patientID;
    }
    
    return self;
}

@end
