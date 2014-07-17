#import "BlurBar.h"

static NSDictionary * blurBar_settings;
static CKBlurView * blurBar;

static NSDictionary * blurBarSettings() {
	if (!blurBar_settings) {
		blurBar_settings = [NSDictionary dictionaryWithContentsOfFile:PREFS_PATH];
	}

	return blurBar_settings;
}

%hook UIStatusBarBackgroundView

%new + (CKBlurView *)sharedBlurBar {	
	if (!blurBar) {
		blurBar = [[CKBlurView alloc] init];
	}

	return blurBar;
}

%new + (void)blurBarLayoutFromPreferences {
	NSDictionary *settings = blurBarSettings();
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
    
    CKBlurView *blurBar = [self sharedBlurBar];
 	[blurBar setTintColorFilter:tintFilter];
	blurBar.blurCroppingRect = blurBar.frame;
	blurBar.blurRadius = [settings[@"blurAmount"] floatValue] ?: 10.0;
	blurBar.alpha = 1.0; // [settings[@"blurAlpha"] floatValue] ?: 1.0;

	if ([settings[@"isMilky"] boolValue]) {
		[blurBar makeMilky];
	}
}

%new + (void)blurBarSizeToFit {
	NSDictionary *settings = blurBarSettings();
	CGFloat blurSize = [settings[@"blurSize"] floatValue];

	CGRect statusFrame = [UIApplication sharedApplication].statusBar.frame;
	if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
		CGFloat height = statusFrame.size.height;
		statusFrame.size.height = statusFrame.size.width;
		statusFrame.size.width = height;
	}

	statusFrame.origin.x = 0.0;
	statusFrame.size.height *= (blurSize > 0.0 ? blurSize : 1.0);

    CKBlurView *blurBar = [self sharedBlurBar];
	blurBar.frame = statusFrame;
}

%end

%hook SBLockScreenManager

- (void)_finishUIUnlockFromSource:(int)source withOptions:(id)options { 
	%orig();

	blurBar_settings = [NSDictionary dictionaryWithContentsOfFile:PREFS_PATH];

	UIStatusBarBackgroundView *statusBarBackgroundView = MSHookIvar<UIStatusBarBackgroundView *>([UIApplication sharedApplication].statusBar, "_backgroundView");
	
	CKBlurView *blurBar = [%c(UIStatusBarBackgroundView) sharedBlurBar];
	// [[UIApplication sharedApplication].statusBar insertSubview:blurBar atIndex:0];

	[%c(UIStatusBarBackgroundView) blurBarLayoutFromPreferences];
	[%c(UIStatusBarBackgroundView) blurBarSizeToFit];

	NSLog(@"[BlurBar] Finished unlock from %i, settings %@, blurbar: %@", source, blurBar_settings, blurBar);
}

%end

%ctor {
	[[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidChangeStatusBarOrientationNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification){
		[%c(UIStatusBarBackgroundView) blurBarSizeToFit];
	}];
}