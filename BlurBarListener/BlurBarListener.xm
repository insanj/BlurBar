#import "FSSwitchDataSource.h"
#import "FSSwitchPanel.h"
#import <notify.h>
#import "../Common.h"

@interface BlurBarListenerSwitch : NSObject <FSSwitchDataSource>
@end

@implementation BlurBarListenerSwitch

- (FSSwitchState)stateForSwitchIdentifier:(NSString *)switchIdentifier
{
	Boolean enabledExist;
	Boolean enabledValue = CFPreferencesGetAppBooleanValue(kBlurBarEnabledKey, kSpringBoard, &enabledExist);
	BOOL tweakEnabled = !enabledExist ? YES : enabledValue;
	return tweakEnabled ? FSSwitchStateOn : FSSwitchStateOff;
}

- (void)applyState:(FSSwitchState)newState forSwitchIdentifier:(NSString *)switchIdentifier
{
	if (newState == FSSwitchStateIndeterminate)
		return;

	CFBooleanRef enabled = newState == FSSwitchStateOn ? kCFBooleanTrue : kCFBooleanFalse;
	CFPreferencesSetAppValue(kBlurBarEnabledKey, enabled, kSpringBoard);
	CFPreferencesAppSynchronize(kSpringBoard);
	
	notify_post(kNotifyKey);
}

@end
