//
//  RequestDataAccess.m
//  Appointments1
//
//  Created by brian macbride on 14/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RequestDataAccess.h"

@interface RequestDataAccess()
    @property (nonatomic, strong) NSString* fileVersion;
@end

@implementation RequestDataAccess

NSMutableData* receivedData;

@synthesize fileVersion;
@synthesize requestDataDelegate = _requestDataDelegate;
@synthesize urlStr = _urlStr;

- (id)init {
    if (self = [super init]) {
        self.fileVersion = @"2014.1";
    }
    return self;
}

-(NSString*)getAppointmentEventData:(Appointment*)appointment
{
    NSDictionary* dicEventData = [NSDictionary dictionaryWithObjectsAndKeys:
                                  appointment.Session, @"ses",
                                  appointment.StaffId, @"stf",
                                  appointment.EventDate, @"ad",
                                  appointment.EventTime, @"slt",
                                  appointment.Location, @"prm",
                                  nil];
    
    NSData *jsonEventData = [NSJSONSerialization dataWithJSONObject:dicEventData options:0 error:nil];
    NSString *eventData = [[NSString alloc]initWithData:jsonEventData encoding:NSUTF8StringEncoding];
    
    return eventData;
}

- (void)setRequest:(RequestData*)requestData
{
    NSDictionary* requestArray = [NSDictionary dictionaryWithObjectsAndKeys:
                                 requestData.practiceCode, @"PracticeCode",
                                 requestData.patientID, @"PatientID",
                                 requestData.requestType, @"RequestType",
                                 self.fileVersion, @"FileVersion",
                                 requestData.eventData, @"EventData",
                                 nil];
    
    NSData *jsonData = nil;
    NSString *jsonString = nil;
    
    if([NSJSONSerialization isValidJSONObject:requestArray])
    {
        jsonData = [NSJSONSerialization dataWithJSONObject:requestArray options:0 error:nil];
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSString *urlString = [self.urlStr stringByAppendingString:@"setRequest"];
    NSURL * url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url 
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy 
                                                       timeoutInterval:kConnectionTimeout];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setValue:jsonString forHTTPHeaderField:@"json"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:jsonData];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] 
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                               [self setRequestHandler:response Data:data Error:error];
                           }];
}

-(void)setRequestHandler:(NSURLResponse*)response Data:(NSData*)data Error:(NSError*)error
{
    if ([data length] > 0 && error == nil) {
        NSError* jsonError;
        NSDictionary* requestData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        NSString* strError = [requestData objectForKey:@"Error"];
        
        if ([strError isEqualToString:@""]){
            [[self requestDataDelegate] didSetRequest];
        }
        else {
            [[self requestDataDelegate] setRequestError:strError];
        }
    }
    else if (error != nil){
        [[self requestDataDelegate] setRequestError:[error localizedDescription]];
    }
    else if ([data length] == 0){
        [[self requestDataDelegate] setRequestError:@"No response from host server"];
    }
}


- (void)getRequest: (RequestData*)requestData
{
    NSDictionary* requestArray = [NSDictionary dictionaryWithObjectsAndKeys:
                                 requestData.practiceCode, @"PracticeCode",
                                 requestData.patientID, @"PatientID",
                                 requestData.requestType, @"RequestType",
                                 nil];
    
    NSData *jsonData = nil;
    NSString *jsonString = nil;
    
    if([NSJSONSerialization isValidJSONObject:requestArray])
    {
        jsonData = [NSJSONSerialization dataWithJSONObject:requestArray options:0 error:nil];
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSString *urlString = [self.urlStr stringByAppendingString:@"getRequest"];
    NSURL * url = [NSURL URLWithString:urlString];    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url 
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy 
                                                       timeoutInterval:kConnectionTimeout];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setValue:jsonString forHTTPHeaderField:@"json"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:jsonData];
    
    // create the connection with the request and start load
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (theConnection) {
        // create a placeholder for the data
        receivedData=[NSMutableData data];
    } 
    else {
        // Handle the situation that the connection failed
        NSString* strError = @"Unable to create a connection to the internet";
        [[self requestDataDelegate] getRequestError:strError];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    [[self requestDataDelegate] didGetRequest:receivedData];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSString* strError = [error localizedDescription];
    [[self requestDataDelegate] getRequestError:strError];
}

-(NSCachedURLResponse *)connection:(NSURLConnection *)connection
                 willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    // prevent the data from being cached
    return nil;
}

- (void)delRequest:(RequestData*)requestData
{
    NSDictionary* requestArray = [NSDictionary dictionaryWithObjectsAndKeys:
                                 requestData.practiceCode, @"PracticeCode",
                                 requestData.patientID, @"PatientID",
                                 @"0", @"RequestType",
                                 nil];
    
    NSData *jsonData = nil;
    NSString *jsonString = nil;
    
    if([NSJSONSerialization isValidJSONObject:requestArray])
    {
        jsonData = [NSJSONSerialization dataWithJSONObject:requestArray options:0 error:nil];
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSString *urlString = [self.urlStr stringByAppendingString:@"delRequest"];
    NSURL * url = [NSURL URLWithString:urlString];    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url 
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy 
                                                       timeoutInterval:kConnectionTimeout];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setValue:jsonString forHTTPHeaderField:@"json"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:jsonData];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                           }];
}

@end
