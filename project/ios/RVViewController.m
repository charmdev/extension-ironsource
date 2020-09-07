
#import "RVViewController.h"
#import <IronSource/IronSource.h>

@interface RVViewController () <ISRewardedVideoDelegate>

@property (nonatomic, strong) ISPlacementInfo   *rvPlacementInfo;
@property (assign) BOOL giveReward;

@end

@implementation RVViewController

extern "C" void ISsendAdsEvent(char* event);


- (void)init:(NSString *)appkey {

	//[ISIntegrationHelper validateIntegration];
	//[IronSource setAdaptersDebug:YES];
	
	[IronSource setRewardedVideoDelegate:self];
	[IronSource initWithAppKey:appkey];
}

- (void)showAd {
	NSLog(@"%s", __PRETTY_FUNCTION__);

	if ([IronSource hasRewardedVideo]) {

		UIWindow *windows = [[UIApplication sharedApplication].delegate window];
		UIViewController *vc = windows.rootViewController;

		[IronSource showRewardedVideoWithViewController:vc];
	}
}

- (void)rewardedVideoHasChangedAvailability:(BOOL)available {
	NSLog(@"%s", __PRETTY_FUNCTION__);

	if (available) {
		ISsendAdsEvent("ISrewardedcanshow");
		self.giveReward = false;
	}  
}

- (void)didReceiveRewardForPlacement:(ISPlacementInfo *)placementInfo {
	NSLog(@"%s", __PRETTY_FUNCTION__);

	self.giveReward = true;
}

- (void)rewardedVideoDidFailToShowWithError:(NSError *)error {
	NSLog(@"%s", __PRETTY_FUNCTION__);

	self.giveReward = false;
}

- (void)rewardedVideoDidOpen {
	NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)rewardedVideoDidClose {
	NSLog(@"%s", __PRETTY_FUNCTION__);
	
	if (self.giveReward)  {
	  ISsendAdsEvent("rewardedcompleted");
	}
	else {
		ISsendAdsEvent("rewardedskip");
	}
}

- (void)rewardedVideoDidStart {
	NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)rewardedVideoDidEnd {
	NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)didClickRewardedVideo:(ISPlacementInfo *)placementInfo {
	NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (UITraitCollection *)traitCollection
{
	NSLog(@"%s", __PRETTY_FUNCTION__);

	if (@available(iOS 13.0, *)) {
		[UITraitCollection setCurrentTraitCollection:[[UITraitCollection alloc]init]];
	} else {
		// Fallback on earlier versions
	};
	return [[UITraitCollection alloc]init];
}

@end
