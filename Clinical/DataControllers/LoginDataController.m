//
//  LoginDataController.m
//  Appointments1
//
//  Created by brian macbride on 05/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginDataController.h"
#import "ClinicalConstants.h"

@implementation LoginDataController

@synthesize loginDataDelegate = _loginDataDelegate;

- (void)checkLogin:(NSString *)username withPassword:(NSString *)password at:(NSString*)strUrl;
{
    NSDictionary* requestData = [NSDictionary dictionaryWithObjectsAndKeys:
                                 username, @"Username",
                                 password, @"Password",
                                 nil];
    
    NSDictionary* jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:requestData, @"loginData", nil];
    
    NSData *jsonData = nil;
    NSString *jsonString = nil;
    
    if([NSJSONSerialization isValidJSONObject:jsonDictionary])
    {
        jsonData = [NSJSONSerialization dataWithJSONObject:requestData options:0 error:nil];
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSString *urlString = [strUrl stringByAppendingString:@"CheckPatient"];
    NSURL * url = [NSURL URLWithString:urlString];    
    NSMutableURLRequest *request= [NSMutableURLRequest requestWithURL:url 
                                                          cachePolicy:NSURLRequestUseProtocolCachePolicy 
                                                      timeoutInterval:kConnectionTimeout];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setValue:jsonString forHTTPHeaderField:@"json"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:jsonData];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] 
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                               [self responseHandler:response Data:data Error:error];
                           }];
}

-(void)responseHandler:(NSURLResponse*)response Data:(NSData*)data Error:(NSError*)error
{
    LoginData *loginData = [[LoginData alloc] init];
    if (error != nil){
        loginData.error = [error localizedDescription];
        [[self loginDataDelegate] didFailLogin:self withLogin:loginData];
    }
    else if ([data length] == 0){
        loginData.error = @"No response from surgery";
        [[self loginDataDelegate] didFailLogin:self withLogin:loginData];
    }
    else if ([data length] > 0 && error == nil) {
        NSError* jsonError;
        NSDictionary* requestData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        
        loginData.patID = [NSNumber numberWithInteger:[[requestData objectForKey:@"PatID"] integerValue]];
        loginData.practiceCode = [requestData objectForKey:@"PracticeCode"];
        loginData.patientID = [requestData objectForKey:@"PatientID"];
        loginData.premise = [requestData objectForKey:@"Premise"];
        loginData.isAppointments = [[requestData objectForKey:@"IsAppointments"] boolValue];
        loginData.isRepeats = [[requestData objectForKey:@"IsRepeats"] boolValue];
        loginData.isTests = [[requestData objectForKey:@"IsTests"] boolValue];
        loginData.bookings = (NSNumber*)[requestData objectForKey:@"Bookings"];
        loginData.messages = (NSNumber*)[requestData objectForKey:@"NewMessages"];
        loginData.error = [requestData objectForKey:@"Error"];

        if ([loginData.error isEqualToString:@""]){
            [[self loginDataDelegate] didCheckLogin:self withLogin:loginData];
        }
        else {
            [[self loginDataDelegate] didFailLogin:self withLogin:loginData];
        }
    }
}

@end
