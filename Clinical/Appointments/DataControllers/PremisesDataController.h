//
//  PremisesDataController.h
//  Appointments1
//
//  Created by brian macbride on 08/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Appointment.h"
#import "ClinicalConstants.h"

@class PremisesDataController;

@protocol PremisesDataControllerDelegate <NSObject>
- (void)premisesDataControllerDidFinish;
- (void)premisesDataControllerIsEmpty;
- (void)premisesDataControllerHadError:(NSString*)strError;
@end

@interface PremisesDataController : NSObject

@property (nonatomic, strong) NSString* urlStr;

@property (strong, nonatomic) NSMutableArray * premisesArray;
@property (weak, nonatomic) id <PremisesDataControllerDelegate> premisesDataDelegate;

- (id)initWithArray:(NSArray*)premisesArray;
- (void)addPremise:(NSString *)strPremise;
- (void)getPremises:(Appointment*)appointment;

@end
