@interface PSListController : UIViewController {
	NSArray *_specifiers;
}

- (NSArray *)loadSpecifiersFromPlistName:(NSString *)name target:(id)target;

@end

@interface StatusBarPrettifierPrefsListController : PSListController
@end

@implementation StatusBarPrettifierPrefsListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"StatusBarPrettifierPrefs" target:self] retain];
	}
	return _specifiers;
}
- (void)respring {
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.aehmlo.statusprettifier/respring"), NULL, NULL, false);
}
@end