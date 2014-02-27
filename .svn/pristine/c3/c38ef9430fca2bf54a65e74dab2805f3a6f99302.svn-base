//
//  RepeatsDataController.h
//  Clinical
//
//  Created by brian macbride on 11/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RepeatData.h"

@interface RepeatsDataController : NSObject

@property (nonatomic, strong) NSMutableArray *repeatsArray;

-(id) initWithArray:(NSMutableArray*)repeatsArray forRequestMore:(BOOL)requestMore;

- (void) clearRepeats;
- (RepeatData*) addRepeat:(NSString *)name withStatus:(NSString*)status;
-(void) addSortedWithArray:(NSMutableArray*)repeatsArray;
- (void) addRepeatWithData:(RepeatData *)repeatData;
- (void) addError:(NSString *)error;

@end
