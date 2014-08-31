//
//  CocosViewController.h
//  CocosStoryboard
//
//  Created by Dimitri Giani on 29/07/14.
//  Copyright (c) 2014 Dimitri Giani. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "cocos2d.h"

@protocol CocosViewControllerDelegate;

@interface CocosViewController : UIViewController <CCDirectorDelegate>

@property (nonatomic, weak) id <CocosViewControllerDelegate>					delegate;

/*! Director is initialized, here you can replace scene, change director
 *	settings and other initializations.
 */
- (void)																		didInitializeDirector __attribute__((objc_requires_super));

/*! Remove the director from the controller. So the controller can be
 *	deallocated and the director could be added to another controller.
 */
- (void)																		removeDirector;

/*! You can provide a Cocos2D configuration Dictionary.
 *	Set this property before load the controller view and after set .useSpriteBuilderConfig to NO.
 *	Otherwise will be ignored.
 *	This method is used in -viewDidLayoutSubviews.
 */
@property (nonatomic, strong) NSDictionary*										ccConfig;

/*! Tells to the controller if use default Spritebuilder configuration or not.
 *	Default is YES.
 */
@property (nonatomic, readwrite) BOOL											useSpriteBuilderConfig;

@end

@protocol CocosViewControllerDelegate <NSObject>

/*! When director starts (or restart) needs a CCScene. This delegate method
 *	ask for the first scene to run.
 *	\param ccViewController a CCViewController object.
 *	\return a CCScene object, canno be nil.
 */
- (CCScene*)																	cocosViewControllerSceneToRun:(CocosViewController*)cocosViewController;

@end

