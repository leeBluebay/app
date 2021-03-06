//
//  LoginDataController.h
//  Appointments1
//
//  Created by brian macbride on 05/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginDataController.h"
#import "LoginData.h"

@class LoginDataController;

@protocol LoginDataControllerDelegate <NSObject>
- (void) didCheckLogin:(LoginDataController *)controller withLogin:(LoginData*)loginData;
- (void) didFailLogin:(LoginDataController *)controller withLogin:(LoginData*)loginData;
@end

@interface LoginDataController : NSObject

@property (weak, nonatomic) id <LoginDataControllerDelegate> loginDataDelegate;

- (void)checkLogin:(NSString *)username withPassword:(NSString*)password at:(NSString*)strUrl;

@end
