#include <IronSourceEx.h>
#include "RVViewController.m"

namespace ironsourceex {
	
	static RVViewController *rvViewController;
	static NSString *appkey;

	void init(const char *__appkey) {
		appkey = [NSString stringWithUTF8String:__appkey];

		rvViewController = [RVViewController alloc];

		[rvViewController init:appkey];
	}			

	void showRewarded() { 
		NSLog(@"%s", __PRETTY_FUNCTION__);
		[rvViewController showAd];
	}

}
