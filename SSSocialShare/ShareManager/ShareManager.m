//
//  ShareManager.m
//  HuaErSlimmingRing
//
//  Created by sskh on 14-9-18.
//  Copyright (c) 2014年 sskh. All rights reserved.
//

#import "ShareManager.h"
#import "WXApi.h"
#import "WXApiObject.h"

#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/sdkdef.h>

#import "WeiboSDK.h"


NSString * const kShareMessageTitleKey = @"kShareMessageTitleKey";
NSString * const kShareMessageDescriptionKey = @"kShareMessageDescriptionKey";
NSString * const kShareMessageTextKey = @"kShareMessageTextKey";
NSString * const kShareMessageImageKey = @"kShareMessageImageKey";
NSString * const kShareMessageWebpageKey = @"kShareMessageWebpageKey";

@interface ShareManager ()
@property (nonatomic, strong) NSString *defaultTitle;
@property (nonatomic, strong) NSString *defaultDescription;
@property (nonatomic, strong) NSString *defaultText;
@property (nonatomic, strong) UIImage *defaultImage;
@property (nonatomic, strong) NSString *defaultWebpage;

@end

@implementation ShareManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _defaultTitle       = @"标题";
        _defaultDescription = @"描述";
        _defaultText        = @"我爱台妹，瘦宠爱我";
        _defaultImage       = [UIImage imageNamed:@"shareDefault.png"];
        _defaultWebpage     = [NSString stringWithFormat:AppStoreInstallURLFormat, AppStoreID];
    }
    return self;
}

#pragma mark - 产生缩略图
- (void)setThumbImage:(SendMessageToWXReq *)req
{
    if (self.defaultImage) {
        CGFloat width = 100.0f;
        CGFloat height = self.defaultImage.size.height * 100.0f / self.defaultImage.size.width;
        UIGraphicsBeginImageContext(CGSizeMake(width, height));
        [self.defaultImage drawInRect:CGRectMake(0, 0, width, height)];
        UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [req.message setThumbImage:scaledImage];
    }
}

