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

%hook UIStatusBarBackgroundView

%new -(void)lockStateChanged:(NSNotification *)notification{
	CKBlurView *blurBar = objc_getAssociatedObject(self, @"blurBar");
	NSLog(@"&&&&& in here with %@, %@", notification, blurBar);

	if([notification.userInfo[@"kSBNotificationKeyState"] boolValue])
		blurBar.alpha = 0.5f;
	else{
		NSLog(@"&&&&& else");
		blurBar.alpha = 1.0f;
	}

	NSLog(@"&&&&& back to  %@, %@", notification, blurBar);
}

-(id)initWithFrame:(CGRect)arg1 style:(id)arg2 backgroundColor:(id)arg3{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lockStateChanged:) name:@"SBDeviceLockStateChangedNotification" object:nil];

	CKBlurView *blurBar = [[CKBlurView alloc] initWithFrame:self.frame];
	CKBlurView *loadBar = objc_getAssociatedObject(self, @"blurBar");
	if([objc_getAssociatedObject(self, @"savedBar") boolValue]){
		if(!CGRectContainsRect(loadBar.frame, blurBar.frame))
			blurBar = loadBar;
	}

	else
		objc_setAssociatedObject(self, @"savedBar", @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);

	UIStatusBarBackgroundView *view = %orig;
	blurBar.blurRadius = 10.f;
	blurBar.blurCroppingRect = blurBar.frame;
	blurBar.alpha = 0.5f;
	[view addSubview:blurBar];

	objc_setAssociatedObject(self, @"blurBar", blurBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	return view;
}

-(void)dealloc{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	%orig;
}
%end