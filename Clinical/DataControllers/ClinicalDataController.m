//
//  ClinicalDataController.m
//  Clinical
//
//  Created by brian macbride on 26/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ClinicalDataController.h"

@implementation ClinicalDataController

@synthesize clinicalArray = _clinicalArray;

- (id)init {
    self = [super init];

    return self;
}


- (id)initWithData: (AuthResponse*)authResponse {
    if (self = [self init]) {
        [self initialiseSearchTypeArray:authResponse];
    }
    return self;
}

-(void) showNewMessages:(NSUInteger)newMessages {
    NSUInteger ind = NSNotFound;
    NSString *strCaption;
    for (NSUInteger i=0; i < [self.clinicalArray count]; i++) {
        strCaption = [self.clinicalArray objectAtIndex:i];
        if ([strCaption rangeOfString:@"Messages"].location != NSNotFound) {
            ind = i;
            break;
        }
    }
    
    if (ind != NSNotFound) {
        NSMutableString *strMessages = [NSMutableString stringWithString:@"Messages"];
        if (newMessages > 0) {
            [strMessages appendString:@" ("];
            [strMessages appendString:[NSString stringWithFormat:@"%d", newMessages]];
            [strMessages appendString:@" new)"];
        }
        [self.clinicalArray replaceObjectAtIndex:ind withObject:strMessages];
    }
}

- (void)initialiseSearchTypeArray: (AuthResponse*)authResponse {
    self.clinicalArray = [[NSMutableArray alloc] init];
    
    [self.clinicalArray addObject:@"Messages"];
    [self showNewMessages:authResponse.Patient.NumberOfNewMessages];
    
    if (authResponse.Patient.HasAppointments) {
        [self.clinicalArray addObject:@"Appointments"];
    }
    
    if (authResponse.Patient.HasRepeats) {
        [self.clinicalArray addObject:@"Prescriptions"];
    }
    
    if (authResponse.Patient.HasTests) {
        [self.clinicalArray addObject:@"Test results"];
    }
}

@end
