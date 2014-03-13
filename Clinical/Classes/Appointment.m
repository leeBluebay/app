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

- (NSString*) toJsonString;

{
    NSMutableDictionary *appJson = [[NSMutableDictionary alloc]init];
   
    if(!IsEmpty(self.PracticePatientId ))
    {
        [appJson setObject:self.PracticePatientId  forKey: @"PracticePatientId"];
    }
    
    if(!IsEmpty(self.PracticeCode ))
    {
         [appJson setObject:self.PracticeCode  forKey: @"PracticeCode"];
    }
    
    if(!IsEmpty(self.EventDate ))
    {
        [appJson setObject:self.EventDate  forKey: @"EventDate"];
    }
    
    if(!IsEmpty(self.EventTime ))
    {
        [appJson setObject:self.EventTime  forKey: @"EventTime"];
    }
    
    if(!IsEmpty(self.StaffId ))
    {
        [appJson setObject:self.StaffId  forKey: @"StaffId"];
    }
    
    if(!IsEmpty(self.Session ))
    {
        [appJson setObject:self.Session  forKey: @"Session"];
    }
    
    if(!IsEmpty(self.Location ))
    {
        [appJson setObject:self.Location  forKey: @"Location"];
    }
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:appJson
                                                       options:0
                                                         error:&error];
    
    NSString *json;
    
    if (jsonData)
    {
        json = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];;
    }
    
    return json;
}

@end
