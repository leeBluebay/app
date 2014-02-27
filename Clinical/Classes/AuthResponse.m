//
//  AuthResponse.m
//  Online Services App
//
//  Created by Lee Daniel on 26/02/2014.
//  Copyright (c) 2014 Lee Daniel. All rights reserved.
//

#import "AuthResponse.h"
#import "Patient.h"
#import "PatientMessage.h"

@implementation AuthResponse

+ (AuthResponse*)convertFromJson:(NSString *) jsonData
{
    NSData *nsData = [jsonData dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:nsData options:0 error:nil];
    
    if([json objectForKey:@"Success"] == nil) return nil;
    
    bool success = [[json valueForKey:@"Success"] boolValue];
    
    AuthResponse *authResponse = [[AuthResponse alloc] init];
    
    authResponse.Success = success;
    
    if([json objectForKey:@"Status"] != nil)
        authResponse.Status = [[json valueForKey:@"Status"] intValue];
    
    if([json objectForKey:@"CallerConnectionId"] != nil)
        authResponse.CallerConnectionId = [json valueForKey:@"CallerConnectionId"];
    
    if([json objectForKey:@"Ticket"] != nil)
        authResponse.Ticket = [json valueForKey:@"Ticket"];
    
    
    if(success)
    {
        NSDictionary *patientJson= [json objectForKey: @"Patient"];
        
        authResponse.Patient = [Patient convertFromNsDictionary:patientJson];
        
        NSDictionary *messagesJson= [json objectForKey: @"PatientMessages"];
        
        authResponse.PatientMessages = [PatientMessage convertFromJsonArray: messagesJson];
        
    }
    
    return authResponse;
}

@end
