//
//  RepeatData.h
//  Clinical
//
//  Created by brian macbride on 11/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RepeatData : NSObject

@property (nonatomic, copy) NSString* practiceCode;
@property (nonatomic, copy) NSString* patientID;
@property (nonatomic, copy) NSString* prescriptionID;
@property (nonatomic) BOOL isSelected;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* dose;
@property (nonatomic, copy) NSString* quantity;
@property (nonatomic, copy) NSString* nextIssue;
@property (nonatomic, copy) NSString* untilDate;
@property (nonatomic, copy) NSString* issuesLeft;
@property (nonatomic, copy) NSString* status;

-(RepeatData*)initWithData:(RepeatData *)repeatData;
-(RepeatData*)initWithPractice:(NSString*)practiceCode forPatient:(NSString*)patientID;

@end
