//
//  ShareObject.m
//  SDWTestProduct
//
//  Created by Raija on 16/4/13.
//  Copyright © 2016年 Lqing. All rights reserved.
//

#import "ShareObject.h"

@implementation ShareObject

+ (ShareObject *)shareDefault {
    
    static ShareObject *object = nil;
    
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        
        object = [[ShareObject alloc] init];
    });
    
    return object;
}

- (void)sendMessage:(NSString *)msg result:(shareResultBlock)result {
    self.block = result;
    
    if (msg == nil) {
        msg = @"分享内容";
    }
    
    NSArray *imgs = [NSArray arrayWithObjects:[UIImage imageNamed:@"smLogo"], nil];
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:msg
                                     images: imgs
                                        url:[NSURL URLWithString:msg]
                                      title:@"分享"
                                       type:SSDKContentTypeAuto];
    
    //2、分享（可以弹出我们的分享菜单）
    NSArray *items = @[
                       @(SSDKPlatformTypeSinaWeibo),
                       @(SSDKPlatformSubTypeWechatSession),
                       @(SSDKPlatformSubTypeWechatTimeline),
                       @(SSDKPlatformSubTypeQZone),
                       @(SSDKPlatformSubTypeQQFriend)];

    //调用分享的方法
    SSUIShareActionSheetController *sheet = [ShareSDK showShareActionSheet:nil
                                                                     items:items
                                                               shareParams:shareParams
                                                       onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                                                           
                                                           switch (state) {
                                                               case SSDKResponseStateSuccess:
                                                                   NSLog(@"分享成功!");
                                                                   self.block(@"0",kAlertViewStyleSuccess);
                                                                   break;
                                                               case SSDKResponseStateFail:
                                                                   NSLog(@"分享失败%@",error);
                                                                   self.block(@"1", kAlertViewStyleFail);
                                                                   break;
                                                                   
                                                               case SSDKResponseStateCancel:
                                                                   NSLog(@"分享已取消");
                                                                   self.block(@"2",kAlertViewStyleFail);
                                                                   break;
                                                                   
                                                               default:
                                                                   break;
                                                           }
                                                       }];
    
    //删除和添加平台示例
//    [sheet.directSharePlatforms removeObject:@(SSDKPlatformTypeWechat)];//(默认微信，QQ，QQ空间都是直接跳客户端分享，加了这个方法之后，可以跳分享编辑界面分享)
    [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeSinaWeibo)];//（加了这个方法之后可以不跳分享编辑界面，直接点击分享菜单里的选项，直接分享）
    
}

- (void)sendMessage:(NSString *)msg {
    
    if (msg == nil) {
        msg = @"分享内容";
    }
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:msg
                                     images:nil
                                        url:[NSURL URLWithString:@"http://www.leqixin.cc"]
                                      title:@"分享标题"
                                       type:SSDKContentTypeAuto];
    
    //2、分享（可以弹出我们的分享菜单）
    //调用分享的方法
    SSUIShareActionSheetController *sheet = [ShareSDK showShareActionSheet:nil
                                                                     items:nil
                                                               shareParams:shareParams
                                                       onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                                                           switch (state) {
                                                               case SSDKResponseStateSuccess:
                                                                   NSLog(@"分享成功!");
                                                               {
                                                                   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                                                       message:nil
                                                                                                                      delegate:self
                                                                                                             cancelButtonTitle:@"确定"
                                                                                                             otherButtonTitles:nil];
                                                                   [alertView show];
                                                               }
                                                                   break;
                                                               case SSDKResponseStateFail:
                                                                   NSLog(@"分享失败%@",error);
                                                               {
                                                                   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                                                                       message:nil
                                                                                                                      delegate:self
                                                                                                             cancelButtonTitle:@"确定"
                                                                                                             otherButtonTitles:nil];
                                                                   [alertView show];
                                                               }
                                                                   break;
                                                                   
                                                               case SSDKResponseStateCancel:
                                                                   NSLog(@"分享已取消");
                                                               {
                                                                   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"取消分享"
                                                                                                                       message:nil
                                                                                                                      delegate:self
                                                                                                             cancelButtonTitle:@"确定"
                                                                                                             otherButtonTitles:nil];
                                                                   [alertView show];
                                                               }
                                                                   break;
                                                                   
                                                               default:
                                                                   break;
                                                           }
                                                       }];
    //删除和添加平台示例
    [sheet.directSharePlatforms removeObject:@(SSDKPlatformTypeWechat)];//(默认微信，QQ，QQ空间都是直接跳客户端分享，加了这个方法之后，可以跳分享编辑界面分享)
    [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeSinaWeibo)];//（加了这个方法之后可以不跳分享编辑界面，直接点击分享菜单里的选项，直接分享）
    
