//
//  MessageDataController.m
//  Clinical
//
//  Created by BlueBay Medical Systems on 27/11/2012.
//
//

#import "MessageDataController.h"

@implementation MessageDataController

@synthesize messageDataDelegate = _messageDataDelegate;


- (void)getPatientMessage: (MessageData*)messageData;
{
    NSDictionary* requestData = [NSDictionary dictionaryWithObjectsAndKeys:
                                 messageData.practiceCode, @"PracticeCode",
                                 messageData.messageID, @"MessageID",
                                 messageData.patID, @"PatID",
                                 nil];
    
    NSData *jsonData = nil;
    NSString *jsonString = nil;
    
    if([NSJSONSerialization isValidJSONObject:requestData])
    {
        jsonData = [NSJSONSerialization dataWithJSONObject:requestData options:0 error:nil];
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSString *urlString = [messageData.url stringByAppendingString:@"GetPatientMessage"];
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
    if (error != nil){
        [[self messageDataDelegate] messageDataControllerHadError:[error localizedDescription]];
    }
    else if ([data length] == 0){
        [[self messageDataDelegate] messageDataControllerHadError:@"No response from surgery"];
    }
    else if ([data length] > 0 && error == nil) {
        NSError* jsonError;
        NSDictionary* requestData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        NSString *body = [requestData objectForKey:@"Body"];
        NSString *errorStr = [requestData objectForKey:@"Error"];
        
        if ([errorStr isEqualToString:@""])
            [[self messageDataDelegate] messageDataControllerDidFinish:body];
        else
            [[self messageDataDelegate] messageDataControllerHadError:errorStr];
    }
}

- (void)deletePatientMessage: (MessageData*)messageData;
{
    NSDictionary* requestData = [NSDictionary dictionaryWithObjectsAndKeys:
                                 messageData.practiceCode, @"PracticeCode",
                                 messageData.messageID, @"MessageID",
                                 messageData.patID, @"PatID",
                                 nil];
    
    NSData *jsonData = nil;
    NSString *jsonString = nil;
    
    if([NSJSONSerialization isValidJSONObject:requestData])
    {
        jsonData = [NSJSONSerialization dataWithJSONObject:requestData options:0 error:nil];
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSString *urlString = [messageData.url stringByAppendingString:@"DeletePatientMessage"];
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
                               [self deleteHandler:response Data:data Error:error];
                           }];
}

-(void)deleteHandler:(NSURLResponse*)response Data:(NSData*)data Error:(NSError*)error
{
    if (error != nil){
        [[self messageDataDelegate] messageDataControllerHadError:[error localizedDescription]];
    }
    else if ([data length] == 0){
        [[self messageDataDelegate] messageDataControllerHadError:@"No response from surgery"];
    }
    else if ([data length] > 0 && error == nil) {
        NSError* jsonError;
        NSDictionary* requestData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        NSString *errorStr = [requestData objectForKey:@"Error"];
        
        if ([errorStr isEqualToString:@""])
            [[self messageDataDelegate] messageDataControllerDidDelete];
        else
            [[self messageDataDelegate] messageDataControllerHadError:errorStr];
    }
}


@end
