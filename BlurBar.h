#import <UIKit/UIKit.h>
#import <UIKit/UIApplication+Private.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#import <Foundation/NSDistributedNotificationCenter.h>
#import "CKBlurView.h"
#import "substrate.h"

#define PREFS_PATH [NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/com.insanj.blurbar.plist"]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface UIStatusBarBackgroundView : UIView

- (id)initWithFrame:(CGRect)arg1 style:(id)arg2 backgroundColor:(id)arg3;

@end

@interface UIStatusBar : UIView

- (id)_backgroundView;

@end

@interface CKBlurView (BlurBar)

- (NSDictionary *)blurBarSettings;
- (void)reloadBlurBarSettings:(NSNotification *)notification;

@end

@interface UIStatusBar (BlurBar)

+ (CKBlurView *)sharedBlurBar;
+ (void)blurBarLayoutFromPreferences;
+ (void)blurBarSizeToFit;

@end