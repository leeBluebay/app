//
//  SendRequestDataController.h
//  Clinical
//
//  Created by brian macbride on 18/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RepeatData.h"
#import "ClinicalConstants.h"

@class SendRequestDataController;

@protocol SendRequestDataControllerDelegate <NSObject>
- (void) didGetEmailValues:(SendRequestDataController *)controller emailTo:(NSString*)to;
- (void) getEmailValuesError:(SendRequestDataController *)controller withError:(NSString*)error;
@end

@interface SendRequestDataController : NSObject

@property (nonatomic, strong) NSMutableArray *repeatsArray;

@property (weak, nonatomic) id <SendRequestDataControllerDelegate> sendRequestDataDelegate;

@property (nonatomic, strong) NSString* urlStr;

-(id)initWithSelectedArray:(NSMutableArray*)repeatsArray;

- (RepeatData*) addRepeat:(NSString *)name;

- (void)getEmailValues:(NSString *)practiceCode;

@end
