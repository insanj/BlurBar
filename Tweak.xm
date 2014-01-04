#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#import "CKBlurView.h"

@interface UIStatusBarBackgroundView : UIView
-(id)initWithFrame:(CGRect)arg1 style:(id)arg2 backgroundColor:(id)arg3;
@end

@interface UIStatusBarBackgroundView (BlurBar)
-(void)lockStateChanged:(NSNotification *)notification;
@end

@interface SBDeviceLockController {
	int _lockState;
}

+(id)sharedController;
@end

@interface SBDeviceLockController (BlurBar)
-(BOOL)isUnlocked;
@end

%hook SBDeviceLockController
%new -(BOOL)isUnlocked{
	return (MSHookIvar<int>(self, "_lockState") != 1);
}
%end

static CKBlurView *blurBar;

%hook UIStatusBarBackgroundView
-(id)initWithFrame:(CGRect)arg1 style:(id)arg2 backgroundColor:(id)arg3{
	UIStatusBarBackgroundView *view = %orig;

	if([[%c(SBDeviceLockController) sharedController] isUnlocked])
		[UIView animateWithDuration:0.5f animations:^{ blurBar.alpha = 0.f; } completion:^(BOOL finished){ [blurBar removeFromSuperview]; }];

	else if(arg1.size.height <= 20.f){
		blurBar = [[CKBlurView alloc] initWithFrame:self.frame];
		blurBar.blurRadius = 10.f;
		blurBar.blurCroppingRect = blurBar.frame;
		blurBar.alpha = 0.f;
		[view addSubview:blurBar];
		[UIView animateWithDuration:0.5f animations:^{ blurBar.alpha = 1.f; }];
	}

	return view;
}
%end