//
//  Router.m
//  Online Services App
//
//  Created by Lee Daniel on 06/02/2014.
//  Copyright (c) 2014 Lee Daniel. All rights reserved.
//

#import "Router.h"

@interface Router()

@end

@implementation Router

+ (Router *)sharedRouter {
    static Router *_sharedRouter = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedRouter = [[self alloc] init];
    });
    
    return _sharedRouter;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        //_server_url = @"https://mobile.bluebaymedicalsystems.com";
        _server_url = @"http://leedanielpc.bluebaymedical.co.uk/GatewayHub/";
    }
    return self;
}

@end
