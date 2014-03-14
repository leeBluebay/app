//
//  Appointment.h
//  Clinical
//
//  Created by Lee Daniel on 03/03/2014.
//
//

#import <Foundation/Foundation.h>
#import "ObjectHelper.h"
#import "AppResponse.h"

@interface Appointment : NSObject

@property (nonatomic, copy) NSString* PracticePatientId;
@property (nonatomic, copy) NSString* PracticeCode;
@property (nonatomic, copy) NSString* EventDate;
@property (nonatomic, copy) NSString* EventTime;
@property (nonatomic, copy) NSString* StaffId;
@property (nonatomic, copy) NSString* Session;
@property (nonatomic, copy) NSString* Location;

+ (Appointment*) convertFromNsDictionary:(NSDictionary *) appointmentDictionary;
+ (NSMutableArray*) convertFromJsonList:(NSString *) jsonData;
+ (NSMutableArray*) convertFromAppResponse:(AppResponse *) appResponse;

- (NSString*) toJsonString;

@end
