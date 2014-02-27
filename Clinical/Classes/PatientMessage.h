//
//  PatientMessage.h
//  Online Services App
//
//  Created by Lee Daniel on 26/02/2014.
//  Copyright (c) 2014 Lee Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PatientMessage : NSObject

@property (nonatomic, assign) NSInteger PatientId;
@property (strong, nonatomic) NSString *PracticeCode;
@property (nonatomic, assign) NSInteger MessageId;
@property (strong, nonatomic) NSString *Title;
@property (strong, nonatomic) NSString *Body;
@property (strong, nonatomic) NSString *Sent;
@property (strong, nonatomic) NSString *From;
@property (nonatomic, assign) BOOL Read;
@property (nonatomic, assign) NSUInteger Attachments;
@property (nonatomic, assign) NSUInteger MessageCount;
@property (nonatomic, assign) BOOL NewOnly;
@property (strong, nonatomic) NSString *SentFormatted;

+ (PatientMessage*)convertFromNsDictionary:(NSDictionary *) messageJson;

+ (NSMutableArray*)convertFromJsonArray:(NSDictionary *) messagesJson;

@end