#if 0
    //带有编辑界面
    [ShareSDK showShareActionSheet:nil
                             items:nil
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
        
                   switch (state) {
                       case SSDKResponseStateSuccess:
                       {
                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                               message:nil
                                                                              delegate:self
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil];
                           [alertView show];
                       }
                           
                           break;
                           
                       case SSDKResponseStateFail:
                       {
                           
                       }
                           
                           break;
                           
                       case SSDKResponseStateCancel:
                       {
                           
                       }
                           
                           break;
                           
                       default:
                           break;
                   }
    }];
    
#endif
    
}

- (void)sendMessage:(id)msg withImages:(id)images {
    //1、创建分享参数
    NSArray* imageArray = images;
    
    if (msg == nil) {
        msg = @"分享内容";
    }
    
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:msg
                                         images:imageArray
                                            url:[NSURL URLWithString:@"http://www.leqixin.cc"]
                                          title:@"分享标题"
                                           type:SSDKContentTypeAuto];
        //2、分享（可以弹出我们的分享菜单）
        //调用分享的方法
        SSUIShareActionSheetController *sheet = [ShareSDK showShareActionSheet:nil
                                                                         items:nil
                                                                   shareParams:shareParams
                                                           onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                                                               switch (state) {
                                                                   case SSDKResponseStateSuccess:
                                                                   {
                                                                       UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                                                           message:nil
                                                                                                                          delegate:self
                                                                                                                 cancelButtonTitle:@"确定"
                                                                                                                 otherButtonTitles:nil];
                                                                       [alertView show];
                                                                   }
                                                                       NSLog(@"分享成功!");
                                                                       break;
                                                                   case SSDKResponseStateFail:
                                                                       NSLog(@"分享失败%@",error);
                                                                   {
                                                                       UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                                                                           message:nil
                                                                                                                          delegate:self
                                                                                                                 cancelButtonTitle:@"确定"
                                                                                                                 otherButtonTitles:nil];
                                                                       [alertView show];
                                                                   }
                                                                       break;
                                                                   case SSDKResponseStateCancel:
                                                                       NSLog(@"分享已取消");
                                                                   {
                                                                       UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"取消分享"
                                                                                                                           message:nil
                                                                                                                          delegate:self
                                                                                                                 cancelButtonTitle:@"确定"
                                                                                                                 otherButtonTitles:nil];
                                                                       [alertView show];
                                                                   }
                                                                       break;
                                                                   default:
                                                                       break;
                                                               }
                                                           }];
        //删除和添加平台示例
//        [sheet.directSharePlatforms removeObject:@(SSDKPlatformTypeWechat)];//(默认微信，QQ，QQ空间都是直接跳客户端分享，加了这个方法之后，可以跳分享编辑界面分享)
        [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeSinaWeibo)];//（加了这个方法之后可以不跳分享编辑界面，直接点击分享菜单里的选项，直接分享）
        
    }

    
}

