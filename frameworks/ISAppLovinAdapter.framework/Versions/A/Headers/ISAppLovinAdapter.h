//
//  Copyright (c) 2015 IronSource. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IronSource/ISBaseAdapter+Internal.h"
#import "IronSource/ISMetaData.h"


static NSString * const AppLovinAdapterVersion = @"4.3.16";
static NSString * GitHash = @"8491b386d";

//System Frameworks For AppLovin Adapter

@import AdSupport;
@import AudioToolbox;
@import AVFoundation;
@import CoreGraphics;
@import CoreMedia;
@import CoreTelephony;
@import SafariServices;
@import StoreKit;
@import SystemConfiguration;
@import UIKit;
@import WebKit;

@interface ISAppLovinAdapter : ISBaseAdapter

@end
