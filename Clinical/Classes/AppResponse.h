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


+ (AppResponse*)convertFromJson:(NSString *) jsonData;

@end
