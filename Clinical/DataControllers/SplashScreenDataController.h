//
//  SplashScreenDataController.h
//  Clinical
//
//  Created by BlueBay Medical Systems on 11/10/2013.
//
//

#import <Foundation/Foundation.h>

@class SplashScreenDataController;

@protocol SplashScreenDataControllerDelegate <NSObject>
- (void) didGetUrl:(NSString *)strUrl;
- (void) didFailGetUrl:(NSString *)strError;
@end

@interface SplashScreenDataController : NSObject

@property (weak, nonatomic) id <SplashScreenDataControllerDelegate> splashScreenDataDelegate;

- (NSString*)getUrl;
- (void)getUrlForVersion;

@end
