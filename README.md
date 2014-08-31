##What is CocosStoryboard?

CocosViewController is a class that allow you to use Cocos2D v3.1/3.2 and UIKit + Storyboards.
The header file contains the specifications.

##Why CocosStoryboard?

In many games we need to create some part of the game with UIKit elements like forms, scrollviews and other.
Replicate the same behaviours in Cocos2D is not simple and fast and sometimes the results is not so good, so, why do not use UIKit for all the other things?
CocosStoryboard helps you in this case, allowing you to create an hybrid project UIKit/Cocos2D.


##How do I use CocosStoryboard?

1. Prepare the project to use Storyboards (remove cocos2d loading from AppDelegate, create UIWindow property in AppDelegate etc..)
1. Copy CocosViewController.h/.mm in your project.
2. In App Delegate call: [CCBReader configureCCFileUtils];
2. Subclass CocosViewController, for example as SceneViewController.
3. Add a Storyboard to your project and add the Controllers that you want and add the SceneViewController with the Segue that you want.
4. Use CocosViewControllerDelegate method (-cocosViewControllerSceneToRun:) of CocosViewController to load the main scene.
5. Build and Run!

You can inspirate by watching the CocosStoryboard project files: AppDelegate, MenuViewController and SceneViewController.

####Remember

CCDirector is a singleton, when Cocos2D view controller will be popped CCDirector is paused and not removed, so the memory is still used and retained. When you re-instantiate CocosViewController, CCDirector will represent the old scene, so you need to use CocosViewControllerDelegate method to update the scene with the correct one.

##Compatibility

This project contains Cocos2d v3.1 files but is compatible with v3.2 beta.

##Screenshots

![Cocos2D and UIKit preview](http://www.dimitrigiani.it/files/cocos-uikit-1-1.png)

![Cocos2D and UIKit preview](http://www.dimitrigiani.it/files/cocos-uikit-2.png)

