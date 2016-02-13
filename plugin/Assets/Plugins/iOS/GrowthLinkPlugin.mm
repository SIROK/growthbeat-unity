//
//  GrowthLinkPlugin.mm
//

#include "GrowthLinkPlugin.h"
#import <GrowthLink/GrowthLink.h>

static GrowthLinkPlugin *_instance = [GrowthLinkPlugin sharedInstance];

@implementation GrowthLinkPlugin

#pragma mark Object Initialization

+ (GrowthLinkPlugin *)sharedInstance
{
	return _instance;
}

+ (void)initialize
{
	if (!_instance) {
		_instance = [[GrowthLinkPlugin alloc] init];
	}
}

- (id)init
{
	if (_instance != nil) {
		return _instance;
	}
	
	if ((self = [super init])) {
		_instance = self;
		UnityRegisterAppDelegateListener(self);
	}
	return self;
}

#pragma mark - App (Delegate) Lifecycle

- (void)onOpenURL:(NSNotification *)notification
{
	NSURL *url = notification.userInfo[@"url"];
	
	if ([GrowthLink instancesRespondToSelector:@selector(handleOpenUrl:)]) {
		[[GrowthLink sharedInstance] handleOpenUrl: url];
	}
}

@end
