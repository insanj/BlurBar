#import <UIKit/UIKit.h>
#import <UIKit/UIApplication+Private.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#import "CKBlurView.h"

#import "substrate.h"

#define PREFS_PATH [NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/com.insanj.blurbar.plist"]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface UIStatusBarBackgroundView : UIView

- (id)initWithFrame:(CGRect)arg1 style:(id)arg2 backgroundColor:(id)arg3;

@end

@interface UIStatusBar : UIView

@end

@interface UIStatusBarBackgroundView (BlurBar)

+ (CKBlurView *)sharedBlurBar;
+ (void)blurBarLayoutFromPreferences;
+ (void)blurBarSizeToFit;

@end