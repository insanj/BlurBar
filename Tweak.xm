#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#import "CKBlurView.h"

@interface UIStatusBarBackgroundView : UIView
-(id)initWithFrame:(CGRect)arg1 style:(id)arg2 backgroundColor:(id)arg3;
@end


%hook UIStatusBarBackgroundView
-(id)initWithFrame:(CGRect)arg1 style:(id)arg2 backgroundColor:(id)arg3{
	UIStatusBarBackgroundView *bar = %orig;
	CKBlurView *blurBar = [[CKBlurView alloc] initWithFrame:CGRectMake(0, -2, fmax([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height), 10.f)];
	[bar addSubview:blurBar];

	return bar;
}
%end