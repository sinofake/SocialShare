//
//  AppDelegate.m
//  SSSocialShare
//
//  Created by sskh on 14/10/30.
//  Copyright (c) 2014年 sskh. All rights reserved.
//

#import "AppDelegate.h"


//分享
#import "ShareDefines.h"
#import "WeiboSDK.h"
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>

@interface AppDelegate ()<WeiboSDKDelegate, WBHttpRequestDelegate, WXApiDelegate, QQApiInterfaceDelegate, TencentSessionDelegate>
@property (nonatomic, strong) TencentOAuth *tencentOAuth;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [WeiboSDK registerApp:WEI_BO_APPKEY];
    
    [WXApi registerApp:WEI_XIN_APPKEY];
    
    self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQ_APPKEY andDelegate:self];
    
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSLog(@"url:%@", url);
    NSLog(@"sourceApplication:%@", sourceApplication);
    if ([sourceApplication isEqualToString:@"com.sina.weibo"]) {
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
    else if ([sourceApplication isEqualToString:@"com.tencent.xin"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    else if ([sourceApplication isEqualToString:@"com.tencent.mqq"]) {
        
        BOOL ret = [QQApiInterface handleOpenURL:url delegate:self];
        NSLog(@"%@", ret ? @"yes" : @"no");
        
        if (YES == [TencentOAuth CanHandleOpenURL:url])
        {
            return [TencentOAuth HandleOpenURL:url];
        }
    }
    return YES;
}

#pragma mark - WXApiDelegate
/*! @brief 收到一个来自微信的请求，第三方应用程序处理完后调用sendResp向微信发送结果
 *
 * 收到一个来自微信的请求，异步处理完成后必须调用sendResp发送处理结果给微信。
 * 可能收到的请求有GetMessageFromWXReq、ShowMessageFromWXReq等。
 * @param req 具体请求内容，是自动释放的
 */
-(void) onReq:(BaseReq*)req
{
    NSLog(@"req:%@", req);
}

/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp具体的回应内容，是自动释放的
 */
-(void) onResp:(BaseResp*)resp
{
    NSLog(@"resp:%@", resp);
}

#pragma mark - QQApiInterfaceDelegate
//qq的处理方法和微信的竟然是一样的
/**
 处理来至QQ的请求
 */
//- (void)onReq:(QQBaseReq *)req
//{
//    NSLog(@"req:%@", req);
//}

/**
 处理来至QQ的响应
 */
//- (void)onResp:(QQBaseResp *)resp
//{
//    NSLog(@"resp:%@", resp);
//}

/**
 处理QQ在线状态的回调
 */
- (void)isOnlineResponse:(NSDictionary *)response
{
    NSLog(@"response:%@", response);
}

#pragma mark - TencentSessionDelegate
/**
 * 登录成功后的回调
 */
- (void)tencentDidLogin{}

/**
 * 登录失败后的回调
 * \param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled{}

/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork{}

#pragma mark - WeiboSDKDelegate
/**
 收到一个来自微博客户端程序的请求
 
 收到微博的请求后，第三方应用应该按照请求类型进行处理，处理完后必须通过 [WeiboSDK sendResponse:] 将结果回传给微博
 @param request 具体的请求对象
 */
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    NSLog(@"request:%@", request);
}

/**
 收到一个来自微博客户端程序的响应
 
 收到微博的响应后，第三方应用可以通过响应类型、响应的数据和 WBBaseResponse.userInfo 中的数据完成自己的功能
 @param response 具体的响应对象
 */
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    NSLog(@"response:%@",response);
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        //        NSString *title = @"发送结果";
        NSString *message = [NSString stringWithFormat:@"响应状态: %d\n响应UserInfo数据: %@\n原请求UserInfo数据: %@",
                             response.statusCode, response.userInfo, response.requestUserInfo];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
        //                                                        message:message
        //                                                       delegate:nil
        //                                              cancelButtonTitle:@"确定"
        //                                              otherButtonTitles:nil];
        //        [alert show];
        
        NSLog(@"message:%@", message);
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class]){}
}


#pragma mark - WBHttpRequestDelegate

- (void)request:(WBHttpRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"response:%@, %d", response, [(NSHTTPURLResponse *)response statusCode]);
}
//- (void)request:(WBHttpRequest *)request didReceiveRawData:(NSData *)data;
- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error
{
    NSString *title = nil;
    UIAlertView *alert = nil;
    
    title = @"请求异常";
    alert = [[UIAlertView alloc] initWithTitle:title
                                       message:[NSString stringWithFormat:@"%@",error]
                                      delegate:nil
                             cancelButtonTitle:@"确定"
                             otherButtonTitles:nil];
    [alert show];
}
- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{
    NSLog(@"result:%@", result);
    NSString *title = nil;
    UIAlertView *alert = nil;
    
    title = @"收到网络回调";
    alert = [[UIAlertView alloc] initWithTitle:title
                                       message:[NSString stringWithFormat:@"%@",result]
                                      delegate:nil
                             cancelButtonTitle:@"确定"
                             otherButtonTitles:nil];
    [alert show];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
