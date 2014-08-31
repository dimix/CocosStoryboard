//
//  CocosViewController.m
//  CocosStoryboard
//
//  Created by Dimitri Giani on 29/07/14.
//  Copyright (c) 2014 Dimitri Giani. All rights reserved.
//

#import "CCBReader.h"
#import "CocosViewController.h"

/* CODE FROM CCAppDelegate */

// Fixed size. As wide as iPhone 5 at 2x and as high as the iPad at 2x.
const CGSize FIXED_SIZE = {568, 384};

static CGFloat
FindPOTScale(CGFloat size, CGFloat fixedSize)
{
	int scale = 1;
	while(fixedSize*scale < size) scale *= 2;
	
	return scale;
}

/* END CODE FROM CCAppDelegate */

#pragma mark - CCDirector(Storyboards)

@interface CCDirector(Storyboards)

@property (nonatomic,strong) CCRenderer*										renderer;

@end

@implementation CCDirector(Storyboards)

- (void)setRenderer:(CCRenderer*)renderer
{
	if (_renderer != renderer)
	{
		_renderer = renderer;
	}
}

- (CCRenderer*)renderer
{
	return _renderer;
}

@end

#pragma mark - CocosViewController

@interface CocosViewController()

@property (nonatomic, strong) NSString*											screenOrientation;
@property (nonatomic, readwrite) BOOL											directorIsInitialized;

@end

@implementation CocosViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder]))
	{
		self.useSpriteBuilderConfig = YES;
	}
	return self;
}

- (void)viewDidLayoutSubviews
{
	[super viewDidLayoutSubviews];
	
	[self startDirector];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	//	observe application states
	
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillTerminate:)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationSignificantTimeChange:)
                                                 name:UIApplicationSignificantTimeChangeNotification
                                               object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
	
    [[CCDirector sharedDirector] setDelegate:nil];
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([self.screenOrientation isEqual:CCScreenOrientationAll])
    {
        return UIInterfaceOrientationMaskAll;
    }
    else if ([self.screenOrientation isEqual:CCScreenOrientationPortrait])
    {
        return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
    }
    else
    {
        return UIInterfaceOrientationMaskLandscape;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    [[CCDirector sharedDirector] purgeCachedData];
}

#pragma mark start, add and remove director

- (void)startDirector
{
	if (self.useSpriteBuilderConfig)
	{
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
		
		self.ccConfig = cocos2dSetup;
	}
	
	[self tryToSetupCocos2dWithOptions:self.ccConfig];
	
	if (!self.directorIsInitialized)
	{
		self.directorIsInitialized = YES;
		
		[self addDirector];
		
		[self didInitializeDirector];
		
		CCDirector* director = [CCDirector sharedDirector];
		
		if (director.runningScene)
		{
			[director replaceScene:[self.delegate cocosViewControllerSceneToRun:self]];
		}
	}
}

- (void)addDirector
{
	[self removeDirector];
	
	CCDirector* director = [CCDirector sharedDirector];
	director.delegate = self;
	
	[self addChildViewController:director];
	
	[self.view addSubview:director.view];
	[self.view sendSubviewToBack:director.view];
	
	[director didMoveToParentViewController:self];
}

- (void)removeDirector
{
	for (UIViewController* controller in self.childViewControllers)
	{
		[controller.view removeFromSuperview];
		[controller removeFromParentViewController];
	}
	
	CCDirector* director = [CCDirector sharedDirector];
	director.delegate = nil;
}

#pragma mark Cocos2D methods

