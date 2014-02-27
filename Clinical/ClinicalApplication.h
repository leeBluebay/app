//
//  ClinicalApplication.h
//  Clinical
//
//  Created by brian macbride on 23/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kClinicalApplicationDidTimeout @"ClinicalApplicationDidTimeout"

@interface ClinicalApplication : UIApplication

-(void) startTimer;
-(void) stopTimer;

@end
