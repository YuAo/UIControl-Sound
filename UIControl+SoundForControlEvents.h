//
//  UIControl+SoundForControlEvents.h
//
//  Created by YuAo on 3/2/13.
//  Copyright (c) 2013 YuAo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@interface UIControl (SoundForControlEvents)

// Add a sound for particular event. you can call this multiple times and you can specify multiple sounds for a particular event.
- (void)addSoundWithContentsOfFile:(NSString *)soundFilePath forControlEvents:(UIControlEvents)controlEvents UI_APPEARANCE_SELECTOR;

// Remove a sound for particular event.
- (void)removeSoundWithContentsOfFile:(NSString *)soundFilePath forControlEvents:(UIControlEvents)controlEvents UI_APPEARANCE_SELECTOR;

// Remove all sounds for particular event.
- (void)removeSoundsForControlEvents:(UIControlEvents)controlEvents UI_APPEARANCE_SELECTOR;

@end

@interface WUUIControlSoundManager : NSObject

+ (instancetype)sharedSoundManager;

- (SEL)selectorForPlayingSoundFileAtPath:(NSString *)soundFilePath;

@end