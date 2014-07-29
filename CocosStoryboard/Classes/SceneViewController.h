//
//  SceneViewController.h
//  CCStoryboard
//
//  Created by Dimitri Giani on 29/07/14.
//  Copyright (c) 2014 Dimitri Giani. All rights reserved.
//

#import "CocosViewController.h"

enum SceneType
{
	kSceneType_Demo,
	kSceneType_SpriteBuilder
};

@interface SceneViewController : CocosViewController

@property (nonatomic, readwrite) SceneType										sceneType;

@end
