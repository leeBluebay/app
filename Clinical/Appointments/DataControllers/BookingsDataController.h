//
//  BookingsDataController.h
//  Appointments1
//
//  Created by brian macbride on 08/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppointmentData.h"

@interface BookingsDataController : NSObject

-(void) clearBookings;
- (void)addBooking:(NSString *)slot onDate:(NSString*)date forSession:(NSString*)session
         withStaff:(NSString*)staff;

-(void) clearInfo;
- (void)addInfo:(NSString *)info;

-(NSInteger)bookingsCount;
-(AppointmentData*)bookingAtIndex:(NSInteger)index;
-(void)removeBookingAtIndex:(NSInteger)index;
-(NSInteger)infoCount;
-(AppointmentData*)infoAtIndex:(NSInteger)index;

@end
