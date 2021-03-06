//
//  SendRequestDataController.m
//  Clinical
//
//  Created by brian macbride on 18/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SendRequestDataController.h"
#import "RepeatStatusData.h"

@implementation SendRequestDataController

@synthesize repeatsArray = _repeatsArray;
@synthesize sendRequestDataDelegate = _sendRequestDataDelegate;
@synthesize urlStr = _urlStr;

- (id)init {
    if (self = [super init]) {
        [self initialiseRepeatsArray];
    }
    return self;
}

- (void)initialiseRepeatsArray
{
    NSMutableArray *repeatsArray = [[NSMutableArray alloc] init];
    self.repeatsArray = repeatsArray;
}

- (RepeatData*) addRepeat:(NSString *)name
{
    RepeatData *repeatData = [[RepeatData alloc] init];
    repeatData.name = name;
    
    [self.repeatsArray addObject:repeatData];
    
    return repeatData;
}

-(id)initWithSelectedArray:(NSMutableArray*)repeatsArray
{
    if (self = [self init]) {
        for (RepeatStatusData *repeatStatus in repeatsArray) {
            for (RepeatData *repeat in repeatStatus.repeatsArray) {
                if (repeat.isSelected) {
                    RepeatData *repeatData = [self addRepeat:repeat.name];
                    repeatData.prescriptionID = repeat.prescriptionID;
                }
            }
        }
    }
    return self;
}

- (void)getEmailValues:(NSString *)practiceCode
{
    NSDictionary* requestData = [NSDictionary dictionaryWithObjectsAndKeys:
                                 practiceCode, @"PracticeCode",
                                 nil];
    
    NSData *jsonData = nil;
    NSString *jsonString = nil;
    
    if([NSJSONSerialization isValidJSONObject:requestData])
    {
        jsonData = [NSJSONSerialization dataWithJSONObject:requestData options:0 error:nil];
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSString *urlString = [self.urlStr stringByAppendingString:@"GetEmailValues"];
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
        NSDictionary* requestData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        
        NSString *strTo = [requestData objectForKey:@"To"];
        
        [[self sendRequestDataDelegate] didGetEmailValues:self emailTo:strTo];
    }
    else if (error != nil){
        [[self sendRequestDataDelegate] getEmailValuesError:self withError:[error localizedDescription]];
    }
    else if ([data length] == 0){
        [[self sendRequestDataDelegate] getEmailValuesError:self withError:@"unable to get email details"];
    }
}

@end
