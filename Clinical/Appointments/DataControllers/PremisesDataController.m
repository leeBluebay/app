//
//  PremisesDataController.m
//  Appointments1
//
//  Created by brian macbride on 08/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PremisesDataController.h"

@implementation PremisesDataController

@synthesize premisesArray = _premisesArray;
@synthesize premisesDataDelegate = _premisesDataDelegate;
@synthesize urlStr = _urlStr;

- (id)init {
    if (self = [super init]) {
        [self initialisePremisesArray];
    }
    return self;
}

- (id)initWithArray:(NSArray*)premisesArray {
    self = [self init];

    if (self){
        for (NSString* strPremise in premisesArray) {
            [self addPremise:strPremise];
        }
    }

    return self;
}

- (void)initialisePremisesArray {
    NSMutableArray *premisesArray = [[NSMutableArray alloc] init];
    self.premisesArray = premisesArray;
}

- (void)addPremise:(NSString *)strPremise {
    [self.premisesArray addObject:strPremise];
}
/**
- (void)getPremises:(Appointment *)appointment
{
    NSDictionary* requestData = [NSDictionary dictionaryWithObjectsAndKeys:
                                 appointment.PracticeCode, @"PracticeCode",
                                 nil];
    
    NSData *jsonData = nil;
    NSString *jsonString = nil;
    
    if([NSJSONSerialization isValidJSONObject:requestData])
    {
        jsonData = [NSJSONSerialization dataWithJSONObject:requestData options:0 error:nil];
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSString *urlString = [self.urlStr stringByAppendingString:@"GetAppointmentPremises"];
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
        
        if ([requestData count] == 0){
            [[self premisesDataDelegate] premisesDataControllerIsEmpty];
        }
        else if ([[requestData objectAtIndex:0] isEqualToString:@"error"]){
            [[self premisesDataDelegate] premisesDataControllerHadError:@"Request failed"];
        }
        else {
            for (NSString* premise in requestData) {
                [self addPremise:premise];
            }
            [[self premisesDataDelegate] premisesDataControllerDidFinish];
        }
    }
    else if ([data length] == 0 && error == nil){
        [[self premisesDataDelegate] premisesDataControllerHadError:@"No premises found"];
    }
    else if (error != nil){
        [[self premisesDataDelegate] premisesDataControllerHadError:[error localizedDescription]];
    }
}
**/
@end
