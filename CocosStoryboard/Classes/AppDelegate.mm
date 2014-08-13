//
//  AppDelegate.m
//  CocosStoryboard
//
//  Created by Dimitri Giani on 29/07/14.
//  Copyright Dimitri Giani 2014. All rights reserved.
//
// -----------------------------------------------------------------------

#import "AppDelegate.h"
#import "CCBReader.h"

@interface AppDelegate()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// Configure CCFileUtils to work with SpriteBuilder
	
    [CCBReader configureCCFileUtils];
	
	return YES;
}

@end
