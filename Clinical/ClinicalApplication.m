//
//  ClinicalApplication.m
//  Clinical
//
//  Created by brian macbride on 23/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ClinicalApplication.h"

@interface ClinicalApplication ()
@property (nonatomic) NSInteger timerCount;
@property (strong, nonatomic) NSTimer *idleTimer;
@end

@implementation ClinicalApplication

@synthesize idleTimer = _idleTimer;
@synthesize timerCount = _timerCount;

- (void)sendEvent:(UIEvent *)event {
	[super sendEvent:event];
	
    NSSet *allTouches = [event allTouches];
    if ([allTouches count] > 0) {
        UITouchPhase phase = ((UITouch *)[allTouches anyObject]).phase;
        if (phase == UITouchPhaseBegan) {
            self.timerCount = 0;
		}
    }
}

- (void)startTimer 
{
    if (self.idleTimer.isValid) {
        [self stopTimer];
    }
	
    self.timerCount = 0;
    self.idleTimer = [NSTimer scheduledTimerWithTimeInterval:60
                                                      target:self 
                                                    selector:@selector(timeCheck) 
                                                    userInfo:nil 
                                                     repeats:YES];
    
    // test
}

-(void) stopTimer {
    [self.idleTimer invalidate];
}

- (void)timeCheck {
    if (self.timerCount > 9) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kClinicalApplicationDidTimeout object:nil];
        [self startTimer];
    }
    else {
        self.timerCount++;
    }
}

@end
