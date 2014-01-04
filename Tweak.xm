#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#import "CKBlurView.h"

@interface UIStatusBarBackgroundView : UIView
-(id)initWithFrame:(CGRect)arg1 style:(id)arg2 backgroundColor:(id)arg3;
@end

%hook UIStatusBarBackgroundView

-(id)initWithFrame:(CGRect)arg1 style:(id)arg2 backgroundColor:(id)arg3{
	%orig;

	[[NSNotificationCenter defaultCenter] addObserverForName:@"SBDeviceLockStateChangedNotification" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification){
		if([notification.userInfo[@"kSBNotificationKeyState"] boolValue])
			[[self viewWithTag:1234] removeFromSuperview];

		else{
			CKBlurView *blurBar = [[CKBlurView alloc] initWithFrame:self.frame];
			blurBar.blurRadius = 10.f;
			blurBar.blurCroppingRect = blurBar.frame;
			blurBar.alpha = 1.0f;
			blurBar.tag = 1234;
			[self addSubview:blurBar];
		}
	}];

	return self;
}
%end