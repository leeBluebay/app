//
//  SlotFreeData.m
//  Clinical
//
//  Created by brian macbride on 09/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SlotFreeData.h"

@implementation SlotFreeData

@synthesize session = _session;
@synthesize slotsArray = _slotsArray;

- (id)init {
    if (self = [super init]) {
        [self initialiseSlotFreeData];
    }
    return self;
}

- (void)initialiseSlotFreeData {
    NSMutableArray * slotsArray = [[NSMutableArray alloc] init];
    self.slotsArray = slotsArray;
    self.session = @"";
}

- (void)addSlot:(NSString *)slot {
    [self.slotsArray addObject:slot];
}

@end
