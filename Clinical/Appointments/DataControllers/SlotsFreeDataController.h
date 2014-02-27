//
//  SlotsFreeDataController.h
//  Appointments1
//
//  Created by brian macbride on 07/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SlotsFreeDataController : NSObject

@property (nonatomic, strong) NSMutableArray * slotsFreeArray;

- (void) clearSlots;
- (void)addSlot:(NSString *)slot toSession:(NSString *)session;

@end
