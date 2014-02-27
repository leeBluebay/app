//
//  RepeatsDataController.m
//  Clinical
//
//  Created by brian macbride on 11/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RepeatsDataController.h"
#import "RepeatStatusData.h"

@implementation RepeatsDataController

@synthesize repeatsArray = _repeatsArray;

- (id)init {
    if (self = [super init]) {
        [self initialiseRepeatsArray];
    }
    return self;
}

- (void)initialiseRepeatsArray {
    NSMutableArray *repeatsArray = [[NSMutableArray alloc] init];
    self.repeatsArray = repeatsArray;
}

-(id)initWithArray:(NSMutableArray*)repeatsArray forRequestMore:(BOOL)requestMore
{
    NSMutableArray *sortArray = [[NSMutableArray alloc] init];
    
    if (self = [self init]) {
        for (RepeatStatusData *repeatStatus in repeatsArray) {
            for (RepeatData *repeat in repeatStatus.repeatsArray) {
                if (!requestMore || [repeat.status isEqualToString:@"request more"]) {
                    [sortArray addObject:repeat];
                }
            }
        }
    }
    
    [self addSortedWithArray:sortArray];
    
    return self;
}

-(void) addSortedWithArray:(NSMutableArray*)repeatsArray
{
    [self sortAndAdd:repeatsArray forStatus:@"due"];
    [self sortAndAdd:repeatsArray forStatus:@"ordered"];
    [self sortAndAdd:repeatsArray forStatus:@"overdue"];
    [self sortAndAdd:repeatsArray forStatus:@"not yet due"];
    [self sortAndAdd:repeatsArray forStatus:@"request more"];
}

-(void) sortAndAdd:(NSMutableArray*)repeatsArray forStatus:(NSString*)status
{
    for (RepeatData *repeatData in repeatsArray) {
        if ([repeatData.status isEqualToString:status]) {
            [self addRepeatWithData:repeatData];
        }
    }
}

- (void) addRepeatWithData:(RepeatData *)repeatData
{
    Boolean found = false;
    for (RepeatStatusData *repeatStatusData in self.repeatsArray) {
        if ([repeatStatusData.status isEqualToString:repeatData.status]) {
            [repeatStatusData addRepeatWithData:repeatData];
            found = true;
        }
    }
    
    if (!found) {
        RepeatStatusData *repeatStatusData = [[RepeatStatusData alloc] init];
        repeatStatusData.status = repeatData.status;
        [repeatStatusData addRepeatWithData:repeatData];
        [self.repeatsArray addObject:repeatStatusData];
    }
}

- (RepeatData*) addRepeat:(NSString *)name withStatus:(NSString*)status
{
    Boolean found = false;
    RepeatData *repeatData;
    for (RepeatStatusData *repeatStatusData in self.repeatsArray) {
        if (repeatStatusData.status == status) {
            repeatData = [repeatStatusData addRepeat:name];
            found = true;
        }
    }
    
    if (!found) {
        RepeatStatusData *repeatStatusData = [[RepeatStatusData alloc] init];
        repeatStatusData.status = status;
        repeatData = [repeatStatusData addRepeat:name];
        [self.repeatsArray addObject:repeatStatusData];
    }
    
    repeatData.status = status;
    
    return repeatData;
}

- (void) addError:(NSString *)error
{
    [self addRepeat:error withStatus:@""];
}

- (void) clearRepeats 
{
    [self.repeatsArray removeAllObjects];
}

@end
