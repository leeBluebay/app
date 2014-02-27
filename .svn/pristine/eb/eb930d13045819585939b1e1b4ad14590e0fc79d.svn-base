//
//  SlotsFreeDataController.m
//  Appointments1
//
//  Created by brian macbride on 07/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SlotsFreeDataController.h"
#import "SlotFreeData.h"

@implementation SlotsFreeDataController

@synthesize slotsFreeArray = _slotsFreeArray;

- (id)init {
    if (self = [super init]) {
        [self initialiseSlotsFreeArray];
    }
    return self;
}

- (void)initialiseSlotsFreeArray {
    NSMutableArray *slotsFreeArray = [[NSMutableArray alloc] init];
    self.slotsFreeArray = slotsFreeArray;    
}

- (void)addSlot:(NSString *)slot toSession:(NSString *)session 
{
    Boolean found = false;
    for (SlotFreeData * slotFreeData in self.slotsFreeArray) {
        if ([slotFreeData.session isEqualToString:session]) {
            [slotFreeData addSlot:slot];
            found = true;
        }
    }
    
    if (!found) {
        SlotFreeData * slotFreeData = [[SlotFreeData alloc] init];
        slotFreeData.session = session;
        [slotFreeData addSlot:slot];
        [self.slotsFreeArray addObject:slotFreeData];
    }
}

- (void) clearSlots {
    [self.slotsFreeArray removeAllObjects];
}

@end
