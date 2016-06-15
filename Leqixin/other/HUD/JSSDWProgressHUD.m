//
//  JSSDWProgressHUD.m
//  SDWTestProduct
//
//  Created by Raija on 16/3/30.
//  Copyright © 2016年 Lqing. All rights reserved.
//

#import "JSSDWProgressHUD.h"

#define Screen_W    [UIScreen mainScreen].bounds.size.width
#define Screen_H    [UIScreen mainScreen].bounds.size.height

@implementation JSSDWProgressHUD {
    UIWebView *webView;
}
static JSSDWProgressHUD *hud = nil;
//创建单例对象
+ (JSSDWProgressHUD *)shareProgressHud {
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        
        hud = [[JSSDWProgressHUD alloc] init];
    });
    
    return hud;
}

//显示HUD
- (void)showWithSuperView:(UIView *)Sview {
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    self.frame = CGRectMake(0, 0, width, height);
//    self.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:0.8];
    self.backgroundColor = [UIColor clearColor];
    
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:self.frame];
    bgImgView.image = [UIImage imageNamed:@"data_heidi"];
    [self addSubview:bgImgView];
    
    self.center = CGPointMake(Sview.center.x, Sview.center.y);
    [self progressHudWithSuperFrame:self.frame];
    
    [Sview addSubview:self];
//    [Sview insertSubview:self atIndex:100];
    
}
//隐藏HUD
- (void)hiddenProgressHud {
//    self.backgroundColor = [UIColor clearColor];
    [webView removeFromSuperview];
    [self removeFromSuperview];

}
//绘制progressHud
- (void)progressHudWithSuperFrame:(CGRect)Sframe {
    if (webView) {
        [webView removeFromSuperview];
        webView = nil;
    }
    
    //得到图片的路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"loading" ofType:@"gif"];
    //将图片转为NSData
    NSData *gifData = [NSData dataWithContentsOfFile:path];
    //创建一个webView，添加到界面
    webView = [[UIWebView alloc] initWithFrame:CGRectMake((Sframe.size.width - 1214/3)/2, (Sframe.size.height - 362/3) / 2, 1214/3, 362/3 + 64)];
    
    //加载数据
    [webView loadData:gifData MIMEType:@"image/gif" textEncodingName:@"loading" baseURL:[NSURL URLWithString:@""]];
    
    [self addSubview:webView];
    //自动调整尺寸
    webView.scalesPageToFit = YES;
    //禁止滚动
    webView.scrollView.scrollEnabled = NO;
    //设置透明效果
    webView.backgroundColor = [UIColor clearColor];
    webView.opaque = 0;
    webView.center = CGPointMake(self.center.x, self.center.y);
    
//    NSLog(@"webView%f\n%f",webView.center.y,SCREEN_H);
    
}


@end
