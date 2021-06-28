package extension.ironsource;

import nme.JNI;
import nme.Lib;

class IronSource {

#if ios
	private static var __ISads_set_event_handle = Lib.load("ironsourceex","ISads_set_event_handle", 1);
#elseif android
	private static var instance:IronSource = new IronSource();
#end

	private static var initialized:Bool = false;
	public static var __init:IronSource->String->Void = JNI.createStaticMethod("org/haxe/extension/ironsource/IronSourceEx", "init", "(Lorg/haxe/lime/HaxeObject;Ljava/lang/String;)V");
	public static var __showRewarded:Void->Void = JNI.createStaticMethod("org/haxe/extension/ironsource/IronSourceEx", "showRewarded", "()V");
	private static var completeCB:Void->Void;
	private static var skipCB:Void->Void;
	private static var viewCB:Void->Void;
	private static var clickCB:Void->Void;
	private static var canshow:Bool = false;
	public static var onRewardedEvent:String->Void = null;


	public static function init(appkey:String) {
		if (initialized) return;
		initialized = true;
#if android
		try {
			__init(instance, appkey);
		} catch(e:Dynamic) {
			trace("IS REWARDED Error: "+e);
		}
#elseif ios
		try{
			var __init:String->Void = cpp.Lib.load("IronSourceEx","ironsourceex_init",1);
			__showRewarded = cpp.Lib.load("IronSourceEx","ironsourceex_show_rewarded",0);
			__init(appkey);

			__ISads_set_event_handle(ISnotifyListeners);
		}catch(e:Dynamic){
			trace("IS REWARDED iOS INIT Exception: "+e);
		}
#end
	}

	public static function canShowAds():Bool {
		trace("IronSource canShowAds", canshow);
		return canshow;
	}

	public static function showRewarded(cb, skip, displaying, click) {
		
		canshow = false;

		trace("try... IS showRewarded");

		completeCB = cb;
		skipCB = skip;
		viewCB = displaying;
		clickCB = click;


		try {
			__showRewarded();
		} catch(e:Dynamic) {
			trace("IS ShowRewarded Exception: " + e);
		}
	}

#if ios
	private static function ISnotifyListeners(inEvent:Dynamic)
	{
		var event:String = Std.string(Reflect.field(inEvent, "type"));

		if (event == "IS_rewardedcanshow")
		{
			canshow = true;
			trace("IS REWARDED CAN SHOW");
			return;
		}

		if (event == "IS_rewardedcompleted")
		{
			trace("IS REWARDED COMPLETED");
			dispatchEventIfPossibleIS("CLOSED");
			if (completeCB != null) completeCB();
		}
		else if (event == "IS_rewardedskip")
		{
			trace("IS REWARDED VIDEO IS SKIPPED");
			dispatchEventIfPossibleIS("CLOSED");
			if (skipCB != null) skipCB();
		}
		else if (event == "IS_rewarded_displaying")
		{
			trace("IS REWARDED VIDEO Displaying");
			dispatchEventIfPossibleIS("DISPLAY");
			if (viewCB != null) viewCB();
		}
		else if (event == "IS_rewarded_click")
		{
			trace("IS REWARDED VIDEO clicked");
			dispatchEventIfPossibleIS("CLICK");
			if (clickCB != null) clickCB();
		}
		
	}
#elseif android

	private function new() {}

	public function onRewardedCanShow()
	{
		canshow = true;
		trace("IS REWARDED CAN SHOW");
	}

	public function onRewardedDisplaying()
	{
		trace("IS REWARDED Displaying");
		dispatchEventIfPossibleIS("DISPLAY");
		if (viewCB != null) viewCB();
	}

	public function onRewardedClick()
	{
		trace("IS REWARDED click");
		dispatchEventIfPossibleIS("CLICK");
		if (clickCB != null) clickCB();
	}

	public function onRewardedCompleted()
	{
		trace("IS REWARDED COMPLETED");
		dispatchEventIfPossibleIS("CLOSED");
		if (completeCB != null) completeCB();
	}
	public function onVideoSkipped()
	{
		trace("IS REWARDED VIDEO IS SKIPPED");
		dispatchEventIfPossibleIS("CLOSED");
		if (skipCB != null) skipCB();
	}
	
#end

	private static function dispatchEventIfPossibleIS(e:String):Void
	{
		if (onRewardedEvent != null) {
			onRewardedEvent(e);
		}
		else {
			trace('no event handler');
		}
	}
	
}
