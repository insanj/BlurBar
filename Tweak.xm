#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>

@interface NSDistributedNotificationCenter : NSNotificationCenter
@end

@interface _UIBackdropViewSettings : NSObject
+(id)settingsForStyle:(int)arg1 graphicsQuality:(int)arg2;
+(id)settingsForStyle:(int)arg1;
-(void)setColorTint:(id)arg1;
-(void)setBlurRadius:(float)arg1;
-(void)setBlurHardEdges:(int)arg1;
@end

@interface _UIBackdropView : UIView
-(id)initWithFrame:(CGRect)arg1;
-(id)initWithFrame:(CGRect)arg1 autosizesToFitSuperview:(BOOL)arg2 settings:(id)arg3;
-(void)setBounds:(CGRect)arg1;
-(void)setBlursBackground:(BOOL)arg1;
-(void)setBlurQuality:(id)arg1;
@end

@interface SBUIController
-(void)_deviceLockStateChanged:(NSNotification *)changed;
@end

@interface UIStatusBarBackgroundView : UIView
-(id)initWithFrame:(CGRect)arg1 style:(id)arg2 backgroundColor:(id)arg3;
@end

%hook SBUIController
-(void)_deviceLockStateChanged:(NSNotification *)changed{
	%orig;

	NSNumber *state = changed.userInfo[@"kSBNotificationKeyState"];
	[[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"BBStateChange" object:nil userInfo:@{@"wasLocked" : @(state.boolValue)}];
}//end method
%end


%hook UIStatusBarBackgroundView
static _UIBackdropView *blurBar;

/*%new -(void)reactToDeviceStateChanged:(NSNotification *)changed{
	if(changed.userInfo[@"wasLocked"])
		[UIView animateWithDuration:0.5f animations:^{ [blurBar setAlpha:0.f]; } ];
	else
		[UIView animateWithDuration:0.5f animations:^{ [blurBar setAlpha:1.f]; } ];
}*/

-(id)initWithFrame:(CGRect)arg1 style:(id)arg2 backgroundColor:(id)arg3{
	//[[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(reactToDeviceStateChanged:) name:@"BBStateChange" object:nil];
	NSLog(@"&&&& trying %@", NSStringFromCGRect(arg1));
	if(blurBar && CGRectContainsRect(blurBar.frame, arg1))
		return %orig;
	NSLog(@"&&&& accepted %@", NSStringFromCGRect(arg1));


	UIStatusBarBackgroundView *bar = %orig;
	_UIBackdropViewSettings *blurBarSettings = [_UIBackdropViewSettings settingsForStyle:1 graphicsQuality:0];
	[blurBarSettings setBlurRadius:10.f];

	blurBar = [[_UIBackdropView alloc] initWithFrame:arg1 autosizesToFitSuperview:YES settings:blurBarSettings];
	[blurBar setBlurQuality:@"default"];

	//[blurBar setBounds:blurBar.frame];
	//[blurBar setBlurHardEdges:NO];
	//[blurBar setAlpha:1.0f];
	[bar addSubview:blurBar];

	return bar;
}

-(void)dealloc{
	blurBar = nil;
	[blurBar release];
	//[[NSDistributedNotificationCenter defaultCenter] removeObserver:self];
	%orig;
}
%end