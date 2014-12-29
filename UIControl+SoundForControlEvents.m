//
//  UIControl+SoundForControlEvents.m
//
//  Created by YuAo on 3/2/13.
//  Copyright (c) 2013 YuAo. All rights reserved.
//

#import "UIControl+SoundForControlEvents.h"

@implementation UIControl (SoundForControlEvents)

- (void)addSoundWithContentsOfFile:(NSString *)soundFilePath forControlEvents:(UIControlEvents)controlEvents {
    if (soundFilePath.length) [self addTarget:WUUIControlSoundManager.sharedSoundManager action:[WUUIControlSoundManager.sharedSoundManager selectorForPlayingSoundFileAtPath:soundFilePath] forControlEvents:controlEvents];
}

- (void)removeSoundWithContentsOfFile:(NSString *)soundFilePath forControlEvents:(UIControlEvents)controlEvents {
    if (soundFilePath.length) [self removeTarget:WUUIControlSoundManager.sharedSoundManager action:[WUUIControlSoundManager.sharedSoundManager selectorForPlayingSoundFileAtPath:soundFilePath] forControlEvents:controlEvents];
}

- (void)removeSoundsForControlEvents:(UIControlEvents)controlEvents {
    NSArray *playSoundActions = [self actionsForTarget:WUUIControlSoundManager.sharedSoundManager forControlEvent:controlEvents];
    [playSoundActions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self removeTarget:WUUIControlSoundManager.sharedSoundManager action:NSSelectorFromString(obj) forControlEvents:controlEvents];
    }];
}

@end


void WUUIControlSoundManagerAudioServicesSystemSoundCompletionProc (SystemSoundID soundID, void *clientData) {
    AudioServicesDisposeSystemSoundID(soundID);
}

NSString * const WUUIControlSoundManagerPlaySoundSelectorPrefix = @"playSound_";

@interface WUUIControlSoundManager()
@property (nonatomic,strong) NSMutableArray *soundFiles;
@end

@implementation WUUIControlSoundManager

+ (instancetype)sharedSoundManager {
    static id _sharedSoundManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedSoundManager = [[self.class alloc] init];
    });
    return _sharedSoundManager;
}

- (NSMutableArray *)soundFiles {
    if (!_soundFiles) _soundFiles = [NSMutableArray array];
    return _soundFiles;
}

- (SEL)selectorForPlayingSoundFileAtPath:(NSString *)soundFilePath {
    NSParameterAssert(soundFilePath);
    NSString *soundIdentifier = [self soundIdentifierForSoundFile:soundFilePath];
    return NSSelectorFromString([WUUIControlSoundManagerPlaySoundSelectorPrefix stringByAppendingString:soundIdentifier]);
}

- (NSString *)soundIdentifierForSoundFile:(NSString *)filePath {
    if (![self.soundFiles containsObject:filePath]) {
        [self.soundFiles addObject:filePath];
    }
    return [NSString stringWithFormat:@"%lx",(unsigned long)filePath.hash];
}

- (void)playSoundWithIdentifier:(NSString *)soundIdentifier {
    NSString *__block soundFileToPlay = nil;
    [self.soundFiles enumerateObjectsUsingBlock:^(NSString *soundFilePath, NSUInteger idx, BOOL *stop) {
        if ([soundIdentifier isEqualToString:[self soundIdentifierForSoundFile:soundFilePath]]) {
            soundFileToPlay = soundFilePath;
        }
    }];
    if (soundFileToPlay) {
        NSURL *filePath = [NSURL fileURLWithPath:soundFileToPlay];
        SystemSoundID sound;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &sound);
        CFStringRef currentRunLoopMode = CFRunLoopCopyCurrentMode(CFRunLoopGetCurrent());
        AudioServicesAddSystemSoundCompletion(sound, NULL, currentRunLoopMode, &WUUIControlSoundManagerAudioServicesSystemSoundCompletionProc, NULL);
        CFRelease(currentRunLoopMode);
        AudioServicesPlaySystemSound(sound);
    }
}

- (void)playSound_xxxxx {
    //Just a placeholder method.
    return;
}

- (NSString *)soundIdentifierFromSelector:(SEL)selector;{
    NSString *selectorString = NSStringFromSelector(selector);
    if([selectorString hasPrefix:WUUIControlSoundManagerPlaySoundSelectorPrefix]){
        NSString *soundIdentifier = [selectorString stringByReplacingOccurrencesOfString:WUUIControlSoundManagerPlaySoundSelectorPrefix withString:@""];
        if (soundIdentifier.length) {
            return soundIdentifier;
        }
    }
    return nil;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    if (!signature) {
        if ([self soundIdentifierFromSelector:aSelector]) {
            signature = [self methodSignatureForSelector:@selector(playSound_xxxxx)];
        }
    }
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSString *soundIdentifier = [self soundIdentifierFromSelector:anInvocation.selector];
    if (soundIdentifier) {
        [self playSoundWithIdentifier:soundIdentifier];
    } else {
        [super forwardInvocation:anInvocation];
    }
}

@end