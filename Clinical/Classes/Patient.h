//
//  Patient.h
//  Online Services App
//
//  Created by Lee Daniel on 26/02/2014.
//  Copyright (c) 2014 Lee Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Patient : NSObject

@property (strong, nonatomic) NSString *PatientId;
//@property (nonatomic, assign) NSInteger PatientId;
@property (strong, nonatomic) NSString *PracticeCode;
@property (strong, nonatomic) NSString *PracticeName;
//@property (nonatomic, assign) NSInteger PracticePatientId;
@property (strong, nonatomic) NSString *PracticePatientId;

@property (strong, nonatomic) NSString *Name;
@property (strong, nonatomic) NSString *Username;
@property (strong, nonatomic) NSString *Password;

@property (nonatomic, assign) BOOL HasRepeats;
@property (nonatomic, assign) BOOL HasAppointments;
@property (nonatomic, assign) BOOL HasTests;
@property (nonatomic, assign) BOOL WantsRepeats;
@property (nonatomic, assign) BOOL WantsTests;
@property (nonatomic, assign) BOOL WantsService;




@property (strong, nonatomic) NSString *DefaultLocation;
@property (strong, nonatomic) NSString *DefaultAppointmentLocation;

@property (nonatomic, assign) NSInteger NumberOfBookings;
@property (nonatomic, assign) NSInteger NumberOfNewMessages;

@property (nonatomic, assign) NSInteger ReissuePeriod;
@property (nonatomic, assign) NSInteger OverduePeriod;

@property (nonatomic, assign) BOOL IsRemoval;
@property (nonatomic, assign) BOOL IsReissue;

@property (strong, nonatomic) NSString *PracticeEmailAddress;
@property (strong, nonatomic) NSString *PrescriptionMessage1;
@property (strong, nonatomic) NSString *PrescriptionMessage2;

+ (Patient*)convertFromNsDictionary:(NSDictionary *) patientJson;

@end
