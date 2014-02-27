//
//  MessagesDataController.m
//  Clinical
//
//  Created by BlueBay Medical Systems on 23/11/2012.
//
//

#import "MessagesDataController.h"

@interface MessagesDataController ()
    @property (strong, nonatomic) NSMutableArray * messagesArray;
@end

@implementation MessagesDataController

@synthesize messagesArray = _messagesArray;
@synthesize messagesDataDelegate = _messagesDataDelegate;

- (id)init {
    if (self = [super init]) {
        [self initialiseMessagesArray];
    }
    return self;
}

- (void)initialiseMessagesArray {
    NSMutableArray *messagesArray = [[NSMutableArray alloc] init];
    self.messagesArray = messagesArray;
}

-(NSInteger)messageCount
{
    return (NSInteger)[self.messagesArray count];
}

-(MessageData*)messageAtIndex:(NSInteger)index
{
    return [self.messagesArray objectAtIndex:(NSUInteger)index];
}

-(void)removeMessageAtIndex:(NSInteger)index
{
    [self.messagesArray removeObjectAtIndex:(NSUInteger)index];
}

- (MessageData*)addMessage:(NSString *)strMessage {
    MessageData *messData = [[MessageData alloc] init];
    messData.messageID = strMessage;
    
    [self.messagesArray addObject:messData];

    return messData;
}

-(NSUInteger)newMessageCount
{
    NSUInteger count = 0;
    for (MessageData* messData in self.messagesArray) {
        if (!messData.read) {
            count++;
        }
    }
    
    return count;
}

-(NSDate *) normalisedDate {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [gregorian setTimeZone:[NSTimeZone localTimeZone]];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | kCFCalendarUnitWeekday | kCFCalendarUnitWeekdayOrdinal fromDate:[NSDate date]];
    
    NSDateComponents *normalised = NSDateComponents.alloc.init;
    [normalised setWeekday: [components weekday]];
    [normalised setWeekdayOrdinal:[components weekdayOrdinal]];
    [normalised setMonth:[components month]];
    [normalised setYear:[components year]];
    
    return [gregorian dateFromComponents:normalised];
}

- (void)getPatientMessages: (MessageData*)messageData;
{
    NSDictionary* requestData = [NSDictionary dictionaryWithObjectsAndKeys:
                                 messageData.practiceCode, @"PracticeCode",
                                 messageData.patID, @"PatID",
                                 nil];
    
    NSData *jsonData = nil;
    NSString *jsonString = nil;
    
    if([NSJSONSerialization isValidJSONObject:requestData])
    {
        jsonData = [NSJSONSerialization dataWithJSONObject:requestData options:0 error:nil];
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSString *urlString = [messageData.url stringByAppendingString:@"GetPatientMessages"];
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
    if ([data length] > 0 && error == nil) {
        NSError* jsonError;
        NSArray *requestData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];

        if (error != nil){
            [self addMessage:[error localizedDescription]];
            [[self messagesDataDelegate] messagesDataControllerHadError];
        }
        else if (([data length] == 0) || ([requestData count] == 0)) {
            [self addMessage:@"No messages found"];
            [[self messagesDataDelegate] messagesDataControllerHadError];
        }
        else {
            MessageData *messData;
            NSDictionary *message = [requestData objectAtIndex:0];
            NSString *strError = [message objectForKey:@"Title"];
            if ([strError isEqualToString:@"error"]){
                messData = [self addMessage:[message objectForKey:@"MessageID"]];
                messData.body = [message objectForKey:@"Body"];
                [[self messagesDataDelegate] messagesDataControllerHadError];
            }
            else {
                for (message in requestData) {
                    messData = [self addMessage:[message objectForKey:@"MessageID"]];
                    messData.practiceCode = [message objectForKey:@"PracticeCode"];
                    messData.patID = [message objectForKey:@"PatID"];
                    messData.title = [message objectForKey:@"Title"];
                    messData.from = [message objectForKey:@"From"];
                    messData.read = [[message objectForKey:@"Read"] boolValue];
                    
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"]];
                    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
                    NSString *sentStr = [message objectForKey:@"Sent"];
                    NSDate *sentDate = [dateFormatter dateFromString:sentStr];
                    NSDate *todayDate = [self normalisedDate];
                    
                    NSTimeInterval elapsed = [sentDate timeIntervalSinceDate:todayDate];
                    if (elapsed > 0)
                        [dateFormatter setDateFormat:@"EEE dd MMM yyyy HH:mm"];
                    else
                        [dateFormatter setDateFormat:@"EEE dd MMM yyyy"];
                    
                    messData.sent = [dateFormatter stringFromDate:sentDate];
                }
                [[self messagesDataDelegate] messagesDataControllerDidFinish];
            }
        }
    }
}


@end