- (id)init {
    
    self = [super init];
    
    if (self) {
        //ShareSDK
        [ShareSDK registerApp:@"118c1a4addb00"
         //分享平台
              activePlatforms:@[
                                @(SSDKPlatformTypeSinaWeibo),
                                @(SSDKPlatformSubTypeWechatSession),
                                @(SSDKPlatformSubTypeWechatTimeline),
                                @(SSDKPlatformSubTypeQZone),
                                @(SSDKPlatformSubTypeQQFriend)]
         //连接平台SDK
                     onImport:^(SSDKPlatformType platformType) {
                         
                         switch (platformType) {
                             case SSDKPlatformTypeSinaWeibo:
                                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                                 break;
                             case SSDKPlatformTypeWechat:
                                 [ShareSDKConnector connectWeChat:[WXApi class]];
                                 break;
                             case SSDKPlatformTypeQQ:
                                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                                 break;
                                 
                             default:
                                 break;
                         }
                         
                     }
         //配置平台
              onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
                  
                  switch (platformType)
                  {
                      case SSDKPlatformTypeSinaWeibo:
                          //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                          [appInfo SSDKSetupSinaWeiboByAppKey:@"1871009870"
                                                    appSecret:@"fdb6323e176f5aed2d4a6ef5e03d4b80"
                                                  redirectUri:@"http://www.leqixin.cc"
                                                     authType:SSDKAuthTypeBoth];
                          break;
                      case SSDKPlatformTypeWechat:
                          [appInfo SSDKSetupWeChatByAppId:@"wx0b0b28d55a64f432"
                                                appSecret:@"c4280ffe32c7201fce88c9d2606f89f8"];
                          break;
                      case SSDKPlatformTypeQQ:
                          [appInfo SSDKSetupQQByAppId:@"1105259375"
                                               appKey:@"te8BnOHjfZqm03O5"
                                             authType:SSDKAuthTypeBoth];
                          break;
                          
                      default:
                          break;
                  }
              }];
        
    }
    
    return self;
}


- (void)sendMessageWithTitle:(NSString *)title withContent:(NSString *)content withImages:(id)images result:(shareResultBlock)result {
    
    self.block = result;
    
    //1、创建分享参数
    NSArray* imageArray = images;
    
    if ([title isEqualToString:@""]) {
        title = @"仕脉分享";
    }
    
    if ([content isEqualToString:@""]) {
        content = @"详情，请点击";
    }
    
    if (imageArray) {
        //@"http://www.leqixin.cc"
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:content
                                         images:imageArray
                                            url:[NSURL URLWithString:content]
                                          title:title
                                           type:SSDKContentTypeAuto];
        //2、分享（可以弹出我们的分享菜单）
        //调用分享的方法
        SSUIShareActionSheetController *sheet = [ShareSDK showShareActionSheet:nil
                                                                         items:nil
                                                                   shareParams:shareParams
                                                           onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                                                               
                                                               switch (state) {
                                                                   case SSDKResponseStateSuccess:
                                                                   {
                                                                       //                                                                       UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                       //                                                                                                                           message:nil
                                                                       //                                                                                                                          delegate:self
                                                                       //                                                                                                                 cancelButtonTitle:@"确定"
                                                                       //                                                                                                                 otherButtonTitles:nil];
                                                                       //                                                                       [alertView show];
                                                                   }
                                                                       
                                                                       self.block(@"0",kAlertViewStyleSuccess);
                                                                       
                                                                       NSLog(@"分享成功!");
                                                                       break;
                                                                   case SSDKResponseStateFail:
                                                                       NSLog(@"分享失败%@",error);
                                                                   {
                                                                       //                                                                       UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                       //                                                                                                                           message:nil
                                                                       //                                                                                                                          delegate:self
                                                                       //                                                                                                                 cancelButtonTitle:@"确定"
                                                                       //                                                                                                                 otherButtonTitles:nil];
                                                                       //                                                                       [alertView show];
                                                                   }
                                                                       
                                                                       self.block(@"1", kAlertViewStyleFail);
                                                                       
                                                                       break;
                                                                   case SSDKResponseStateCancel:
                                                                       NSLog(@"分享已取消");
                                                                   {
                                                                       //                                                                       UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"取消分享"
                                                                       //                                                                                                                           message:nil
                                                                       //                                                                                                                          delegate:self
                                                                       //                                                                                                                 cancelButtonTitle:@"确定"
                                                                       //                                                                                                                 otherButtonTitles:nil];
                                                                       //                                                                       [alertView show];
                                                                   }
                                                                       
                                                                       self.block(@"2",kAlertViewStyleFail);
                                                                       
                                                                       break;
                                                                   default:
                                                                       break;
                                                               }
                                                           }];
        //删除和添加平台示例
        //[sheet.directSharePlatforms removeObject:@(SSDKPlatformTypeWechat)];//(默认微信，QQ，QQ空间都是直接跳客户端分享，加了这个方法之后，可以跳分享编辑界面分享)
        [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeSinaWeibo)];//（加了这个方法之后可以不跳分享编辑界面，直接点击分享菜单里的选项，直接分享）
        
    }
    
    
}

