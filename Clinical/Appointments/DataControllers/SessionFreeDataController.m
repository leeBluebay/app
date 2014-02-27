//
//  SessionFreeDataController.m
//  Appointments1
//
//  Created by brian macbride on 08/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SessionFreeDataController.h"

@implementation SessionFreeDataController

@synthesize sessionFreeArray = _sessionFreeArray;
@synthesize sessionFreeDataDelegate = _sessionFreeDataDelegate;
@synthesize urlStr = _urlStr;

- (id)init {
    if (self = [super init]) {
        [self initialiseSessionFreeArray];
    }
    return self;
}

- (void)initialiseSessionFreeArray {
    NSMutableArray *sessionFreeArray = [[NSMutableArray alloc] init];
    self.sessionFreeArray = sessionFreeArray;
}

- (void)addSession:(NSString *)strSession {
    [self.sessionFreeArray addObject:strSession];
}

- (void)getAppointmentSessions:(AppointmentData*)appointmentData
{
    NSDictionary* requestData = [NSDictionary dictionaryWithObjectsAndKeys:
                                 appointmentData.practiceCode, @"PracticeCode",
                                 appointmentData.premise, @"Premise",
                                 nil];
    
    NSData *jsonData = nil;
    NSString *jsonString = nil;
    
    if([NSJSONSerialization isValidJSONObject:requestData])
    {
        jsonData = [NSJSONSerialization dataWithJSONObject:requestData options:0 error:nil];
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSString *urlString = [self.urlStr stringByAppendingString:@"GetAppointmentSessions"];
    NSURL *url = [NSURL URLWithString:urlString];    
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
    if ([data length] > 0 && error == nil) {
        NSError* jsonError;
        NSArray* requestData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        
        BOOL isError = NO;
        if ([requestData count] == 0){
            isError = YES;
            [self addSession:@"No sessions found"];
        }
        else {
            if ([[requestData objectAtIndex:0] isEqualToString:@"error"]){
                isError = YES;
                [self addSession:@"Request failed"];
            }
        }
        
        if (isError){
            if ([requestData count] > 1){
                [self addSession:[requestData objectAtIndex:1]];
            }
            [[self sessionFreeDataDelegate] sessionFreeDataControllerHadError];
        }
        else {
            for (NSString* session in requestData) {
                [self addSession:session];
            }
            [[self sessionFreeDataDelegate] sessionFreeDataControllerDidFinish];
        }
    }
    else if ([data length] == 0 && error == nil){
        [self addSession:@"No sessions found"];
        [[self sessionFreeDataDelegate] sessionFreeDataControllerHadError];
    }
    else if (error != nil){
        [self addSession:[error localizedDescription]];
        [[self sessionFreeDataDelegate] sessionFreeDataControllerHadError];
    }
}

@end
