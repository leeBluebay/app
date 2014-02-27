//
//  SplashScreenViewController.h
//  Clinical
//
//  Created by brian macbride on 08/08/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplashScreenDataController.h"
#import "LoginViewController.h"

@interface SplashScreenViewController : UIViewController <SplashScreenDataControllerDelegate>

-(void)start;
-(void)stop;

@property (strong, nonatomic) IBOutlet UILabel *errorLabel;

@end
