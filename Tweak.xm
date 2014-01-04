#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#import "CKBlurView.h"

@interface _UIScrollsToTopInitiatorView : UIView
@end

@interface UIStatusBarWindow : UIWindow {
    UIStatusBar *_statusBar;
}
@end

@interface UIStatusBarBackgroundView : UIView {
    BOOL _glowEnabled;
    UIImageView *_glowView;
    BOOL _suppressGlow;
}

-(id)_backgroundImageName;
-(id)_baseImage;
-(id)_glowImage;
-(void)_setGlowAnimationEnabled:(BOOL)arg1 waitForNextCycle:(BOOL)arg2;
-(void)_startGlowAnimationWaitForNextCycle:(BOOL)arg1;
-(void)_stopGlowAnimation;
-(BOOL)_styleCanGlow;
-(BOOL)_topCornersAreRounded;
-(void)dealloc;
-(id)initWithFrame:(CGRect)arg1 style:(id)arg2 backgroundColor:(id)arg3;
-(void)setGlowAnimationEnabled:(BOOL)arg1;
-(void)setSuppressesGlow:(BOOL)arg1;
-(id)style;
@end

@interface UIStatusBar : _UIScrollsToTopInitiatorView {
	UIStatusBarWindow *_statusBarWindow;
	UIStatusBarBackgroundView *_backgroundView;
}

-(UIStatusBar *)initWithFrame:(CGRect)arg1;
-(UIStatusBarWindow *)statusBarWindow;
-(UIStatusBarBackgroundView *)_backgroundView;
@end

%hook UIStatusBarBackgroundView
-(id)initWithFrame:(CGRect)arg1 style:(id)arg2 backgroundColor:(id)arg3{
	UIStatusBarBackgroundView *bar = %orig;
	CKBlurView *blurBar = [[CKBlurView alloc] initWithFrame:CGRectMake(0, -2, fmax([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height), 10.f)];
	[bar addSubview:blurBar];

	return bar;
}
%end