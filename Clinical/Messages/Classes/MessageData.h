//
//  MessageData.h
//  Clinical
//
//  Created by BlueBay Medical Systems on 26/11/2012.
//
//

#import <Foundation/Foundation.h>

@interface MessageData : NSObject


@property (nonatomic, copy) NSString* practiceCode;
@property (nonatomic, copy) NSString* patID;
@property (nonatomic, copy) NSString* messageID;
@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* body;
@property (nonatomic, copy) NSString* sent;
@property (nonatomic, copy) NSString* from;
@property (nonatomic) BOOL read;


@property (nonatomic, strong) NSString* url;

-(MessageData*)initWithData:(MessageData *)messageData;

@end
