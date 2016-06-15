//
//  JSSDWProgressHUD.h
//  SDWTestProduct
//
//  Created by Raija on 16/3/30.
//  Copyright © 2016年 Lqing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSSDWProgressHUD : UIView

/**
 *  创建单例对象
 **/
+ (JSSDWProgressHUD *)shareProgressHud;
/**
 *  显示progressHUD
 **/
- (void)showWithSuperView:(UIView *)Sview;
/**
 *  隐藏progressHUD
 **/
- (void)hiddenProgressHud;

@end
