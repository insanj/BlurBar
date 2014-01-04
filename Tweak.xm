#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#import "CKBlurView.h"

@interface UIStatusBarBackgroundView : UIView
-(id)initWithFrame:(CGRect)arg1 style:(id)arg2 backgroundColor:(id)arg3;
-(void)dealloc;
@end

@interface UIStatusBarBackgroundView (BlurBar)
+(CKBlurView *)sharedBlurBar;
@end

%hook UIStatusBarBackgroundView
static CKBlurView *sharedBlurBar;
%new +(CKBlurView *)sharedBlurBar{
	static dispatch_once_t provider_token = 0;
    dispatch_once(&provider_token, ^{
        sharedBlurBar = [[[CKBlurView alloc] init] retain];
    });

	return sharedBlurBar;
}//end sharedProvider


-(id)initWithFrame:(CGRect)arg1 style:(id)arg2 backgroundColor:(id)arg3{
	__block CKBlurView *blurBar = [%c(UIStatusBarBackgroundView) sharedBlurBar];
	[[NSNotificationCenter defaultCenter] addObserverForName:@"SBDeviceLockStateChangedNotification" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
		
		NSLog(@"&&&& yo:%@, %@, %@", notification, [notification.userInfo[@"kSBNotificationKeyState"] boolValue]?@"YES":@"NO", blurBar);
		if([notification.userInfo[@"kSBNotificationKeyState"] boolValue])
			blurBar.alpha = 0.f;

		else
			blurBar.alpha = 1.f;
	}];

	if(CGRectContainsRect(blurBar.frame, arg1))
		return %orig;

	UIStatusBarBackgroundView *bar = %orig;
	blurBar.frame = arg1;
	blurBar.blurRadius = 10.f;
	blurBar.blurCroppingRect = blurBar.frame;
	blurBar.alpha = 0.f;
	
	[bar addSubview:blurBar];

	return bar;
}

-(void)dealloc{	
	sharedBlurBar = nil;
	[sharedBlurBar release];

	%orig;
}
%end