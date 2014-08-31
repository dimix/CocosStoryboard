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
	UIButton* button = (UIButton*)sender;
	
	controller.sceneType = static_cast<SceneType>(button.tag);
	controller.useSpriteBuilderConfig = (controller.sceneType == kSceneType_SpriteBuilder);
	
	[self.navigationController setNavigationBarHidden:YES animated:NO];
}

@end
