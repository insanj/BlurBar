#import "BlurBar.h"

/****************************************************************************************/
/**************************** Settings Access Management ********************************/
/****************************************************************************************/

static char * kBlurBarCachedSettingsKey;
static NSString *kBlurBarReloadSettingsNotification = @"BBReloadSettingsNotification";

%hook CKBlurView

- (id)init {
	CKBlurView *blurView = %orig();
	[[NSDistributedNotificationCenter defaultCenter] addObserver:blurView selector:@selector(reloadBlurBarSettings:) name:kBlurBarReloadSettingsNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:blurView selector:@selector(layoutSubviews) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
	return blurView;
}

%new - (NSDictionary *)blurBarSettings {
	NSDictionary *cachedBlurBarSettings = objc_getAssociatedObject(self, &kBlurBarCachedSettingsKey);
	if (!cachedBlurBarSettings) {
		cachedBlurBarSettings = [NSDictionary dictionaryWithContentsOfFile:PREFS_PATH];
		objc_setAssociatedObject(self, &kBlurBarCachedSettingsKey, cachedBlurBarSettings, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}

	return cachedBlurBarSettings;
}

%new - (void)reloadBlurBarSettings:(NSNotification *)notification {
	objc_setAssociatedObject(self, &kBlurBarCachedSettingsKey, [NSDictionary dictionaryWithContentsOfFile:PREFS_PATH], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)layoutSubviews {
	%log;
	%orig();

	NSDictionary *settings = [self blurBarSettings];
	CGRect blurFrame = [UIApplication sharedApplication].statusBar.frame;
	if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
		CGFloat height = blurFrame.size.height;
		blurFrame.size.height = blurFrame.size.width;
		blurFrame.size.width = height;
	}

	UIColor *blurTint; // Thanks, http://clrs.cc!
	switch ([[settings objectForKey:@"blurTint"] intValue]) {
		case 1: // Aqua
			blurTint = UIColorFromRGB(0x7FDBFF);
			break;
		case 2: // Black
			blurTint = UIColorFromRGB(0x111111);
			break;
		case 3: // Blue
			blurTint = UIColorFromRGB(0x0074D9);
			break;
		default: // Clear (case 4)
			blurTint = [UIColor clearColor];
			break;
		case 5: // Fuchsia
			blurTint = UIColorFromRGB(0xF012BE);
			break;
		case 6: // Grey
			blurTint = UIColorFromRGB(0xAAAAAA);
			break;
		case 7: // Green
			blurTint = UIColorFromRGB(0x2ECC40);
			break;
		case 8: // Lime
			blurTint = UIColorFromRGB(0x01FF70);
			break;
		case 9: // Maroon
			blurTint = UIColorFromRGB(0x85144B);
			break;
		case 10: // Navy
			blurTint = UIColorFromRGB(0x001F3F);
			break;
		case 11: // Olive
			blurTint = UIColorFromRGB(0x3D9970);
			break;
		case 12: // Orange
			blurTint = UIColorFromRGB(0xFF851B);
			break;
		case 13: // Purple
			blurTint = UIColorFromRGB(0xB10DC9);
			break;
		case 14: // Red
			blurTint = UIColorFromRGB(0xFF4136);
			break;
		case 15: // Teal!
			blurTint = UIColorFromRGB(0x39CCCC);
			break;
		case 16: // Yellow
			blurTint = UIColorFromRGB(0xFFDC00);
			break;	
	}

    const CGFloat *rgb = CGColorGetComponents(blurTint.CGColor);
    CAFilter *tintFilter = [CAFilter filterWithName:@"colorAdd"];
    [tintFilter setValue:@[@(rgb[0]), @(rgb[1]), @(rgb[2]), @(CGColorGetAlpha(blurTint.CGColor))] forKey:@"inputColor"];
    
 	[self setTintColorFilter:tintFilter];
	self.blurCroppingRect = self.frame;
	self.blurRadius = [settings[@"blurAmount"] floatValue] ?: 10.0;
	self.alpha = 1.0; // [settings[@"blurAlpha"] floatValue] ?: 1.0;

	if ([settings[@"isMilky"] boolValue]) {
		[self makeMilky];
	}

	CGFloat blurSize = [settings[@"blurSize"] floatValue];
		
	CGRect statusFrame = [UIApplication sharedApplication].statusBar.frame;
	if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
		CGFloat height = statusFrame.size.height;
		statusFrame.size.height = statusFrame.size.width;
		statusFrame.size.width = height;
	}

	statusFrame.origin.x = 0.0;
	statusFrame.size.height *= (blurSize > 0.0 ? blurSize : 1.0);
	self.frame = statusFrame;
}

- (void)dealloc {
	%orig();
	[[NSDistributedNotificationCenter defaultCenter] removeObserver:self];
}

%end

/****************************************************************************************/
/***************************** Settings Cache Management ********************************/
/****************************************************************************************/

%hook SBLockScreenManager

- (void)_finishUIUnlockFromSource:(int)source withOptions:(id)options { 
	%orig();
	[[NSDistributedNotificationCenter defaultCenter] postNotificationName:kBlurBarReloadSettingsNotification object:nil];
}

%end

/****************************************************************************************/
/***************************** Status Bar View Injection ********************************/
/****************************************************************************************/

static CKBlurView * sharedBlurBar;

%hook UIStatusBar

- (void)layoutSubviews {
	%orig();
	%log;

	// Sneaky check to ensure we're on the home screen when altering blurBar
	if (self.frame.size.height <= 20.0) {
		if (!sharedBlurBar) {
			UIStatusBarBackgroundView *backgroundView = (UIStatusBarBackgroundView *)[UIApplication sharedApplication].statusBar._backgroundView;

			sharedBlurBar = [[CKBlurView alloc] init];
			[sharedBlurBar layoutSubviews];
			[backgroundView addSubview:sharedBlurBar];
			// NSLog(@"[BlurBar] status bar added %@ to %@", sharedBlurBar, backgroundView);
		}

		sharedBlurBar.alpha = 1.0;
	}

	else if (sharedBlurBar) {
		sharedBlurBar.alpha = 0.0;
	}
}

%end
