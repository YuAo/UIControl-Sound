//
//  AppDelegate.m
//  UIControlSoundDemo
//
//  Created by YuAo on 3/2/13.
//  Copyright (c) 2013 YuAo. All rights reserved.
//

#import "AppDelegate.h"
#import "DemoViewController.h"
#import "UIControl+SoundForControlEvents.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    [self addSoundForUIControls];

    self.window.rootViewController = [[DemoViewController alloc] initWithNibName:NSStringFromClass(DemoViewController.class) bundle:nil];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)addSoundForUIControls {
    NSString *soundAFilePath = [NSBundle.mainBundle pathForResource:@"tap-kissy" ofType:@"aif"];
    [[UIButton appearance] addSoundWithContentsOfFile:soundAFilePath forControlEvents:UIControlEventTouchUpInside];
    
    NSString *soundBFilePath = [NSBundle.mainBundle pathForResource:@"tap-fuzzy" ofType:@"aif"];
    [[UISegmentedControl appearance] addSoundWithContentsOfFile:soundBFilePath forControlEvents:UIControlEventValueChanged];
    
    NSString *soundCFilePath = [NSBundle.mainBundle pathForResource:@"slide-rock" ofType:@"aif"];
    [[UISwitch appearance] addSoundWithContentsOfFile:soundCFilePath forControlEvents:UIControlEventValueChanged];
    
    [[UITextField appearance] addSoundWithContentsOfFile:soundAFilePath forControlEvents:UIControlEventEditingChanged];
}

@end
