//
//  SplashScreenDataController.m
//  Clinical
//
//  Created by BlueBay Medical Systems on 11/10/2013.
//
//

#import "SplashScreenDataController.h"
#import "ClinicalConstants.h"

@implementation SplashScreenDataController

@synthesize splashScreenDataDelegate = _splashScreenDataDelegate;

- (NSString*)getUrl
{
    NSString *strUrl = @"";

    NSDictionary* requestData = [NSDictionary dictionary];
    
    NSData *jsonData = nil;
    NSString *jsonString = nil;
    
    if([NSJSONSerialization isValidJSONObject:requestData])
    {
        jsonData = [NSJSONSerialization dataWithJSONObject:requestData options:0 error:nil];
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSString *urlString = [kBaseURL stringByAppendingString:@"GetUrl"];
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

    
    return strUrl;
}

- (void)getUrlForVersion
{
    NSDictionary* requestData = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"ios", @"Platform",
                                 @"2014.1", @"FileVersion",
                                 nil];
    
    NSDictionary* jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:requestData, @"urlData", nil];
    
    NSData *jsonData = nil;
    NSString *jsonString = nil;
    
    if([NSJSONSerialization isValidJSONObject:jsonDictionary])
    {
        jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary options:0 error:nil];
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSString *urlString = [kBaseURL stringByAppendingString:@"GetUrlForVersion"];
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
    if (error != nil){
        NSString* strError = [error localizedDescription];
        [[self splashScreenDataDelegate] didFailGetUrl:strError];
    }
    else if ([data length] == 0){
        NSString* strError = @"No response from surgery";
        [[self splashScreenDataDelegate] didFailGetUrl:strError];
    }
    else if ([data length] > 0 && error == nil) {
        NSError* jsonError;
        NSDictionary* requestData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];

        NSString* strUrl = [requestData objectForKey:@"Url"];
        NSString* strError = [requestData objectForKey:@"Error"];
        
        if ([strError isEqualToString:@""]){
            [[self splashScreenDataDelegate] didGetUrl:strUrl];
        }
        else {
            [[self splashScreenDataDelegate] didFailGetUrl:strError];
        }
    }
}


@end
