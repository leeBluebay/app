//
//  DatesFreeDataController.m
//  Appointments1
//
//  Created by brian macbride on 07/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DatesFreeDataController.h"

@implementation DatesFreeDataController

@synthesize datesFreeArray = _datesFreeArray;
@synthesize datesFreeDataDelegate = _datesFreeDataDelegate;

- (id)init {
    if (self = [super init]) {
        [self initialiseDatesFreeArray];
    }
    return self;
}

- (void)initialiseDatesFreeArray {
    NSMutableArray *datesFreeArray = [[NSMutableArray alloc] init];
    self.datesFreeArray = datesFreeArray;
}

- (void)addDate:(NSString *)strDate {
    [self.datesFreeArray addObject:strDate];
}

/**
- (void)getAppointmentDates:(Appointment*)appointment
{
    NSDictionary* requestData = [NSDictionary dictionaryWithObjectsAndKeys:
                                 appointment.PracticeCode, @"PracticeCode",
                                 appointment.StaffId, @"StaffID",
                                 appointment.Session, @"Session",
                                 appointment.Location, @"Premise",
                                 nil];
    
    NSData *jsonData = nil;
    NSString *jsonString = nil;
    
    if([NSJSONSerialization isValidJSONObject:requestData])
    {
        jsonData = [NSJSONSerialization dataWithJSONObject:requestData options:0 error:nil];
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSString *urlString = [self.urlStr stringByAppendingString:@"GetAppointmentDates"];

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
    if ([data length] > 0 && error == nil) {
        NSError* jsonError;
        NSArray* requestData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];

        BOOL isError = NO;
        if ([requestData count] == 0){
            isError = YES;
            [self addDate:@"No dates found"];
        }
        else {
            if ([[requestData objectAtIndex:0] isEqualToString:@"error"]){
                isError = YES;
                [self addDate:@"Request failed"];
            }
        }
        
        if (isError){
            if ([requestData count] > 1){
                [self addDate:[requestData objectAtIndex:1]];
            }
            [[self datesFreeDataDelegate] datesFreeDataControllerHadError];
        }
        else {
            for (NSString* date in requestData) {
                [self addDate:date];
            }
            [[self datesFreeDataDelegate] datesFreeDataControllerDidFinish];
        }
    }
    else if ([data length] == 0 && error == nil){
        [self addDate:@"No dates found"];
        [[self datesFreeDataDelegate] datesFreeDataControllerHadError];
    }
    else if (error != nil){
        [self addDate:[error localizedDescription]];
        [[self datesFreeDataDelegate] datesFreeDataControllerHadError];
    }
}
**/
@end