- (void)sendMessageWithTitle:(NSString *)title withContent:(NSString *)content withUrl:(NSString *)aUrlString withImages:(id)images result:(shareResultBlock)result {
    
    self.block = result;
    
    //1、创建分享参数
    NSArray* imageArray = images;
    
    if (title == nil) {
        title = @"仕脉分享";
    }
    
    if (content == nil) {
        content = @"详情";
    }
    
    if (aUrlString == nil) {
        aUrlString = @"http://www.leqixin.cc";
    }
    
    if (imageArray) {
        //@"http://www.leqixin.cc"
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:content
                                         images:imageArray
                                            url:[NSURL URLWithString:aUrlString]
                                          title:title
                                           type:SSDKContentTypeAuto];
        
        UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_H - 64, SCREEN_W, 0)];
        [[UIApplication sharedApplication].keyWindow addSubview:container];
        
        [shareParams SSDKSetupSinaWeiboShareParamsByText:[NSString stringWithFormat:@"%@%@",content,aUrlString] title:title image:images url:[NSURL URLWithString:aUrlString] latitude:0.0 longitude:0.0 objectID:nil type:SSDKContentTypeAuto];
        
        //2、分享（可以弹出我们的分享菜单）
        //调用分享的方法
        SSUIShareActionSheetController *sheet = [ShareSDK showShareActionSheet:container
                                                                         items:nil
                                                                   shareParams:shareParams
                                                           onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                                                               
                                                               switch (state) {
                                                                   case SSDKResponseStateSuccess:
                                                                   {
                                                                       
                                                                   }
                                                                       
                                                                       self.block(@"0",kAlertViewStyleSuccess);
                                                                       
                                                                       NSLog(@"分享成功!");
                                                                       break;
                                                                   case SSDKResponseStateFail:
                                                                       NSLog(@"分享失败%@",error);
                                                                   {
                                                                       
                                                                   }
                                                                       
                                                                       self.block(@"1", kAlertViewStyleFail);
                                                                       
                                                                       break;
                                                                   case SSDKResponseStateCancel:
                                                                       NSLog(@"分享已取消");
                                                                   {
                                                                       
                                                                   }
                                                                       
                                                                       self.block(@"2",kAlertViewStyleFail);
                                                                       
                                                                       break;
                                                                   default:
                                                                       break;
                                                               }
                                                           }];
        //删除和添加平台示例
//        [sheet.directSharePlatforms removeObject:@(SSDKPlatformTypeWechat)];//(默认微信，QQ，QQ空间都是直接跳客户端分享，加了这个方法之后，可以跳分享编辑界面分享)
        [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeSinaWeibo)];//（加了这个方法之后可以不跳分享编辑界面，直接点击分享菜单里的选项，直接分享）
        
    }
    
}


@end
