#import <UIKit/UIKit.h>
#import <UIKit/UIApplication+Private.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#import "CKBlurView.h"

#import "CydiaSubstrate.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface UIStatusBarBackgroundView : UIView
-(id)initWithFrame:(CGRect)arg1 style:(id)arg2 backgroundColor:(id)arg3;
@end

static CKBlurView *blurBar;
void BlurBarCreateIntoBackgroundView(NSNotification *notification){
	NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/com.insanj.blurbar.plist"]];
	UIStatusBarBackgroundView *view = MSHookIvar<UIStatusBarBackgroundView *>([UIApplication sharedApplication].statusBar, "_backgroundView");
	NSLog(@"--- creating into %@ (%@) (%@)", view, settings, notification);
	
	float blurAmount = [[settings objectForKey:@"blurAmount"] floatValue];
	if(blurAmount == 0.f)
		blurAmount = 10.0f;

	CGRect blurFrame = view.frame;
	blurFrame.size.width = fmax(view.frame.size.height, view.frame.size.width);
	
	float blurAlpha = [[settings objectForKey:@"blurAlpha"] floatValue];
	if(blurAlpha == 0.f)
		blurAlpha = 1.0f;

	UIColor *blurTint; //Thanks, http://clrs.cc!
	switch([[settings objectForKey:@"blurTint"] intValue]){
		case 1: //Aqua
			blurTint = UIColorFromRGB(0x7FDBFF);
			break;
		case 2: //Black
			blurTint = UIColorFromRGB(0x111111);
			break;
		case 3: //Blue
			blurTint = UIColorFromRGB(0x0074D9);
			break;
		default: //Clear (case 4)
			blurTint = [UIColor clearColor];
			break;
		case 5: //Fuchsia
			blurTint = UIColorFromRGB(0xF012BE);
			break;
		case 6: //Grey
			blurTint = UIColorFromRGB(0xAAAAAA);
			break;
		case 7: //Green
			blurTint = UIColorFromRGB(0x2ECC40);
			break;
		case 8: //Lime
			blurTint = UIColorFromRGB(0x01FF70);
			break;
		case 9: //Maroon
			blurTint = UIColorFromRGB(0x85144B);
			break;
		case 10: //Navy
			blurTint = UIColorFromRGB(0x001F3F);
			break;
		case 11: //Olive
			blurTint = UIColorFromRGB(0x3D9970);
			break;
		case 12: //Orange
			blurTint = UIColorFromRGB(0xFF851B);
			break;
		case 13: //Purple
			blurTint = UIColorFromRGB(0xB10DC9);
			break;
		case 14: //Red
			blurTint = UIColorFromRGB(0xFF4136);
			break;
		case 15: //Teal!
			blurTint = UIColorFromRGB(0x39CCCC);
			break;
		case 16: //Yellow
			blurTint = UIColorFromRGB(0xFFDC00);
			break;	
	}

    const CGFloat *rgb = CGColorGetComponents(blurTint.CGColor);
    CAFilter *tintFilter = [CAFilter filterWithName:@"colorAdd"];
    [tintFilter setValue:@[@(rgb[0]), @(rgb[1]), @(rgb[2]), @(CGColorGetAlpha(blurTint.CGColor))] forKey:@"inputColor"];
    
	blurBar = [[CKBlurView alloc] initWithFrame:blurFrame];
 	[blurBar setTintColorFilter:tintFilter];
	blurBar.blurRadius = blurAmount;
	blurBar.blurCroppingRect = blurBar.frame;
	blurBar.alpha = 0.f;

	if([[settings objectForKey:@"isMilky"] boolValue])
		[blurBar makeMilky];

	if(notification && [notification.userInfo[@"kSBNotificationKeyState"] boolValue] && [[settings objectForKey:@"legacyHide"] boolValue])
		[blurBar setHidden:YES];

	else
		[blurBar setHidden:NO];

	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
		UIStatusBarBackgroundView *currView = MSHookIvar<UIStatusBarBackgroundView *>([UIApplication sharedApplication].statusBar, "_backgroundView");

		float blurSize = [[settings objectForKey:@"blurSize"] floatValue];
		if(blurSize > 0.f)
			blurFrame.size.height *= blurSize;
		[blurBar setFrame:blurFrame];

		[UIView animateWithDuration:0.25f animations:^{
			[currView addSubview:blurBar];
			blurBar.alpha = blurAlpha; 
			blurBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

		}];
	});
}

%ctor{
	[[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification){
		BlurBarCreateIntoBackgroundView(nil);
	}];

	[[NSNotificationCenter defaultCenter] addObserverForName:@"SBDeviceLockStateChangedNotification" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification){
		BlurBarCreateIntoBackgroundView(notification);
	}];
}