//
//  AppDelegate.m
//  CocosStoryboard
//
//  Created by Dimitri Giani on 29/07/14.
//  Copyright Dimitri Giani 2014. All rights reserved.
//
// -----------------------------------------------------------------------

#import "AppDelegate.h"
#import "IntroScene.h"
//#import "HelloWorldScene.h"

#import "CCBReader.h"
#import "CocosViewController.h"

@interface AppDelegate() <CocosViewControllerDelegate>

@end

@implementation AppDelegate

//
-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// Configure CCFileUtils to work with SpriteBuilder
	
    [CCBReader configureCCFileUtils];
	
	//	// Configure Cocos2d with the options set in SpriteBuilder
	//    NSString* configPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Published-iOS"]; // TODO: add support for Published-Android support
	//    configPath = [configPath stringByAppendingPathComponent:@"configCocos2d.plist"];
	//
	//    NSMutableDictionary* cocos2dSetup = [NSMutableDictionary dictionaryWithContentsOfFile:configPath];
	//
	//    // Note: this needs to happen before configureCCFileUtils is called, because we need apportable to correctly setup the screen scale factor.
	//
	//#ifdef APPORTABLE
	//    if([cocos2dSetup[CCSetupScreenMode] isEqual:CCScreenModeFixed])
	//        [UIScreen mainScreen].currentMode = [UIScreenMode emulatedMode:UIScreenAspectFitEmulationMode];
	//    else
	//        [UIScreen mainScreen].currentMode = [UIScreenMode emulatedMode:UIScreenScaledAspectFitEmulationMode];
	//#endif
	//
	//	CCViewController* controller = (CCViewController*)self.window.rootViewController;
	//
	//	controller.delegate = self;
	//	controller.ccConfig = cocos2dSetup;
	
	return YES;
}

- (CCScene *)cocosViewControllerSceneToRun:(CocosViewController *)cocosViewController
{
	//	return [IntroScene scene];
	return [CCBReader loadAsScene:@"MainScenePhone"];
}

@end
