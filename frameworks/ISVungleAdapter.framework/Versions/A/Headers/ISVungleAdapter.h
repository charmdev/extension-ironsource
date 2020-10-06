//
//  Copyright (c) 2015 IronSource. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IronSource/ISBaseAdapter+Internal.h"

static NSString * const VungleAdapterVersion = @"4.3.6";
static NSString * GitHash = @"64a40ef20";

//System Frameworks For Vungle Adapter

@import AdSupport;
@import AudioToolbox;
@import AVFoundation;
@import CFNetwork;
@import CoreGraphics;
@import CoreMedia;
@import Foundation;
@import MediaPlayer;
@import QuartzCore;
@import StoreKit;
@import SystemConfiguration;
@import UIKit;
@import WebKit;

@interface ISVungleAdapter : ISBaseAdapter

@end
