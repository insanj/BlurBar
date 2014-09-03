#import "BlurBarPreferences.h"

@implementation BlurBarPreferencesListController

- (id)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"BlurBarPreferences" target:self] retain];
	}

	return _specifiers;
} 

- (void)loadView {
	[super loadView];

	[UISwitch appearanceWhenContainedIn:self.class, nil].onTintColor = TINT_COLOR;
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareTapped:)];
}

- (void)viewWillAppear:(BOOL)animated {
	self.view.tintColor = TINT_COLOR;
    self.navigationController.navigationBar.tintColor = self.view.tintColor;

	[super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];

	self.view.tintColor = nil;
    self.navigationController.navigationBar.tintColor = nil;
}

- (void)shareTapped:(UIBarButtonItem *)sender {
	NSString *text = @"I've fallen in love with blur, thanks to #BlurBar by @insanj!";
	NSURL *url = [NSURL URLWithString:@"http://insanj.github.io/BlurBar"];

	if (%c(UIActivityViewController)) {
		UIActivityViewController *viewController = [[[%c(UIActivityViewController) alloc] initWithActivityItems:[NSArray arrayWithObjects:text, url, nil] applicationActivities:nil] autorelease];
	
		[self.navigationController presentViewController:viewController animated:YES completion:NULL];
	}

	else if (%c(TWTweetComposeViewController) && [TWTweetComposeViewController canSendTweet]) {
		TWTweetComposeViewController *viewController = [[[TWTweetComposeViewController alloc] init] autorelease];
		viewController.initialText = text;
		[viewController addURL:url];
		
		[self.navigationController presentViewController:viewController animated:YES completion:NULL];
	}

	else {
		NSString *encodedText = [NSString stringWithFormat:@"https://twitter.com/intent/tweet?text=%@%%20%@", [text stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [url.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:encodedText]];
	}
}

- (void)twitter {
	NSURL *twitterURL;
	if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot:"]]) {
		twitterURL = [NSURL URLWithString:[@"tweetbot:///user_profile/" stringByAppendingString:@"insanj"]];
	}

	else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitterrific:"]]) {
		twitterURL = [NSURL URLWithString:[@"twitterrific:///profile?screen_name=" stringByAppendingString:@"insanj"]];
	}

	else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter:"]]) {
		twitterURL = [NSURL URLWithString:[@"twitter://user?screen_name=" stringByAppendingString:@"insanj"]];
	}

	else {
		twitterURL = [NSURL URLWithString:[@"https://mobile.twitter.com/" stringByAppendingString:@"insanj"]];
	}

	[[UIApplication sharedApplication] openURL:twitterURL];
}

- (void)mail {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:insanjmail%40gmail.com?subject=BlurBar%20(1.2)%20Support"]];
}

@end

@implementation BlurBarListItemsController

- (void)viewWillAppear:(BOOL)animated {
	self.view.tintColor = TINT_COLOR;
    self.navigationController.navigationBar.tintColor = self.view.tintColor;

	[super viewWillAppear:animated];
}

@end

@implementation BlurBarHelpListController

- (id)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"BlurBarHelpPreferences" target:self] retain];
	}

	return _specifiers;
}

- (void)viewWillAppear:(BOOL)animated {
	self.view.tintColor = TINT_COLOR;
    self.navigationController.navigationBar.tintColor = self.view.tintColor;

	[super viewWillAppear:animated];
}

@end