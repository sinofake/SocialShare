//
//  GlobalDefines.h
//  HuaErSlimmingRing
//
//  Created by sskh on 14-8-11.
//  Copyright (c) 2014年 sskh. All rights reserved.
//

#ifndef HuaErSlimmingRing_GlobalDefines_h
#define HuaErSlimmingRing_GlobalDefines_h

#define AppStoreID @"806920895"
//应用安装URL
#define AppStoreInstallURLFormat @"https://itunes.apple.com/cn/app/id%@?mt=8"

//应用更新URL
#define AppStoreUpdateURLFormat @"itms-apps://itunes.apple.com/app/id%@"

//应用评分URL
#define AppStoreRateURLFormat @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&pageNumber=0&sortOrdering=1&type=Purple+Software&mt=8"

#define IS_iPHONE5 ([[[UIApplication sharedApplication] delegate] window].frame.size.height > 500.0f)

#define UIColorFromHex(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0]

#define UIColorFromHexAndAlpha(hex, _a) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:_a]


#define UserDefaults [NSUserDefaults standardUserDefaults]

#define kDeviceUUID                     [[UIDevice currentDevice] identifierForVendor]

#define kScreenBounds                   [[UIScreen mainScreen] bounds]
#define kScreenWidth                       [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight                      [[UIScreen mainScreen] bounds].size.height

//E-Mail	\b([a-zA-Z0-9%_.+\-]+)@([a-zA-Z0-9.\-]+?\.[a-zA-Z]{2,6})\b
#define kEmailRegex @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
//#define kUserNameRegex                  @"^[A-Za-z0-9_]{3,18}(@([a-zA-Z0-9_-])+(\\.[a-zA-Z0-9_-]+)){0,1}$"
//#define kPasswordRegex                  @".{6,10}"

#define kPhoneNumberRegex               @"^(0|\\+86|86){0,1}(13[0-9]|15[0-9]|18[6-9])[0-9]{8}$"


#define kPICTURE_COMPRESS_RATIO 0.5 //图片压缩比率
#define APP_HAD_INSTALLED @"com.mili.AppHadInstalled"//本应用是否安装过

// block self
#define WEAK_SELF __weak __typeof(self)weakSelf = self;
#define STRONG_SELF __strong __typeof(weakSelf)strongSelf = weakSelf;


#ifdef DEBUG
//A better version of NSLog
#define NSLog(format, ...) do {                                                                          \
fprintf(stderr, "<%s : %d> %s\n",                                           \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
__LINE__, __func__);                                                        \
(NSLog)((format), ##__VA_ARGS__);                                           \
fprintf(stderr, "-------\n");                                               \
} while (0)
#else
#define NSLog(...) {}
#endif




#endif
