#import <Preferences/PSSpecifier.h>
#import <objc/runtime.h>

@interface PSViewController : UIViewController
@end

@interface PSListController : PSViewController{
	NSArray *_specifiers;
}

-(NSArray *)loadSpecifiersFromPlistName:(NSString *)name target:(id)target;
@end

@interface BlurBarPreferencesListController : PSListController
@end

@implementation BlurBarPreferencesListController

-(id)specifiers {
	if(!_specifiers)
		_specifiers = [[self loadSpecifiersFromPlistName:@"BlurBarPreferences" target:self] retain];

	return _specifiers;
}//end specifiers

-(void)twitter{
	if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot:"]])
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tweetbot:///user_profile/" stringByAppendingString:@"insanj"]]];

	else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitterrific:"]]) 
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitterrific:///profile?screen_name=" stringByAppendingString:@"insanj"]]];

	else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetings:"]]) 
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tweetings:///user?screen_name=" stringByAppendingString:@"insanj"]]];

	else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter:"]]) 
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitter://user?screen_name=" stringByAppendingString:@"insanj"]]];

	else 
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"https://mobile.twitter.com/" stringByAppendingString:@"insanj"]]];
}//end twitter

-(void)mail{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:me%40insanj.com?subject=BlurBar%20(1.1)%20Support"]];
}
@end