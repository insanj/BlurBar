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
static CKBlurView *blurBar;

-(id)initWithFrame:(CGRect)arg1 style:(id)arg2 backgroundColor:(id)arg3{
	if(blurBar && CGRectContainsRect(blurBar.frame, arg1))
		return %orig;

	UIStatusBarBackgroundView *bar = %orig;
	blurBar = [[CKBlurView alloc] initWithFrame:arg1];
	blurBar.blurRadius = 10.f;
	blurBar.blurCroppingRect = blurBar.frame;
	blurBar.alpha = 0.f;
	[bar addSubview:blurBar];

	__block CKBlurView *blockBar = blurBar;
	[[NSNotificationCenter defaultCenter] addObserverForName:@"SBDeviceLockStateChangedNotification" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification){
		NSLog(@"&&&& yo:%@, %@", notification, [notification.userInfo[@"kSBNotificationKeyState"] boolValue]?@"YES":@"NO");
		if([notification.userInfo[@"kSBNotificationKeyState"] boolValue])
			blockBar.alpha = 0.f;

		else
			blockBar.alpha = 1.f;
	}];

	return bar;
}

-(void)dealloc{	
	NSLog(@"&&&&& dealloc");
	blurBar = nil;
	[blurBar release];

	%orig;
}
%end