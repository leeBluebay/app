//
//  MessageData.m
//  Clinical
//
//  Created by BlueBay Medical Systems on 26/11/2012.
//
//

#import "MessageData.h"

@implementation MessageData

@synthesize practiceCode = _practiceCode;
@synthesize patID = _patID;
@synthesize messageID = _messageID;
@synthesize title = _title;
@synthesize body = _body;
@synthesize sent = _sent;
@synthesize from = _from;
@synthesize read = _read;

-(id)init
{
    if (self = [super init]){
        _practiceCode = @"";
        _patID = 0;
        _messageID = @"";
        _title = @"";
        _body = @"";
        _sent = @"";
        _from = @"";
        _read = NO;
    }
    return self;
}

-(MessageData*)initWithData:(MessageData *)messageData
{
    if (self = [self init]) {
        _practiceCode = messageData.practiceCode;
        _patID = messageData.patID;
        _messageID = messageData.messageID;
        _title = messageData.title;
        _body = messageData.body;
        _sent = messageData.sent;
        _from = messageData.from;
        _read = messageData.read;
    }
    
    return self;
}

@end
