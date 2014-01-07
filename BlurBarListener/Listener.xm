#import <libactivator/libactivator.h>
#import <UIKit/UIKit.h>
#import "../CKBlurView.h"

@interface BlurBarHideListener : NSObject <LAListener>
@end

@implementation BlurBarHideListener

-(void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event{
	[[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"CKHide" object:nil];
}

-(void)activator:(LAActivator *)activator abortEvent:(LAEvent *)event{
	//air
}

-(void)activator:(LAActivator *)activator otherListenerDidHandleEvent:(LAEvent *)event{
	//air
}

-(void)activator:(LAActivator *)activator receiveDeactivateEvent:(LAEvent *)event{
	//air
}

-(void)dealloc{
	[super dealloc];
}

+(void)load{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[[LAActivator sharedInstance] registerListener:[self new] forName:@"libactivator.BlurBarHideListener"];
	[pool release];
}

@end 

@interface BlurBarShowListener : NSObject <LAListener>
@end

@implementation BlurBarShowListener

-(void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event{
	[[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"CKShow" object:nil];
}

-(void)activator:(LAActivator *)activator abortEvent:(LAEvent *)event{
	//air
}

-(void)activator:(LAActivator *)activator otherListenerDidHandleEvent:(LAEvent *)event{
	//air
}

-(void)activator:(LAActivator *)activator receiveDeactivateEvent:(LAEvent *)event{
	//air
}

-(void)dealloc{
	[super dealloc];
}

+(void)load{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[[LAActivator sharedInstance] registerListener:[self new] forName:@"libactivator.BlurBarShowListener"];
	[pool release];
}
@end 