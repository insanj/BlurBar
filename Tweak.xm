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
	int _lockState; // 1locked, 0unlocked
}

+(id)sharedController;
@end

@interface SBDeviceLockController (BlurBar)
-(BOOL)isLocked;
@end

%hook SBDeviceLockController
%new -(BOOL)isLocked{
	return (MSHookIvar<int>(self, "_lockState") == 1);
}
%end

static CKBlurView *blurBar;

%hook UIStatusBarBackgroundView
-(id)initWithFrame:(CGRect)arg1 style:(id)arg2 backgroundColor:(id)arg3{
	UIStatusBarBackgroundView *view = %orig;

	if(![[%c(SBDeviceLockController) sharedController] isLocked])
		[blurBar removeFromSuperview];

	else{
		//if(!blurBar || (blurBar && CGRectContainsRect(self.frame, blurBar.frame))){
			blurBar = [[CKBlurView alloc] initWithFrame:self.frame];
			blurBar.blurRadius = 10.f;
			blurBar.blurCroppingRect = blurBar.frame;
			blurBar.alpha = 1.f;
			[view addSubview:blurBar];
		//}
	}

	return view;
}
%end