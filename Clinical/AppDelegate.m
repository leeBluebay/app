//
//  AppDelegate.m
//  Clinical
//
//  Created by brian macbride on 09/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "SplashScreenViewController.h"
#import "LoginViewController.h"
#import "RequestDataAccess.h"
#import "ClinicalApplication.h"

@implementation AppDelegate

@synthesize window = _window;

-(void) applicationDidTimeout:(NSNotification*)notif {
    UIViewController *splash = (UIViewController*)self.window.rootViewController;

    UINavigationController *loginNav = (UINavigationController*)[splash presentedViewController];
    LoginViewController *login = (LoginViewController*)[[loginNav viewControllers] objectAtIndex:0];
    
    RequestDataAccess *requestDataAccess = [[RequestDataAccess alloc] init];
    LoginData *loginData = login.loginData;
    RequestData *reqData = [[RequestData alloc] initWithPractice:loginData.practiceCode forPatient:loginData.patientID withRequest:@"0"];
    [requestDataAccess delRequest:reqData];
    
    UINavigationController *presented = (UINavigationController*)[login presentedViewController];
    if (presented != nil){
        [login dismissModalViewControllerAnimated:NO];
    }
    [loginNav popToRootViewControllerAnimated:NO];
    
    [login.username becomeFirstResponder];
    login.username.text = @"";
    login.password.text = @"";
    login.messageLabel.text = @"";
    login.navigationItem.rightBarButtonItem = nil;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidTimeout:)
                                                 name:kClinicalApplicationDidTimeout object:nil];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self applicationDidTimeout:nil];
    
    UIViewController *splash = (UIViewController*)self.window.rootViewController;
    [splash dismissModalViewControllerAnimated:NO];
    [(SplashScreenViewController*)splash stop];
    

    [(ClinicalApplication*)application stopTimer];
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Override point for customization after application launch.
    
    SplashScreenViewController *splash = (SplashScreenViewController*)self.window.rootViewController;
    [splash start];

    [(ClinicalApplication*)application startTimer];
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
