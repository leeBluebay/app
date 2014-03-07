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

- (id)initWithData: (LoginData*)loginData {
    if (self = [self init]) {
        [self initialiseSearchTypeArray:loginData];
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

- (void)initialiseSearchTypeArray: (LoginData*)loginData {
    self.clinicalArray = [[NSMutableArray alloc] init];

    [self.clinicalArray addObject:@"Messages"];
    [self showNewMessages:(NSUInteger)[loginData.messages integerValue]];

    if (loginData.isAppointments) {
        [self.clinicalArray addObject:@"Appointments"];
    }
    
    if (loginData.isRepeats) {
        [self.clinicalArray addObject:@"Prescriptions"];
    }
    
    if (loginData.isTests) {
        [self.clinicalArray addObject:@"Test results"];
    }
}

@end
