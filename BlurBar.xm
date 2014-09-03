#import <UIKit/UIKit.h>
#import "Common.h"

#define isiOS7 (kCFCoreFoundationVersionNumber >= 847.20)
#define isiOS70 (isiOS7 && kCFCoreFoundationVersionNumber < 847.23)
#define isiOS71 (kCFCoreFoundationVersionNumber >= 847.23)

@interface SBWallpaperEffectView : UIView
- (id)initWithWallpaperVariant:(int)variant;
- (void)wallpaperDidChangeForVariant:(int)variant;
- (void)setStyle:(int)style;
@end

@interface SpringBoard
- (id)_accessibilityFrontMostApplication;
@end

@interface UIStatusBarBackgroundView : UIView
@end

@interface UIStatusBar : UIView
- (UIStatusBarBackgroundView *)_backgroundView;
@end

@interface UIApplication (Addition)
- (UIStatusBar *)statusBar;
@end

@interface SBLockScreenManager {
	BOOL _isUILocked;
}
+ (SBLockScreenManager *)sharedInstanceIfExists;
@end

@interface SBLockStateAggregator : NSObject
+ (id)sharedInstance;
- (BOOL)hasAnyLockState;
- (unsigned)lockState;
@end

static NSArray* _stylesFor70 = @[@9,
                               @16,@7,@6,@17,@10,@14,
                               @8,@11,
                               @12,@5,@3];

static NSArray* _stylesFor71 = @[@14,
                               @22,@9,@11,@23,@16,@20,
                               @12,@17,
                               @19,@3,@4];
                               
#define STYLEFOR70 [_stylesFor70[_styleIndex] intValue]
#define STYLEFOR71 [_stylesFor71[_styleIndex] intValue]

static NSInteger _styleIndex = 2;
static BOOL tweakEnabled = YES;

static void loadSettings()
{
	Boolean enabledExist;
	Boolean enabledValue = CFPreferencesGetAppBooleanValue(kBlurBarEnabledKey, kSpringBoard, &enabledExist);
	tweakEnabled = !enabledExist ? YES : enabledValue;
	
	Boolean keyExist;
	NSInteger index = CFPreferencesGetAppIntegerValue(kBlurBarStyle, kSpringBoard, &keyExist);
	_styleIndex = !keyExist ? 2 : index;
	if (_styleIndex < 0 || _styleIndex > 11)
		_styleIndex = 2;
}

static SBWallpaperEffectView *blurBar = nil;

static void updateBlurStyle()
{
	if (blurBar == nil)
		return;
	[blurBar setStyle:tweakEnabled ? (isiOS70 ? STYLEFOR70 : STYLEFOR71) : 0];
}

static void updateSource()
{
	if (blurBar != nil)
		[blurBar wallpaperDidChangeForVariant:1];
}

%hook SBLockScreenManager

- (void)lockUIFromSource:(int)source withOptions:(id)options
{
	%orig;
	updateSource();
}

- (void)_finishUIUnlockFromSource:(int)source withOptions:(id)options
{ 
	%orig;
	loadSettings();
	updateSource();
}

%end

%hook UIStatusBar

- (void)layoutSubviews
{
	%orig;
	//BOOL isUnlocked = [[%c(SBLockStateAggregator) sharedInstance] lockState] == 0
	UIStatusBarBackgroundView *backgroundView = (UIStatusBarBackgroundView *)[UIApplication sharedApplication].statusBar._backgroundView;
	if (objc_getClass("SBWallpaperEffectView") != nil) {
		if (blurBar == nil)
			blurBar = [[%c(SBWallpaperEffectView) alloc] initWithWallpaperVariant:1];
		blurBar.frame = [UIApplication sharedApplication].statusBar.frame;
		blurBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		loadSettings();
		[blurBar setStyle:tweakEnabled ? (isiOS70 ? STYLEFOR70 : STYLEFOR71) : 0];
		[backgroundView insertSubview:blurBar atIndex:[[backgroundView subviews] count]];
		updateBlurStyle();
	}
}

%end

static void update(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
	loadSettings();
	updateBlurStyle();
}

%hook SpringBoard

- (void)applicationDidFinishLaunching:(id)application
{
	%orig;
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, update, CFSTR(kNotifyKey), NULL, CFNotificationSuspensionBehaviorCoalesce);
}

%end
