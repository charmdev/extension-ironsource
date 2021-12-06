package org.haxe.extension.ironsource;

import org.json.JSONObject;
import android.util.Log;
import org.haxe.extension.Extension;
import org.haxe.lime.HaxeObject;
import android.opengl.GLSurfaceView;

import com.ironsource.mediationsdk.IronSource;
import com.ironsource.mediationsdk.integration.IntegrationHelper;
import com.ironsource.mediationsdk.logger.IronSourceError;
import com.ironsource.mediationsdk.model.Placement;
import com.ironsource.mediationsdk.sdk.RewardedVideoListener;
import com.ironsource.mediationsdk.impressionData.ImpressionDataListener;
import com.ironsource.mediationsdk.impressionData.ImpressionData;


public class IronSourceEx extends Extension
{
	protected IronSourceEx () { }

	protected static HaxeObject _callback = null;
	protected static String TAG = "IronSource";
	protected static boolean giveReward = false;
	protected static boolean rewardSended = false;


	public static void init(HaxeObject callback, String appkey) {
		_callback = callback;
		//IntegrationHelper.validateIntegration(Extension.mainActivity);
		//IronSource.shouldTrackNetworkState(Extension.mainActivity, true);
		IronSourceEx.initIS(appkey, "");

		ImpressionDataListener mImpressionListener = new ImpressionDataListener() {

			@Override
			public void onImpressionSuccess(ImpressionData impressionData)
			{
				final JSONObject allData =  impressionData.getAllData(); 

				Log.d(TAG, "IS rewarded onImpressionSuccess" + allData.toString());

				if (Extension.mainView == null) return;
				GLSurfaceView view = (GLSurfaceView) Extension.mainView;
				view.queueEvent(new Runnable() {
					public void run() {
						_callback.call1("onRewardedImpressionData", allData.toString());
				}});
			}
		};

		IronSource.addImpressionDataListener(mImpressionListener);
	}

	public static void initIS(String appKey, String userId) {

		Extension.mainActivity.runOnUiThread(new Runnable() {
			public void run() {

				IronSource.setRewardedVideoListener(new RewardedVideoListener() {

					@Override
					public void onRewardedVideoAdClosed() {
						Log.d(TAG, "onRewardedVideoAdClosed " + giveReward + " " + rewardSended);

						if (giveReward && !rewardSended) {
							if (Extension.mainView == null) return;
							GLSurfaceView view = (GLSurfaceView) Extension.mainView;
							view.queueEvent(new Runnable() {
								public void run() {
									_callback.call("onRewardedCompleted", new Object[] {});
							}});

							Log.d(TAG, "onRewardedVideoAdClosed! giveReward");
						}
						else if (!giveReward && !rewardSended) {
							if (Extension.mainView == null) return;
							GLSurfaceView view = (GLSurfaceView) Extension.mainView;
							view.queueEvent(new Runnable() {
								public void run() {
									_callback.call("onVideoSkipped", new Object[] {});
							}});

							Log.d(TAG, "onRewardedVideoAdClosed! !giveReward");
						}

						giveReward = false;
						rewardSended = false;
					}
					
					@Override
					public void onRewardedVideoAvailabilityChanged(boolean available) {
						Log.d(TAG, "onRewardedVideoAvailabilityChanged " + available);

						if (available)
						{
							giveReward = false;
							rewardSended = false;

							if (Extension.mainView == null) return;
							GLSurfaceView view = (GLSurfaceView) Extension.mainView;
							view.queueEvent(new Runnable() {
								public void run() {
									_callback.call("onRewardedCanShow", new Object[] {});
							}});
						}
					}

					@Override
					public void onRewardedVideoAdRewarded(Placement placement) {
						Log.d(TAG, "onRewardedVideoAdRewarded" + " " + placement);
						giveReward = true;
						rewardSended = false;
					}
					
					@Override
					public void onRewardedVideoAdShowFailed(IronSourceError error) {
						Log.d(TAG, "onRewardedVideoAdShowFailed " + error);
						giveReward = false;
						rewardSended = false;

						if (Extension.mainView == null) return;
							GLSurfaceView view = (GLSurfaceView) Extension.mainView;
							view.queueEvent(new Runnable() {
								public void run() {
									_callback.call("onVideoSkipped", new Object[] {});
							}});
					}

					@Override
					public void onRewardedVideoAdOpened() {
						Log.d(TAG, "onRewardedVideoAdOpened");

						if (Extension.mainView == null) return;
						GLSurfaceView view = (GLSurfaceView) Extension.mainView;
						view.queueEvent(new Runnable() {
							public void run() {
								_callback.call("onRewardedDisplaying", new Object[] {});
						}});
					}
					
					
					@Override
					public void onRewardedVideoAdClicked(Placement placement) {
						Log.d(TAG, "onRewardedVideoAdClicked");

						if (Extension.mainView == null) return;
						GLSurfaceView view = (GLSurfaceView) Extension.mainView;
						view.queueEvent(new Runnable() {
							public void run() {
								_callback.call("onRewardedClick", new Object[] {});
						}});
					}

					@Override
					public void onRewardedVideoAdStarted() {
						Log.d(TAG, "onRewardedVideoAdStarted");
					}
					
					@Override
					public void onRewardedVideoAdEnded() {
						Log.d(TAG, "onRewardedVideoAdEnded");
						
					}
				});

			}
		});

		IronSource.init(Extension.mainActivity, appKey);
	}
	
	public static void showRewarded() {
		if (!IronSource.isRewardedVideoAvailable()) return;
		
		Extension.mainActivity.runOnUiThread(new Runnable() {
			public void run() {
				if (IronSource.isRewardedVideoAvailable()) {
					IronSource.showRewardedVideo();
				}
			}
		});
	}

}
