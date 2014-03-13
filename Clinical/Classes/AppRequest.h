//
//  AppRequest.h
//  Clinical SignalR
//
//  Created by Lee Daniel on 12/03/2014.
//
//

#import <Foundation/Foundation.h>

@interface AppRequest : NSObject

@property (strong, nonatomic) NSString *Ticket;
@property (strong, nonatomic) NSObject *Data;

@end
