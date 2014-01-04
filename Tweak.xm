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

static CKBlurView *blurBar;

%hook UIStatusBarBackgroundView

%new -(void)lockStateChanged:(NSNotification *)notification{
	if([notification.userInfo[@"kSBNotificationKeyState"] boolValue])
		[blurBar removeFromSuperview];

	else{
		if(!blurBar || (blurBar && CGRectContainsRect(self.frame, blurBar.frame))){
			blurBar = [[CKBlurView alloc] initWithFrame:self.frame];
			blurBar.blurRadius = 10.f;
			blurBar.blurCroppingRect = blurBar.frame;
			blurBar.alpha = 1.f;
			[self addSubview:blurBar];
		}
	}
}

-(id)initWithFrame:(CGRect)arg1 style:(id)arg2 backgroundColor:(id)arg3{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lockStateChanged:) name:@"SBDeviceLockStateChangedNotification" object:nil];
	return %orig;
}

-(void)dealloc{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	%orig;
}
%end