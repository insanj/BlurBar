#import <libactivator/libactivator.h>
#import <UIKit/UIKit.h>
#import "../CKBlurView.h"

@interface UIStatusBarBackgroundView
-(void)toggleHidden;
@end

@interface BlurBarListener : NSObject <LAListener>
@end

@implementation BlurBarListener

-(void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event {
	[%c(UIStatusBarBackgroundView) toggleHidden];
}

-(void)activator:(LAActivator *)activator abortEvent:(LAEvent *)event {
	//air
}

-(void)activator:(LAActivator *)activator otherListenerDidHandleEvent:(LAEvent *)event {
	//air
}

-(void)activator:(LAActivator *)activator receiveDeactivateEvent:(LAEvent *)event {
	//air
}

-(void)dealloc {
	[super dealloc];
}

+(void)load {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[[LAActivator sharedInstance] registerListener:[self new] forName:@"libactivator.BlurBarListener"];
	[pool release];
}

@end 