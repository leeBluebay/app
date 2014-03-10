//
//  Appointment.m
//  Clinical
//
//  Created by Lee Daniel on 03/03/2014.
//
//

#import "Appointment.h"

@implementation Appointment

+ (Appointment*) convertFromNsDictionary:(NSDictionary *) appointmentDictionary
{
    Appointment *appointment = [[Appointment alloc] init];
    
    if([appointmentDictionary objectForKey:@"PracticePatientId"] != nil)
        appointment.PracticePatientId = [appointmentDictionary valueForKey:@"PracticePatientId"];
   
    if([appointmentDictionary objectForKey:@"PracticeCode"] != nil)
        appointment.PracticeCode = [appointmentDictionary valueForKey:@"PracticeCode"];
    
    if([appointmentDictionary objectForKey:@"EventDate"] != nil)
        appointment.EventDate = [appointmentDictionary valueForKey:@"EventDate"];
    
    if([appointmentDictionary objectForKey:@"EventTime"] != nil)
        appointment.EventTime = [appointmentDictionary valueForKey:@"EventTime"];
    
    if([appointmentDictionary objectForKey:@"StaffId"] != nil)
        appointment.StaffId = [appointmentDictionary valueForKey:@"StaffId"];
    
    if([appointmentDictionary objectForKey:@"Session"] != nil)
        appointment.Session = [appointmentDictionary valueForKey:@"Session"];
    
    if([appointmentDictionary objectForKey:@"Location"] != nil)
        appointment.Location = [appointmentDictionary valueForKey:@"Location"];
    
    return appointment;
}

+ (NSMutableArray*) convertFromJsonList:(NSString *) jsonData
{
    NSData *nsData = [jsonData dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableArray *json = [NSJSONSerialization JSONObjectWithData:nsData options:0 error:nil];
    
    NSMutableArray *appointments = [[NSMutableArray alloc] init];
    
    for (NSDictionary *appointmentDictionary in json)
    {
        Appointment *appointment = [Appointment convertFromNsDictionary:appointmentDictionary];
        [appointments addObject:appointment];
    }
    
    return appointments;
}


@end
