//
//  StaffFreeDataController.h
//  Appointments1
//
//  Created by brian macbride on 07/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppointmentData.h"
#import "ClinicalConstants.h"

@class StaffFreeDataController;

@protocol StaffFreeDataControllerDelegate <NSObject>
- (void)staffFreeDataControllerDidFinish;
- (void)staffFreeDataControllerHadError;
@end

@interface StaffFreeDataController : NSObject

@property (nonatomic, strong) NSString* urlStr;

@property (strong, nonatomic) NSMutableArray * staffFreeArray;
@property (weak, nonatomic) id <StaffFreeDataControllerDelegate> staffFreeDataDelegate;

- (void)getAppointmentStaff:(AppointmentData*)appointmentData;

@end
