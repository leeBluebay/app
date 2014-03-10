//
//  AuthResponse.h
//  Online Services App
//
//  Created by Lee Daniel on 26/02/2014.
//  Copyright (c) 2014 Lee Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Patient.h"

@interface AuthResponse : NSObject

@property (nonatomic, assign) NSInteger Status;
@property (nonatomic, assign) bool Success;
@property (strong, nonatomic) NSString *Ticket;
@property (strong, nonatomic) NSString *CallerConnectionId;

@property (strong, nonatomic) Patient *Patient;
@property (strong, nonatomic) NSMutableArray *PatientMessages;


+ (AuthResponse*)convertFromJson:(NSString *) jsonData;

@end
