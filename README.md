#UIControl+Sound

A simple UIControl category for adding sounds to UI controls such as UIButton, UISwitch, UISegmentedControl, UITextField, etc.

##What can it do?

With this simple category. You can easily add sounds to all (or just one) of the buttons, switches, text fields, I mean UIControls, in your app, with just **[one line of code](#whats-the-one-line-of-code)**.

##What's included?

Two methods. Simple. Self-explanatory.

```
@interface UIControl (SoundForControlEvents)

- (void)addSoundWithContentsOfFile:(NSString *)soundFilePath forControlEvents:(UIControlEvents)controlEvents UI_APPEARANCE_SELECTOR;

- (void)removeSoundWithContentsOfFile:(NSString *)soundFilePath forControlEvents:(UIControlEvents)controlEvents UI_APPEARANCE_SELECTOR;

@end
```

##What's the one line of code?

We use `UIAppearance` to add sound for all of our controls.

For example, you want to add a tap sound for all of the buttons in your app, and the sound file is named `TapSound.aif`

```
//Call this after your app launches.
[[UIButton appearance] addSoundWithContentsOfFile:[NSBundle.mainBundle pathForResource:@"TapSound" ofType:@"aif"] forControlEvents:UIControlEventTouchUpInside];
```

Of course, you can just add the tap sound for one button

```
[aButton addSoundWithContentsOfFile:[NSBundle.mainBundle pathForResource:@"TapSound" ofType:@"aif"] forControlEvents:UIControlEventTouchUpInside];
```

Got it?

There's also a demo project `UIControlSoundDemo`, you can find the _"Add Sound Code"_ in the `AppDelegate.m` file of the demo project.

The sound files used in the demo project came from the [Free UI Sound Library - OCTAVE](https://github.com/scopegate/octave).

##How does it work?

It's a little hard to explain what happened underneath. You may have to look into the code.

The key here is the `WUUIControlSoundManager` class. It's a singleton, and has only one public method.

```
- (SEL)selectorForPlayingSoundFileAtPath:(NSString *)soundFilePath;
```

This method returns a selector. If you make the `WUUIControlSoundManager` perform this selector, it will play the sound at `soundFilePath`.

---

The basic idea here is that `WUUIControlSoundManager` takes that `soundFilePath` and maps it to a selector.

When `WUUIControlSoundManager` received a message, it will check and see if the message's selector is the selector that can play a sound and what sound it should play, then forward the message to `- (void)playSoundWithIdentifier:(NSString *)soundIdentifier`.

It looks a little tricky and involves message forwarding. But it's actually not bad, we've created such a simple and solid interface to accomplish a "not so simple" job, while did not mess up anything :)

##Requirements

- AudioToolbox.framework
- Automatic Reference Counting (ARC)
- iOS 5.0+
- Xcode 4.5+

##Contributing

If you find a bug and know exactly how to fix it, please open a pull request.

If you can't make the change yourself, please open an issue after making sure that one isn't already logged.

##License

The MIT license, as aways.
