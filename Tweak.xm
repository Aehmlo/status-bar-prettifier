#define BOOLKEY_DEFAULT_TRUE(key) (prefs[key] == nil || [prefs[key] boolValue])
#define BOOLKEY_DEFAULT_FALSE(key) (prefs[key] != nil && [prefs[key] boolValue])

@interface SpringBoard : NSObject //Yes, I'm abridging this a bit, but the compiler doesn't need to know that.

+ (instancetype)sharedApplication;
- (void)_relaunchSpringBoardNow;

@end

static NSDictionary *prefs;

%hook SBStatusBarStateAggregator

- (BOOL)_setItem:(int)item enabled:(BOOL)enabled {
	BOOL shouldHide = (
		(item == 0 && BOOLKEY_DEFAULT_FALSE(@"Time")) ||
		(item == 1 && BOOLKEY_DEFAULT_TRUE(@"DND")) ||
		(item == 2 && BOOLKEY_DEFAULT_FALSE(@"AirplaneMode")) ||
		(item == 3 && BOOLKEY_DEFAULT_FALSE(@"SignalStrength")) ||
		(item == 4 && BOOLKEY_DEFAULT_TRUE(@"CarrierName")) ||
		(item == 5 && BOOLKEY_DEFAULT_FALSE(@"DataNetwork")) ||
		(item == 7 && BOOLKEY_DEFAULT_FALSE(@"BatteryIcon")) ||
		(item == 8 && BOOLKEY_DEFAULT_FALSE(@"BatteryPercent")) ||
		(item == 10 && BOOLKEY_DEFAULT_FALSE(@"BluetoothBattery")) ||
		(item == 11 && BOOLKEY_DEFAULT_FALSE(@"Bluetooth")) ||
		(item == 12 && BOOLKEY_DEFAULT_FALSE(@"TTY")) ||
		(item == 13 && BOOLKEY_DEFAULT_TRUE(@"Alarm")) ||
		(item == 16 && BOOLKEY_DEFAULT_FALSE(@"LocationServices")) ||
		(item == 17 && BOOLKEY_DEFAULT_TRUE(@"RotationLock")) ||
		(item == 19 && BOOLKEY_DEFAULT_FALSE(@"AirPlay")) ||
		(item == 20 && BOOLKEY_DEFAULT_FALSE(@"Siri")) ||
		(item == 21 && BOOLKEY_DEFAULT_FALSE(@"VPN")) ||
		(item == 22 && BOOLKEY_DEFAULT_FALSE(@"CallForwarding")) ||
		(item == 23 && BOOLKEY_DEFAULT_FALSE(@"ActivityIndicator"))
	);
	if(enabled && shouldHide) {
		%orig(item, NO);
		return NO;
	} else return %orig(item, enabled);
}

%end

static void absp_reloadPrefs(void) {
	[prefs release];
	prefs = [[NSDictionary alloc] initWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Library/Preferences/com.aehmlo.statusprettifier.plist"]];
}

static void absp_prefsChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	absp_reloadPrefs();
}

static void absp_respring(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	[(SpringBoard *)[%c(SpringBoard) sharedApplication] _relaunchSpringBoardNow];
}

%ctor {
	@autoreleasepool {
		%init;
		prefs = [[NSDictionary alloc] init];
		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, &absp_prefsChanged, CFSTR("com.aehmlo.statusprettifier/prefsChanged"), NULL, 0);
		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, &absp_respring, CFSTR("com.aehmlo.statusprettifier/respring"), NULL, 0);
		absp_reloadPrefs();
	}
}