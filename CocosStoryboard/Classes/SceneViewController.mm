//
//  SceneViewController.mm
//  CCStoryboard
//
//  Created by Dimitri Giani on 29/07/14.
//  Copyright (c) 2014 Dimitri Giani. All rights reserved.
//

#import "IntroScene.h"
#import "CCBReader.h"
#import "SceneViewController.h"

@interface SceneViewController () <CocosViewControllerDelegate>

@end

@implementation SceneViewController

- (void)viewDidLoad
{
	self.delegate = self;
	
	[super viewDidLoad];
}

- (void)didInitializeDirector
{
	[super didInitializeDirector];
	
	[[CCDirector sharedDirector] setDisplayStats:YES];
}

- (IBAction)dismiss:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
	
	[self removeDirector];
}

- (CCScene *)cocosViewControllerSceneToRun:(CocosViewController *)cocosViewController
{
	if (self.sceneType == kSceneType_SpriteBuilder)
	{
		return [CCBReader loadAsScene:@"MainScenePhone"];
	}
	
	return [IntroScene scene];
}

@end
