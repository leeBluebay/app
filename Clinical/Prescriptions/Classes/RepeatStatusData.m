//
//  RepeatStatusData.m
//  Clinical
//
//  Created by brian macbride on 27/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RepeatStatusData.h"

@implementation RepeatStatusData

@synthesize status = _status;
@synthesize repeatsArray = _repeatsArray;

- (id)init {
    if (self = [super init]) {
        [self initialiseRepeatStatusData];
    }
    return self;
}

- (void)initialiseRepeatStatusData {
    NSMutableArray *repeatsArray = [[NSMutableArray alloc] init];
    self.repeatsArray = repeatsArray;
    self.status = @"";
}

- (RepeatData*)addRepeat:(NSString *)name {
    RepeatData *repeatData = [[RepeatData alloc] init];
    repeatData.name = name;
    
    [self.repeatsArray addObject:repeatData];
    
    return repeatData;
}

- (void)addRepeatWithData:(RepeatData *)repeat
{
    RepeatData *repeatData = [[RepeatData alloc] initWithData:repeat];
    
    [self.repeatsArray addObject:repeatData];
}

@end
