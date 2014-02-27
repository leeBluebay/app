//
//  PatientMessage.m
//  Online Services App
//
//  Created by Lee Daniel on 26/02/2014.
//  Copyright (c) 2014 Lee Daniel. All rights reserved.
//

#import "PatientMessage.h"

@implementation PatientMessage

+ (PatientMessage*)convertFromNsDictionary:(NSDictionary *) messageJson
{
    PatientMessage *message = [[PatientMessage alloc] init];
    
    
    if([messageJson objectForKey:@"PatientId"] != nil)
        message.PatientId = [[messageJson valueForKey:@"PatientId"] intValue];
    
    if([messageJson objectForKey:@"PracticeCode"] != nil)
        message.PracticeCode = [messageJson valueForKey:@"PracticeCode"];
    
    if([messageJson objectForKey:@"MessageId"] != nil)
        message.MessageId = [[messageJson valueForKey:@"MessageId"] intValue];
    
    if([messageJson objectForKey:@"Title"] != nil)
        message.Title = [messageJson valueForKey:@"Title"];
    
    if([messageJson objectForKey:@"Body"] != nil)
        message.Body = [messageJson valueForKey:@"Body"];
    
    if([messageJson objectForKey:@"Sent"] != nil)
        message.Sent = [messageJson valueForKey:@"Sent"];
    
    if([messageJson objectForKey:@"From"] != nil)
        message.From = [messageJson valueForKey:@"From"];
    
    if([messageJson objectForKey:@"Read"] != nil)
        message.Read = [[messageJson valueForKey:@"Read"] boolValue];
    
    if([messageJson objectForKey:@"Attachments"] != nil)
        message.Attachments = [[messageJson valueForKey:@"Attachments"] intValue];
    
    if([messageJson objectForKey:@"MessageCount"] != nil)
        message.MessageCount = [[messageJson valueForKey:@"MessageCount"] intValue];
    
    if([messageJson objectForKey:@"NewOnly"] != nil)
        message.NewOnly = [[messageJson valueForKey:@"NewOnly"] boolValue];
    
    if([messageJson objectForKey:@"SentFormatted"] != nil)
        message.SentFormatted = [messageJson valueForKey:@"SentFormatted"];
    
    return message;
}

+ (NSMutableArray*)convertFromJsonArray:(NSMutableArray *) messagesJson
{
    NSMutableArray *messages = [[NSMutableArray alloc] init];
    
    for (NSDictionary *message in messagesJson)
    {
        PatientMessage *patientMessage = [PatientMessage convertFromNsDictionary:message];
        [messages addObject:patientMessage];
    }
    
    return messages;
}

@end
