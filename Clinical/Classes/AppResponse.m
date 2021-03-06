//
//  AppResponse.m
//  Clinical
//
//  Created by Lee Daniel on 03/03/2014.
//
//

#import "AppResponse.h"

@implementation AppResponse



+ (AppResponse*)convertFromJson:(NSString *) jsonData
{
    
    NSData *nsData = [jsonData dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:nsData options:0 error:nil];
    
    AppResponse *authResponse = [[AppResponse alloc] init];
    
    if([json objectForKey:@"CallbackMethod"] != nil)
        authResponse.CallbackMethod =  [json valueForKey:@"CallbackMethod"];
    
    if([json objectForKey:@"Ticket"] != nil)
        authResponse.Ticket =  [json valueForKey:@"Ticket"];
    
    if([json objectForKey:@"JData"] != nil)
        authResponse.JData =  [json valueForKey:@"JData"];
    
    if([json objectForKey:@"CallerConnectionId"] != nil)
        authResponse.CallerConnectionId =  [json valueForKey:@"CallerConnectionId"];
    
    if([json objectForKey:@"IsError"] != nil)
        authResponse.IsError =  [[json valueForKey:@"IsError"] boolValue];
    
    if([json objectForKey:@"Error"] != nil)
        authResponse.Error =  [json valueForKey:@"Error"];
    
    return authResponse;
}


- (NSDictionary*) jObject
{
    if(self.JData == nil)
    {
        return nil;
    }
    
    NSData *nsData = [self.JData dataUsingEncoding:NSUTF8StringEncoding];
    
    return [NSJSONSerialization JSONObjectWithData:nsData options:0 error:nil];
}

@end
