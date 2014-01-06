#import <Preferences/PSSpecifier.h>
#import <Twitter/Twitter.h>
#import <objc/runtime.h>
#define URL_ENCODE(string) [(NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)(string), NULL, CFSTR(":/=,!$& '()*+;[]@#?"), kCFStringEncodingUTF8) autorelease]

@interface PSViewController : UIViewController
@end

@interface PSListController : PSViewController{
	NSArray *_specifiers;
}

-(void)loadView;
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

//<3 HASHBANG
-(void)loadView{
	[super loadView];

	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareTapped:)];
}

-(void)shareTapped:(UIBarButtonItem *)sender {
	NSString *text = @"I've fallen in love with blur, thanks to #BlurBar by @insanj!";
	NSURL *url = [NSURL URLWithString:@"http://insanj.github.io/BlurBar"];

	if (%c(UIActivityViewController)) {
		UIActivityViewController *viewController = [[[%c(UIActivityViewController) alloc] initWithActivityItems:[NSArray arrayWithObjects:text, url, nil] applicationActivities:nil] autorelease];
		[self.navigationController presentViewController:viewController animated:YES completion:NULL];
	} else if (%c(TWTweetComposeViewController) && [TWTweetComposeViewController canSendTweet]) {
		TWTweetComposeViewController *viewController = [[[TWTweetComposeViewController alloc] init] autorelease];
		viewController.initialText = text;
		[viewController addURL:url];
		[self.navigationController presentViewController:viewController animated:YES completion:NULL];
	} else {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://twitter.com/intent/tweet?text=%@%%20%@", URL_ENCODE(text), URL_ENCODE(url.absoluteString)]]];
	}
}

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
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:me%40insanj.com?subject=BlurBar%20(1.2)%20Support"]];
}
@end