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

@end
