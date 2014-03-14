//
//  StaffFreeDataController.m
//  Appointments1
//
//  Created by brian macbride on 07/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StaffFreeDataController.h"

@implementation StaffFreeDataController

@synthesize staffFreeArray = _staffFreeArray;
@synthesize staffFreeDataDelegate = _staffFreeDataDelegate;
@synthesize urlStr = _urlStr;

- (id)init {
    if (self = [super init]) {
        [self initialiseStaffFreeArray];
    }
    return self;
}

- (void)initialiseStaffFreeArray {
    NSMutableArray *staffFreeArray = [[NSMutableArray alloc] init];
    self.staffFreeArray = staffFreeArray;
}

- (void)addStaff:(NSString *)strStaff {
    [self.staffFreeArray addObject:strStaff];
}

/**
- (void)getAppointmentStaff:(Appointment*)appointment
{
    NSDictionary* requestData = [NSDictionary dictionaryWithObjectsAndKeys:
                                 appointment.PracticeCode, @"PracticeCode",
                                 appointment.EventDate, @"EventDate",
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
    
    NSString *urlString = [self.urlStr stringByAppendingString:@"GetAppointmentStaff"];
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
            [self addStaff:@"No clinicians found"];
        }
        else {
            if ([[requestData objectAtIndex:0] isEqualToString:@"error"]){
                isError = YES;
                [self addStaff:@"Request failed"];
            }
        }
        
        if (isError){
            if ([requestData count] > 1){
                [self addStaff:[requestData objectAtIndex:1]];
            }
            [[self staffFreeDataDelegate] staffFreeDataControllerHadError];
        }
        else {
            for (NSString* staff in requestData) {
                [self addStaff:staff];
            }
            [[self staffFreeDataDelegate] staffFreeDataControllerDidFinish];
        }
    }
    else if ([data length] == 0 && error == nil){
        [self addStaff:@"No clinicians found"];
        [[self staffFreeDataDelegate] staffFreeDataControllerHadError];
    }
    else if (error != nil){
        [self addStaff:[error localizedDescription]];
        [[self staffFreeDataDelegate] staffFreeDataControllerHadError];
    }
}
**/
@end
