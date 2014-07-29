//
//  MenuViewController.m
//  CCStoryboard
//
//  Created by Dimitri Giani on 29/07/14.
//  Copyright (c) 2014 Dimitri Giani. All rights reserved.
//

#import "MenuViewController.h"
#import "SceneViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.title = @"Cocos2D and Storyboards";
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	SceneViewController* controller = (SceneViewController*)segue.destinationViewController;
	
	// Configure Cocos2d with the options set in SpriteBuilder
    NSString* configPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Published-iOS"]; // TODO: add support for Published-Android support
    configPath = [configPath stringByAppendingPathComponent:@"configCocos2d.plist"];
    
    NSMutableDictionary* cocos2dSetup = [NSMutableDictionary dictionaryWithContentsOfFile:configPath];
    
    // Note: this needs to happen before configureCCFileUtils is called, because we need apportable to correctly setup the screen scale factor.
	
#ifdef APPORTABLE
    if([cocos2dSetup[CCSetupScreenMode] isEqual:CCScreenModeFixed])
        [UIScreen mainScreen].currentMode = [UIScreenMode emulatedMode:UIScreenAspectFitEmulationMode];
    else
        [UIScreen mainScreen].currentMode = [UIScreenMode emulatedMode:UIScreenScaledAspectFitEmulationMode];
#endif
    
	UIButton* button = (UIButton*)sender;
	
	controller.ccConfig = cocos2dSetup;
	controller.sceneType = static_cast<SceneType>(button.tag);
	
	[self.navigationController setNavigationBarHidden:YES animated:NO];
}

@end
