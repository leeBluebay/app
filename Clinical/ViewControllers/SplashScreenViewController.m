//
//  SplashScreenViewController.m
//  Clinical
//
//  Created by brian macbride on 08/08/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SplashScreenViewController.h"
#import "SplashScreenDataController.h"

@interface SplashScreenViewController ()
@property (nonatomic, strong) SplashScreenDataController * splashScreenDataController;
@property (nonatomic, copy) NSString* strUrl;
@end

@implementation SplashScreenViewController

@synthesize splashScreenDataController = _splashScreenDataController;
@synthesize strUrl = _strUrl;

@synthesize errorLabel = _errorLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.splashScreenDataController = [[SplashScreenDataController alloc] init];
    self.splashScreenDataController.splashScreenDataDelegate = self;
    self.strUrl = @"";
    
    
}

- (void)viewDidUnload
{
    [self setErrorLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)start
{
    self.errorLabel.hidden = YES;
    [self.splashScreenDataController getUrlForVersion];
}

-(void)stop
{
    self.errorLabel.hidden = YES;
}

-(void)login
{
    if (![self.strUrl isEqualToString:@""]) {
        [self performSegueWithIdentifier:@"loginSegue" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"loginSegue"]) {
        UINavigationController *loginNav = [segue destinationViewController];
        LoginViewController *login = (LoginViewController*)[[loginNav viewControllers] objectAtIndex:0];
        login.strUrl = self.strUrl;
        [login.username becomeFirstResponder];
    }
}

#pragma mark - Splash Screen Data delegate

-(void) didGetUrl:(NSString *)strUrl;
{
    self.strUrl = strUrl;
    [self performSelector:@selector(login) withObject:nil afterDelay:2];
}

-(void) didFailGetUrl:(NSString *)strError;
{
    self.errorLabel.hidden = NO;
}

@end
