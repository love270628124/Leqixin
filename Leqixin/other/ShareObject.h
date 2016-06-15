//
//  ShareObject.h
//  SDWTestProduct
//
//  Created by Raija on 16/4/13.
//  Copyright © 2016年 Lqing. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "WeiboSDK.h"    //需要在项目Build Settings 中的 Other Linker Flags 添加 "-ObjC"

//引用头文件
#import <ShareSDKUI/ShareSDK+SSUI.h>

//引用弹窗
#import "AlertView.h"

typedef void(^shareResultBlock)(NSString *result, kAlertViewStyle style);

@interface ShareObject : NSObject <WXApiDelegate>

@property (nonatomic, copy) shareResultBlock block;

/**
 *  初始化分享平台并配置分享平台
 *  目前仅配置了新浪微博、微信、QQ平台
 *  微信、QQ没有安装客户端不显示分享平台
 **/
+ (ShareObject *)shareDefault;

///**
// *  msg 分享的内容
// **/
//- (void)sendMessage:(NSString *)msg;
///**
// *  带有返回值
// **/
//- (void)sendMessage:(NSString *)msg result:(shareResultBlock)result;
//
///**
// *  文字、图片分享
// *  （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，
// *  如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
// **/
//- (void)sendMessage:(id)msg withImages:(id)images;
//
//- (void)sendMessageWithTitle:(NSString *)title withContent:(NSString *)content withImages:(id)images result:(shareResultBlock)result;

- (void)sendMessageWithTitle:(NSString *)title withContent:(NSString *)content withUrl:(NSString *)aUrlString withImages:(id)images result:(shareResultBlock)result;

@end
