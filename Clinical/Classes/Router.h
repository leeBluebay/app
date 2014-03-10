//
//  Router.h
//  Online Services App
//
//  Created by Lee Daniel on 06/02/2014.
//  Copyright (c) 2014 Lee Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Router : NSObject

@property (strong, nonatomic, readonly) NSString *server_url;
@property ( nonatomic, readonly) NSUInteger methodTimeout;

+ (Router *)sharedRouter;

@end
