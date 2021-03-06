//
//  ConfirmRequestDataController.m
//  Clinical
//
//  Created by brian macbride on 18/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ConfirmRequestDataController.h"

@implementation ConfirmRequestDataController

@synthesize confirmRequestDataDelegate = _confirmRequestDataDelegate;
@synthesize urlStr = _urlStr;

- (void)sendMail:(NSString *)to forSubject:(NSString*)subject withBody:(NSString*)body
{
    NSDictionary* requestData = [NSDictionary dictionaryWithObjectsAndKeys:
                                 to, @"To",
                                 subject, @"Subject",
                                 body, @"Body",
                                 nil];
    
    NSData *jsonData = nil;
    NSString *jsonString = nil;
    
    if([NSJSONSerialization isValidJSONObject:requestData])
    {
        jsonData = [NSJSONSerialization dataWithJSONObject:requestData options:0 error:nil];
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSString *urlString = [self.urlStr stringByAppendingString:@"SendMail"];
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
    if (error == nil) {
        //if ([data length] > 0 && error == nil) {
        //NSError* jsonError;
        //NSDictionary* requestData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        
        [[self confirmRequestDataDelegate] didSendMail:self];
    }
    else if (error != nil){
        [[self confirmRequestDataDelegate] sendMailError:self withError:[error localizedDescription]];
    }
    else if ([data length] == 0){
        [[self confirmRequestDataDelegate] sendMailError:self withError:@"unable to send email"];
    }
}

@end
