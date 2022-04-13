
#import "RVViewController.h"
#import <IronSource/IronSource.h>

@interface RVViewController () <ISRewardedVideoDelegate, ISImpressionDataDelegate>

@property (assign) BOOL sentResult;
@property (assign) BOOL giveReward;
@property (assign) BOOL waitReward;
@property (assign) BOOL videoWatched;

@end

@implementation RVViewController

extern "C" void ISsendAdsEvent(const char* event);


- (void)init:(NSString *)appkey {

	//[ISIntegrationHelper validateIntegration];
	//[IronSource setAdaptersDebug:YES];
	
	[IronSource setRewardedVideoDelegate:self];
	[IronSource addImpressionDataDelegate:self];
	[IronSource initWithAppKey:appkey];
}

- (void)showAd {
	NSLog(@"%s", __PRETTY_FUNCTION__);

	if ([IronSource hasRewardedVideo]) {

		self.sentResult = false;
		self.giveReward = false;
		self.waitReward = false;
		self.videoWatched = false;
		
		UIViewController *viewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
		
		[IronSource showRewardedVideoWithViewController:viewController];
	}
}

- (NSString *)getJsonFromObj:(id)obj {
	NSError *error;
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:0 error:&error];
	
	if (!jsonData) {
		NSLog(@"Got an error: %@", error);
		return @"";
	} else {
		NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
		return jsonString;
	}
}

- (void)impressionDataDidSucceed:(ISImpressionData *)impressionData
{
	NSLog(@"%s", __PRETTY_FUNCTION__);

	const char *jsonString=[self getJsonFromObj:[impressionData all_data]].UTF8String;

	//ISsendAdsEvent(jsonString);
}

- (void)rewardedVideoHasChangedAvailability:(BOOL)available {
	NSLog(@"%s", __PRETTY_FUNCTION__);

	if (available) {
		ISsendAdsEvent("IS_rewardedcanshow");
	}
}

- (void)didReceiveRewardForPlacement:(ISPlacementInfo *)placementInfo {
	NSLog(@"%s", __PRETTY_FUNCTION__);

	self.giveReward = true;

	if (!self.sentResult && self.waitReward)
	{
		ISsendAdsEvent("IS_rewardedcompleted");
		self.sentResult = true;
		self.waitReward = false;
	}
}

- (void)rewardedVideoDidClose {
	NSLog(@"%s", __PRETTY_FUNCTION__);
	
	if (self.giveReward && !self.sentResult)
	{
		ISsendAdsEvent("IS_rewardedcompleted");
		self.sentResult = true;
	}
	else if (!self.giveReward && self.videoWatched)
	{
		self.waitReward = true;
	}
	else if (!self.giveReward && !self.videoWatched && !self.sentResult)
	{
		ISsendAdsEvent("IS_rewardedskip");
		self.sentResult = true;
	}
	else if (!self.sentResult)
	{
		ISsendAdsEvent("IS_rewardedskip");
		self.sentResult = true;
	}
}

- (void)rewardedVideoDidFailToShowWithError:(NSError *)error {
	NSLog(@"%s", __PRETTY_FUNCTION__);

	self.sentResult = false;
	self.giveReward = false;
	self.waitReward = false;
	self.videoWatched = false;

	ISsendAdsEvent("IS_rewardedskip");
}

- (void)rewardedVideoDidStart {
	NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)rewardedVideoDidEnd {
	NSLog(@"%s", __PRETTY_FUNCTION__);

	self.videoWatched = true;
}

- (void)rewardedVideoDidOpen {
	NSLog(@"%s", __PRETTY_FUNCTION__);

	ISsendAdsEvent("IS_rewarded_displaying");
}

- (void)didClickRewardedVideo:(ISPlacementInfo *)placementInfo {
	NSLog(@"%s", __PRETTY_FUNCTION__);

	ISsendAdsEvent("IS_rewarded_click");
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (UITraitCollection *)traitCollection
{
	NSLog(@"%s", __PRETTY_FUNCTION__);

	if (@available(iOS 13.0, *)) {
		[UITraitCollection setCurrentTraitCollection:[[UITraitCollection alloc]init]];
	}
	return [[UITraitCollection alloc]init];
}

@end
