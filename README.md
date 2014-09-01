##What is CocosStoryboard?

CocosViewController is a class that allow you to use Cocos2D v3.1/3.2 and UIKit + Storyboards.
The header file contains the specifications.

##Why CocosStoryboard?

In many games we need to create some part of the game with UIKit elements like forms, scrollviews and other.
Replicate the same behaviours in Cocos2D is not simple and fast and sometimes the results is not so good, so, why do not use UIKit for all the other things?
CocosStoryboard helps you in this case, allowing you to create an hybrid project UIKit/Cocos2D.


##How do I use CocosStoryboard?

1. Start with a new project from SpriteBuilder or XCode Cocos2d Template.
2. Replace AppDelegate of CocosStoryboard project with yours.
3. Copy CocosViewController.h/.mm in your project folder and add it to the project.
4. Subclass CocosViewController, for example as SceneViewController.
5. Use CocosViewControllerDelegate method (-cocosViewControllerSceneToRun:) of CocosViewController in the SceneViewController to load the main scene.
6. Add a Storyboard to your project and add the Controllers that you want, for example a ViewController for the menu and then the SceneViewController.
7. Connect the controllers in the Storyboards.
8. Build and Run!

You can inspirate by watching the CocosStoryboard project files: AppDelegate, MenuViewController and SceneViewController.

You can also follow a tutorial on my personal blog: http://www.dimitrigiani.it/2014/09/01/cocosviewcontroller-how-to-use-storyboards-and-cocos2d-v3/

####Remember

CCDirector is a singleton, when Cocos2D view controller will be popped CCDirector is paused and not removed, so the memory is still used and retained. When you re-instantiate CocosViewController, CCDirector will represent the old scene, so you need to use CocosViewControllerDelegate method to update the scene with the correct one.

##Compatibility

This project include Cocos2d v3.1 files but is compatible with v3.2

##Screenshots

![Cocos2D and UIKit preview](http://www.dimitrigiani.it/files/cocos-uikit-1-1.png)

![Cocos2D and UIKit preview](http://www.dimitrigiani.it/files/cocos-uikit-2.png)

