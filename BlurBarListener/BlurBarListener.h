#import <libactivator/libactivator.h>
#import <UIKit/UIKit.h>
#import "../CKBlurView.h"

@interface BlurBarListener : NSObject <LAListener>

@property(nonatomic, retain) NSString *notificationName;

- (id)initForNotificationName:(NSString *)notificationName;

@end