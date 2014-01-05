#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#import "CKBlurView.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

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
		NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/com.insanj.blurbar.plist"]];
		
		float blurAmount = [[settings objectForKey:@"blurAmount"] floatValue]==0?10.0f:[[settings objectForKey:@"blurAmount"] floatValue];
		CGRect blurFrame = view.frame;
		blurFrame.size.height *= [[settings objectForKey:@"blurSize"] floatValue]==0?1.0f:[[settings objectForKey:@"blurSize"] floatValue];
		float blurAlpha = [[settings objectForKey:@"blurAlpha"] floatValue]==0?1.0f:[[settings objectForKey:@"blurAlpha"] floatValue];

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
			case 15: //Silver
				blurTint = UIColorFromRGB(0xDDDDDD);
				break;
			case 16: //Teal!
				blurTint = UIColorFromRGB(0x39CCCC);
				break;
			case 17: //White
				blurTint = UIColorFromRGB(0xFFFFFF);
				break;	
			case 18: //Yellow
				blurTint = UIColorFromRGB(0xFFDC00);
				break;	
		}


		CKBlurView __block *previous = blurBar;
		blurBar = [[CKBlurView alloc] initWithFrame:blurFrame andColor:blurTint];
		blurBar.blurRadius = blurAmount;
		blurBar.blurCroppingRect = blurFrame;
		blurBar.alpha = 0.0f;
		[view addSubview:blurBar];
		[UIView animateWithDuration:0.5f animations:^{
			blurBar.alpha = blurAlpha; 
			previous.alpha = 0.f;
		} completion:^(BOOL finished){
			[previous removeFromSuperview];
			previous = nil;
			[previous release];
		}];

		NSLog(@"finished: %f, %@, %f, %@, %@", blurAmount, NSStringFromCGRect(blurFrame), blurAlpha, blurTint, previous);
	}

	return view;
}

-(void)dealloc{
	blurBar = nil;
	[blurBar release];

	%orig;
}
%end