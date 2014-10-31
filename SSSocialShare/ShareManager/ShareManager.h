//
//  ShareManager.h
//  HuaErSlimmingRing
//
//  Created by sskh on 14-9-18.
//  Copyright (c) 2014年 sskh. All rights reserved.
//

#import <Foundation/Foundation.h>

//作为infoDict中的key
extern NSString * const kShareMessageTitleKey;   //标题
extern NSString * const kShareMessageDescriptionKey; //描述
extern NSString * const kShareMessageTextKey; //NSString
extern NSString * const kShareMessageImageKey; //UIImage
extern NSString * const kShareMessageWebpageKey; //NSString

typedef NS_ENUM(NSInteger, ShareMessageTypeT) {
    ShareMessageTypeText = 0,   //文字
    ShareMessageTypeImage,      //图片
    ShareMessageTypeWebpage     //网页
};

typedef NS_ENUM(NSInteger, WeixinSceneTypeT) {
    WeixinSceneTypeSession  = 0,/**< 聊天界面    */
    WeixinSceneTypeTimeline = 1,/**< 朋友圈      */
    WeixinSceneTypeFavorite = 2,/**< 收藏        */
};

@interface ShareManager : NSObject
@property (nonatomic, readonly) NSString *defaultTitle;
@property (nonatomic, readonly) NSString *defaultDescription;
@property (nonatomic, readonly) NSString *defaultText;
@property (nonatomic, readonly) UIImage *defaultImage;
@property (nonatomic, readonly) NSString *defaultWebpage;


- (void)sendMessageToWeixinWithScene:(WeixinSceneTypeT)sceneType messageType:(ShareMessageTypeT)messageType infoDict:(NSDictionary *)infoDict;

- (void)sendMessageToQQWithType:(ShareMessageTypeT)messageType infoDict:(NSDictionary *)infoDict;

/**
 *  目前QQZone
 *  QQZone分享不支持纯文本分享，不支持纯图片分享, 所以这里只支持 ShareMessageTypeWebpage//网页类型
 *  @param messageType <#messageType description#>
 *  @param infoDict    <#infoDict description#>
 */
- (void)sendMessageToQQZoneWithType:(ShareMessageTypeT)messageType infoDict:(NSDictionary *)infoDict;

- (void)sendMessageToWeiboWithType:(ShareMessageTypeT)messageType infoDict:(NSDictionary *)infoDict;

@end
