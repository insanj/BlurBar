#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#import "CKBlurView.h"

@interface UIStatusBarBackgroundView : UIView
-(id)initWithFrame:(CGRect)arg1 style:(id)arg2 backgroundColor:(id)arg3;
@end

%hook UIStatusBarBackgroundView
CKBlurView *blurBar;
NSNotification *lastNotification;

-(id)initWithFrame:(CGRect)arg1 style:(id)arg2 backgroundColor:(id)arg3{
	%orig;

	blurBar = [[CKBlurView alloc] initWithFrame:self.frame];
	blurBar.blurRadius = 10.f;
	blurBar.blurCroppingRect = blurBar.frame;
	blurBar.alpha = 0.1f;
	blurBar.tag = 1234;
	[self addSubview:blurBar];

	__block CKBlurView *blockBar = [blurBar retain];
	__block NSNotification *blockLast = [lastNotification retain];
	[[NSNotificationCenter defaultCenter] addObserverForName:@"SBDeviceLockStateChangedNotification" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification){
		if(!blockLast || ![notification isEqual:blockLast]){
			blockLast = notification;
			if([notification.userInfo[@"kSBNotificationKeyState"] boolValue])
				blockBar.alpha = 0.1f;

			else
				blockBar.alpha = 1.0f;
		}
	}];

	return self;
}

-(void)dealloc{
	blurBar = nil;
	[blurBar release];

	%orig;
}
%end