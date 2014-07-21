#import "BlurBarListener.h"

@implementation BlurBarListener

+ (void)load {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[[LAActivator sharedInstance] registerListener:[[self alloc] initForNotificationName:@"CKShow"] forName:@"com.insanj.blurbar.show"];
	[[LAActivator sharedInstance] registerListener:[[self alloc] initForNotificationName:@"CKHide"] forName:@"com.insanj.blurbar.hide"];
	[pool release];
}

- (id)initForNotificationName:(NSString *)notificationName {
	self = [super init];

	if (self) {
		_notificationName = notificationName;
	}

	return self;
}

- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event {
	[[NSDistributedNotificationCenter defaultCenter] postNotificationName:_notificationName object:nil];
}

- (void)dealloc {
	[_notificationName release];
	[super dealloc];
}

@end 
