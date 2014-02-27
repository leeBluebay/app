//
//  BookingsDataController.m
//  Appointments1
//
//  Created by brian macbride on 08/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BookingsDataController.h"

@interface BookingsDataController()
@property (nonatomic, strong) NSMutableArray *infoArray;
@property (nonatomic, strong) NSMutableArray * bookingsArray;
@end

@implementation BookingsDataController

@synthesize bookingsArray = _bookingsArray;
@synthesize infoArray = _infoArray;

- (id)init {
    if (self = [super init]) {
        [self initialiseInfoArray];
        [self initialiseBookingsArray];
    }
    return self;
}

- (void)initialiseBookingsArray {
    NSMutableArray * bookingsArray = [[NSMutableArray alloc] init];
    self.bookingsArray = bookingsArray;
}

- (void)addBooking:(NSString *)slot onDate:(NSString *)date forSession:(NSString *)session
withStaff:(NSString *)staff
{
    AppointmentData *appointmentData = [[AppointmentData alloc] init];
    appointmentData.slot = slot;
    appointmentData.appointmentDate = date;
    appointmentData.session = session;
    appointmentData.staff = staff;
    
    [self.bookingsArray addObject:appointmentData];
}

- (void) clearBookings {
    [self.bookingsArray removeAllObjects];
}

- (void)initialiseInfoArray {
    NSMutableArray * infoArray = [[NSMutableArray alloc] init];
    self.infoArray = infoArray;
}

- (void)addInfo:(NSString *)info
{
    AppointmentData *appointmentData = [[AppointmentData alloc] init];
    appointmentData.staff = info;
    
    [self.infoArray addObject:appointmentData];
}

- (void) clearInfo {
    [self.infoArray removeAllObjects];
}

-(NSInteger)bookingsCount 
{
    return (NSInteger)[self.bookingsArray count];
}

-(AppointmentData*)bookingAtIndex:(NSInteger)index
{
    return [self.bookingsArray objectAtIndex:(NSUInteger)index];
}

-(void)removeBookingAtIndex:(NSInteger)index
{
    [self.bookingsArray removeObjectAtIndex:(NSUInteger)index];
}

-(NSInteger)infoCount 
{
    return (NSInteger)[self.infoArray count];
}

-(AppointmentData*)infoAtIndex:(NSInteger)index
{
    return [self.infoArray objectAtIndex:(NSUInteger)index];
}

@end