#pragma mark - 
#pragma mark - 微信分享
- (void)sendMessageToWeixinWithScene:(WeixinSceneTypeT)sceneType messageType:(ShareMessageTypeT)messageType infoDict:(NSDictionary *)infoDict
{
    NSString *title = [self.defaultTitle copy];
    NSString *description = [self.defaultDescription copy];
    NSString *text = [self.defaultText copy];
    UIImage *image = [self.defaultImage copy];
    NSString *webpage = [self.defaultWebpage copy];
    if (infoDict) {
        title = infoDict[kShareMessageTitleKey];
        description = infoDict[kShareMessageDescriptionKey];
        text = infoDict[kShareMessageTextKey];
        image = infoDict[kShareMessageImageKey];
        webpage = infoDict[kShareMessageWebpageKey];
    }
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.scene = sceneType;
    
    switch (messageType) {
        case ShareMessageTypeText:
        {
            //req.bText = NO;//默认是NO
            req.bText = YES;
            if (!text) {
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"text不能为空" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [av show];
                return;
            }
            req.text = text;
            
            [WXApi sendReq:req];
        }
            break;
        case ShareMessageTypeImage:
        {
            //req.bText = NO;//默认是NO
            req.message = WXMediaMessage.message;
            
            if (title) {
                req.message.title = title;
            }
            if (description) {
                req.message.description = description;
            }
            
            [self setThumbImage:req];
            
            WXImageObject *imageObject = WXImageObject.object;
            imageObject.imageData = UIImageJPEGRepresentation(image, kPICTURE_COMPRESS_RATIO);
            if (!imageObject.imageData) {
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"image不能为空" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [av show];
                
                return;
            }
            req.message.mediaObject = imageObject;
            
            [WXApi sendReq:req];
        }
            break;
        case ShareMessageTypeWebpage:
        {
            //req.bText = NO;//默认是NO
            req.message = WXMediaMessage.message;
            
            if (title) {
                req.message.title = title;
            }
            if (description) {
                req.message.description = description;
            }
            
//            if (req.scene == WXSceneSession) {
//                req.message.description = description;
//                
//            } else if (req.scene == WXSceneTimeline) {
//                //分享到朋友圈的message.description貌似没用，所以下面这名注释掉
//                //req.message.description = @"瘦宠描述";
//            }
            
            [self setThumbImage:req];
            WXWebpageObject *webObject = WXWebpageObject.object;
            //    webObject.webpageUrl = @"https://itunes.apple.com/us/app/shou-chong/id806920895?l=zh&ls=1&mt=8";
            
            if (!webpage) {
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"webpage不能为空" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [av show];
                return;
            }
            webObject.webpageUrl = webpage;
            
            req.message.mediaObject = webObject;
            
            [WXApi sendReq:req];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -
#pragma mark - QQ分享
- (void)sendMessageToQQWithType:(ShareMessageTypeT)messageType infoDict:(NSDictionary *)infoDict
{
    NSString *title = [self.defaultTitle copy];
    NSString *description = [self.defaultDescription copy];
    NSString *text = [self.defaultText copy];
    UIImage *image = [self.defaultImage copy];
    NSString *webpage = [self.defaultWebpage copy];
    if (infoDict) {
        title = infoDict[kShareMessageTitleKey];
        description = infoDict[kShareMessageDescriptionKey];
        text = infoDict[kShareMessageTextKey];
        image = infoDict[kShareMessageImageKey];
        webpage = infoDict[kShareMessageWebpageKey];
    }
    
    NSData *imgData = nil;
    if (image) {
        imgData = UIImageJPEGRepresentation(image, kPICTURE_COMPRESS_RATIO);
    }
    
    switch (messageType) {
        case ShareMessageTypeText:
        {
            if (!text) {
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"text不能为空" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [av show];
                
                return;
            }
            QQApiTextObject *txtObj = [QQApiTextObject objectWithText:text];
            SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:txtObj];
            //将内容分享到qq
            QQApiSendResultCode sent = [QQApiInterface sendReq:req];
            NSLog(@"QQApiSendResultCode:%d", sent);
        }
            break;
        case ShareMessageTypeImage:
        {
            if (!imgData) {
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"image不能为空" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [av show];
                return;
            }
            
            QQApiImageObject *imgObj = [QQApiImageObject objectWithData:imgData
                                                       previewImageData:imgData
                                                                  title:title ?: @""
                                                            description:description ?: @""];
            SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
            QQApiSendResultCode sent = [QQApiInterface sendReq:req];
            NSLog(@"QQApiSendResultCode:%d", sent);
        }
            break;
        case ShareMessageTypeWebpage:
        {
            if (!webpage) {
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"webpage不能为空" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [av show];
                return;
            }
            
            NSURL *url = [NSURL URLWithString:webpage];
            
            QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:url
                                                    title:title ?: @""
                                           description:description ?: @""
                                                     previewImageData:imgData ?: nil];
            
            
            //预览图片从网络获取
            //QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:url title:title ?: @"" description:description ?: @"" previewImageURL:[NSURL URLWithString:@"http://t3.qpic.cn/mblogpic/d05a8de7423b76095d7c/460"]];
            
            NSLog(@"newsObj:%@", newsObj);
            
            SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
            QQApiSendResultCode sent = [QQApiInterface sendReq:req];
            NSLog(@"QQApiSendResultCode:%d", sent);
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -
#pragma mark - QQZone分享
- (void)sendMessageToQQZoneWithType:(ShareMessageTypeT)messageType infoDict:(NSDictionary *)infoDict
{
    NSString *title = [self.defaultTitle copy];
    NSString *description = [self.defaultDescription copy];
    NSString *text = [self.defaultText copy];
    UIImage *image = [self.defaultImage copy];
    NSString *webpage = [self.defaultWebpage copy];
    if (infoDict) {
        title = infoDict[kShareMessageTitleKey];
        description = infoDict[kShareMessageDescriptionKey];
        text = infoDict[kShareMessageTextKey];
        image = infoDict[kShareMessageImageKey];
        webpage = infoDict[kShareMessageWebpageKey];
    }
    switch (messageType) {
        case ShareMessageTypeText:
        {
            return;
        }
            break;
        case ShareMessageTypeImage:
        {
            return;
        }
            break;
        case ShareMessageTypeWebpage:
        {
            if (!webpage) {
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"webpage不能为空" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [av show];
                return;
            }
            
            NSURL *url = [NSURL URLWithString:webpage];
            
            NSData *imgData = nil;
            if (image) {
                imgData = UIImageJPEGRepresentation(image, kPICTURE_COMPRESS_RATIO);
            }
            
            QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:url
                                                                title:title ?: @""
                                                          description:description ?: @""
                                                     previewImageData:imgData ?: nil];
            
            
            //预览图片从网络获取
            //QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:url title:self.text description:@"瘦宠描述" previewImageURL:[NSURL URLWithString:@"http://t3.qpic.cn/mblogpic/d05a8de7423b76095d7c/460"]];
            
            NSLog(@"newsObj:%@", newsObj);
            
            SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
            QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
            NSLog(@"QQApiSendResultCode:%d", sent);
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark -
#pragma mark - 微博分享
- (void)sendMessageToWeiboWithType:(ShareMessageTypeT)messageType infoDict:(NSDictionary *)infoDict
{
    NSString *title = [self.defaultTitle copy];
    NSString *description = [self.defaultDescription copy];
    NSString *text = [self.defaultText copy];
    UIImage *image = [self.defaultImage copy];
    NSString *webpage = [self.defaultWebpage copy];
    if (infoDict) {
        title = infoDict[kShareMessageTitleKey];
        description = infoDict[kShareMessageDescriptionKey];
        text = infoDict[kShareMessageTextKey];
        image = infoDict[kShareMessageImageKey];
        webpage = infoDict[kShareMessageWebpageKey];
    }
    
    WBMessageObject *message = [WBMessageObject message];
    if (text) {
        message.text = text;
    }
    
    NSData *imgData = nil;
    if (image) {
        imgData = UIImageJPEGRepresentation(image, kPICTURE_COMPRESS_RATIO);
    }
    
    switch (messageType) {
        case ShareMessageTypeText:
        {
            if (!text) {
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"text不能为空" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [av show];
                return;
            }
            WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
            [WeiboSDK sendRequest:request];
        }
            break;
        case ShareMessageTypeImage:
        {
            WBImageObject *imageObject = [WBImageObject object];
            if (!imgData) {
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"image不能为空" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [av show];
                return;
            }
            imageObject.imageData = imgData;
            message.imageObject = imageObject;
            WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
            [WeiboSDK sendRequest:request];
        }
            break;
        case ShareMessageTypeWebpage:
        {
            if (!webpage) {
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"webpage不能为空" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [av show];
                return;
            }
            
            WBWebpageObject *webpageObject = [WBWebpageObject object];
            webpageObject.objectID = @"identifier1";
            webpageObject.title = title ?: @"";
            webpageObject.description = description ?: @"";
            webpageObject.thumbnailData = imgData ?: nil;
            webpageObject.webpageUrl = webpage;
            message.mediaObject = webpageObject;
            WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
            [WeiboSDK sendRequest:request];
        }
            break;
            
        default:
            break;
    }
}

@end
















