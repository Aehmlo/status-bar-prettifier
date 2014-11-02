%hook SBStatusBarStateAggregator

- (BOOL)_setItem:(int)item enabled:(BOOL)enabled {
	if(enabled && (item == 1 || item == 4 || item == 13 || item == 17)) { //Do Not Disturb, Carrier Name, Alarm, and Rotation Lock icons. Hard-coded because this isn't meant to replace CleanStatus, but solely to be a simple, lightweight alternative that works for me.
		%orig(item, NO);
		return NO;
	} else return %orig(item, enabled);
}

%end