- (void)tryToSetupCocos2dWithOptions:(NSDictionary*)config
{
	// CCGLView creation
	// viewWithFrame: size of the OpenGL view. For full screen use [_window bounds]
	//  - Possible values: any CGRect
	// pixelFormat: Format of the render buffer. Use RGBA8 for better color precision (eg: gradients). But it takes more memory and it is slower
	//	- Possible values: kEAGLColorFormatRGBA8, kEAGLColorFormatRGB565
	// depthFormat: Use stencil if you plan to use CCClippingNode. Use Depth if you plan to use 3D effects, like CCCamera or CCNode#vertexZ
	//  - Possible values: 0, GL_DEPTH_COMPONENT24_OES, GL_DEPTH24_STENCIL8_OES
	// sharegroup: OpenGL sharegroup. Useful if you want to share the same OpenGL context between different threads
	//  - Possible values: nil, or any valid EAGLSharegroup group
	// multiSampling: Whether or not to enable multisampling
	//  - Possible values: YES, NO
	// numberOfSamples: Only valid if multisampling is enabled
	//  - Possible values: 0 to glGetIntegerv(GL_MAX_SAMPLES_APPLE)
	
	
	//	I need to create a glView befoare call +sharedDirector to avoid a crash on 64bit devices
	
	CCGLView *glView = [CCGLView
						viewWithFrame:self.view.bounds
						pixelFormat:config[CCSetupPixelFormat] ?: kEAGLColorFormatRGBA8
						depthFormat:[config[CCSetupDepthFormat] unsignedIntValue]
						preserveBackbuffer:[config[CCSetupPreserveBackbuffer] boolValue]
						sharegroup:nil
						multiSampling:[config[CCSetupMultiSampling] boolValue]
						numberOfSamples:[config[CCSetupNumberOfSamples] unsignedIntValue]
						];
	
	CCDirectorIOS* director = (CCDirectorIOS*) [CCDirector sharedDirector];
	
	
	//	if director has the view loaded I don't need to re-add
	
	if ([director isViewLoaded])
	{
		return;
	}
	
	director.wantsFullScreenLayout = self.wantsFullScreenLayout;
	
#if DEBUG
	// Display FSP and SPF
	
	[director setDisplayStats:[config[CCSetupShowDebugStats] boolValue]];
#endif
	
	// set FPS at 60
	
	NSTimeInterval animationInterval = [(config[CCSetupAnimationInterval] ?: @(1.0/60.0)) doubleValue];
	[director setAnimationInterval:animationInterval];
	
	director.fixedUpdateInterval = [(config[CCSetupFixedUpdateInterval] ?: @(1.0/60.0)) doubleValue];
	
	[director stopAnimation];
	[director pause];
	
	//	from http://forum.cocos2d-swift.org/t/using-cocos2d-v3-1-beta-in-a-uikit-app/13343/8
	{
		[director setRenderer:nil];
		[EAGLContext setCurrentContext:glView.context];
		[CCShader initialize];
		[director setRenderer:[CCRenderer new]];
	}
	
	// attach the openglView to the director
	
	[director setView:glView];
	
	if ([config[CCSetupScreenMode] isEqual:CCScreenModeFixed])
	{
		CGSize size = [CCDirector sharedDirector].viewSizeInPixels;
		CGSize fixed = FIXED_SIZE;
		
		if([config[CCSetupScreenOrientation] isEqualToString:CCScreenOrientationPortrait])
		{
			CC_SWAP(fixed.width, fixed.height);
		}
		
		// Find the minimal power-of-two scale that covers both the width and height.
		
		CGFloat scaleFactor = MIN(FindPOTScale(size.width, fixed.width), FindPOTScale(size.height, fixed.height));
		
		director.contentScaleFactor = scaleFactor;
		director.UIScaleFactor = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 1.0 : 0.5);
		
		// Let CCFileUtils know that "-ipad" textures should be treated as having a contentScale of 2.0.
		
		[[CCFileUtils sharedFileUtils] setiPadContentScaleFactor: 2.0];
		
		director.designSize = fixed;
		[director setProjection:CCDirectorProjectionCustom];
	}
	else
	{
		// Setup tablet scaling if it was requested.
		
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad &&
			[config[CCSetupTabletScale2X] boolValue])
		{
			// Set the director to use 2 points per pixel.
			
			director.contentScaleFactor *= 2.0;
			
			// Set the UI scale factor to show things at "native" size.
			
			director.UIScaleFactor = 0.5;
			
			// Let CCFileUtils know that "-ipad" textures should be treated as having a contentScale of 2.0.
			
			[[CCFileUtils sharedFileUtils] setiPadContentScaleFactor:2.0];
		}
		
		[director setProjection:CCDirectorProjection2D];
	}
	
	self.screenOrientation = (config[CCSetupScreenOrientation] ?: CCScreenOrientationLandscape);
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change this setting at any time.
	
	[CCTexture setDefaultAlphaPixelFormat:CCTexturePixelFormat_RGBA8888];
    
    // Initialise OpenAL
	
    [OALSimpleAudio sharedInstance];
}

#pragma mark CCDirectorDelegate

// Projection delegate is only used if the fixed resolution mode is enabled

- (GLKMatrix4)updateProjection
{
	CGSize sizePoint = [CCDirector sharedDirector].viewSize;
	CGSize fixed = [CCDirector sharedDirector].designSize;
	
	// Half of the extra size that will be cut off
	CGPoint offset = ccpMult(ccp(fixed.width - sizePoint.width, fixed.height - sizePoint.height), 0.5);
	
	return GLKMatrix4MakeOrtho(offset.x, sizePoint.width + offset.x, offset.y, sizePoint.height + offset.y, -1024, 1024);
}

- (void)directorDidReshapeProjection:(CCDirector*)director
{
	if(director.runningScene == nil)
	{
		// Add the first scene to the stack. The director will draw it immediately into the framebuffer. (Animation is started automatically when the view is displayed.)
		// and add the scene to the stack. The director will run it when it automatically when the view is displayed.
		CCScene* scene = [self.delegate cocosViewControllerSceneToRun:self];
		if (scene)
		{
			[director runWithScene:scene];
		}
	}
}

#pragma mark accessor methods

- (void)didInitializeDirector
{
	CCDirector* director = [CCDirector sharedDirector];
	
	[director resume];
	[director startAnimation];
}

#pragma mark notifications

- (void)applicationWillResignActive:(NSNotification *)notification
{
    [[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(NSNotification *)notification
{
    [[CCDirector sharedDirector] resume];
}

- (void)applicationDidEnterBackground:(NSNotification *)notification
{
    [[CCDirector sharedDirector] stopAnimation];
}

- (void)applicationWillEnterForeground:(NSNotification *)notification
{
    [[CCDirector sharedDirector] startAnimation];
}

- (void)applicationWillTerminate:(NSNotification *)notification
{
    [[CCDirector sharedDirector] end];
}

- (void)applicationSignificantTimeChange:(NSNotification *)notification
{
    [[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

@end
