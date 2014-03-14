//
//  DatesFreeDataController.h
//  Appointments1
//
//  Created by brian macbride on 07/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Appointment.h"
#import "ClinicalConstants.h"

@class DatesFreeDataController;

@protocol DatesFreeDataControllerDelegate <NSObject>
- (void)datesFreeDataControllerDidFinish;
- (void)datesFreeDataControllerHadError;
@end

@interface DatesFreeDataController : NSObject


@property (strong, nonatomic) NSMutableArray * datesFreeArray;
@property (weak, nonatomic) id <DatesFreeDataControllerDelegate> datesFreeDataDelegate;

- (void)addDate:(NSString *)strDate ;

@end
