//
//  AppResponse.h
//  Clinical
//
//  Created by Lee Daniel on 03/03/2014.
//
//

#import <Foundation/Foundation.h>

@interface AppResponse : NSObject

@property (strong, nonatomic) NSString *JData;
@property (strong, nonatomic) NSString *Ticket;
@property (strong, nonatomic) NSString *CallbackMethod;
@property (strong, nonatomic) NSString *CallerConnectionId;
@property  bool IsError;
@property (strong, nonatomic) NSString *Error;

+ (AppResponse*)convertFromJson:(NSString *) jsonData;

//@property (strong, nonatomic) NSDictionary * jObject;

- (NSDictionary*) jObject;

@end
