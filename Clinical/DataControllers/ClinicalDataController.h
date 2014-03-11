//
//  ClinicalDataController.h
//  Clinical
//
//  Created by brian macbride on 26/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthResponse.h"

@interface ClinicalDataController : NSObject

@property (strong, nonatomic) NSMutableArray *clinicalArray;
@property (strong, nonatomic) AuthResponse *authResponse;

- (id)initWithData: (AuthResponse *)passedInAuthResponse;

-(void) showNewMessages:(NSUInteger)newMessages;

@end
