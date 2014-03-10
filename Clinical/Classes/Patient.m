//
//  Patient.m
//  Online Services App
//
//  Created by Lee Daniel on 26/02/2014.
//  Copyright (c) 2014 Lee Daniel. All rights reserved.
//

#import "Patient.h"

@implementation Patient

+ (Patient*)convertFromNsDictionary:(NSDictionary *) patientJson
{
    
    // poulate the other properties
    Patient *patient = [[Patient alloc] init];
    
    if([patientJson objectForKey:@"PatientId"] != nil)
        patient.PatientId = [patientJson valueForKey:@"PatientId"];
    
    if([patientJson objectForKey:@"PracticeCode"] != nil)
        patient.PracticeCode = [patientJson valueForKey:@"PracticeCode"];
    
    if([patientJson objectForKey:@"PracticeName"] != nil)
        patient.PracticeName = [patientJson valueForKey:@"PracticeName"];
    
    if([patientJson objectForKey:@"PracticePatientId"] != nil)
        patient.PracticePatientId = [patientJson valueForKey:@"PracticePatientId"];
    
    if([patientJson objectForKey:@"Name"] != nil)
        patient.Name = [patientJson valueForKey:@"Name"];
    
    if([patientJson objectForKey:@"Username"] != nil)
        patient.Username = [patientJson valueForKey:@"Username"];
    
    if([patientJson objectForKey:@"Password"] != nil)
        patient.Password = [patientJson valueForKey:@"Password"];
    
    if([patientJson objectForKey:@"HasRepeats"] != nil)
        patient.HasRepeats = [[patientJson valueForKey:@"HasRepeats"] boolValue];
    
    if([patientJson objectForKey:@"HasAppointments"] != nil)
        patient.HasAppointments = [[patientJson valueForKey:@"HasAppointments"] boolValue];
    
    if([patientJson objectForKey:@"HasTests"] != nil)
        patient.HasTests = [[patientJson valueForKey:@"HasTests"] boolValue];
    
    if([patientJson objectForKey:@"WantsRepeats"] != nil)
        patient.WantsRepeats = [[patientJson valueForKey:@"WantsRepeats"] boolValue];
    
    if([patientJson objectForKey:@"WantsTests"] != nil)
        patient.WantsTests = [[patientJson valueForKey:@"WantsTests"] boolValue];
    
    if([patientJson objectForKey:@"WantsService"] != nil)
        patient.WantsService = [[patientJson valueForKey:@"WantsService"] boolValue];
    
    if([patientJson objectForKey:@"DefaultLocation"] != nil)
        patient.DefaultLocation = [patientJson valueForKey:@"DefaultLocation"];
    
    if([patientJson objectForKey:@"DefaultAppointmentLocation"] != nil)
        patient.DefaultAppointmentLocation = [patientJson valueForKey:@"DefaultAppointmentLocation"];
    
    if([patientJson objectForKey:@"NumberOfBookings"] != nil)
        patient.NumberOfBookings = [[patientJson valueForKey:@"NumberOfBookings"] intValue];
    
    if([patientJson objectForKey:@"NumberOfNewMessages"] != nil)
        patient.NumberOfNewMessages = [[patientJson valueForKey:@"NumberOfNewMessages"] intValue];
    
    if([patientJson objectForKey:@"ReissuePeriod"] != nil)
        patient.ReissuePeriod = [[patientJson valueForKey:@"ReissuePeriod"] intValue];
    
    if([patientJson objectForKey:@"OverduePeriod"] != nil)
        patient.OverduePeriod = [[patientJson valueForKey:@"OverduePeriod"] intValue];
    
    if([patientJson objectForKey:@"IsRemoval"] != nil)
        patient.IsRemoval = [[patientJson valueForKey:@"IsRemoval"] boolValue];
    
    if([patientJson objectForKey:@"IsReissue"] != nil)
        patient.IsReissue = [[patientJson valueForKey:@"IsReissue"] boolValue];
    
    if([patientJson objectForKey:@"PracticeEmailAddress"] != nil)
        patient.PracticeEmailAddress = [patientJson valueForKey:@"PracticeEmailAddress"];
    
    if([patientJson objectForKey:@"PrescriptionMessage1"] != nil)
        patient.PrescriptionMessage1 = [patientJson valueForKey:@"PrescriptionMessage1"];
    
    if([patientJson objectForKey:@"PrescriptionMessage2"] != nil)
        patient.PrescriptionMessage2 = [patientJson valueForKey:@"PrescriptionMessage2"];
    
    return patient;
    
}

@end
