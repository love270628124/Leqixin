//
//  AlertView.h
//  AlertView
//
//  Created by 郝鹏飞 on 15/12/9.
//  Copyright © 2015年 郝鹏飞. All rights reserved.
//
//  Fix by Raija on 16/4/8.
//

#import <UIKit/UIKit.h>
@class AlertView;

typedef NS_ENUM(NSInteger,kAlertViewStyle) {
    kAlertViewStyleDefault,
    kAlertViewStyleSuccess,
    kAlertViewStyleFail,
    kAlertViewStyleWarn,
};

typedef NS_ENUM(NSInteger,kAlerViewShowTime) {
    kAlerViewShowTimeDefault, //默认三秒
    kAlerViewShowTimeOneSecond,
    kAlerViewShowTimeTwoSeconds,
};

@protocol AlertViewDelegate <NSObject>
/**
 *  按钮点击事件
 *  buttonIndex是点击的按钮tag值
 *  str是输入框的值（现在只是一个输入框）
 **/
@optional
- (void)alertView:(AlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex withString:(NSString *)str;
/**
 *  提示窗消失事件
 **/
- (void)alertViewtimeFinishedToDo;

@end

@interface AlertView : UIView

@property (nonatomic,strong)id<AlertViewDelegate> delegate;
@property (nonatomic,assign)UIKeyboardType keyboardType;
@property (nonatomic,strong)NSIndexPath *indexPath;

@property (nonatomic,strong)NSString *locationStr;//抢单提示的用户位置

/**
 *  有标题、样式动画、按钮
 **/
- (instancetype)initWithTitle:(NSString *)title target:(id<AlertViewDelegate>)delegate style:(kAlertViewStyle)kAlertViewStyle buttonsTitle:(NSArray *)titles;
/**
 *  有标题、默认样式、文本、按钮
 **/
- (instancetype)initWithTitle:(NSString *)title content:(NSString *)msg target:(id<AlertViewDelegate>)delegate buttonsTitle:(NSArray *)titles;
/**
 *  有标题、默认样式、输入框、按钮
 **/
- (instancetype)initWithTitle:(NSString *)title target:(id<AlertViewDelegate>)delegate buttonsTitle:(NSArray *)titles;
/**
 *  有标题、样式动画、自动消失
 **/
- (instancetype)initWithTitle:(NSString *)title style:(kAlertViewStyle)kAlertViewStyle showTime:(kAlerViewShowTime)time;
/**
 *  有标题、文本、按钮(取消按钮tag=0，抢按钮tag=2)
 **/
- (instancetype)initWithObject:(NSString *)str target:(id<AlertViewDelegate>)delegate;

- (instancetype)initWithPopBirthdatePickerWithtarget:(id<AlertViewDelegate>)delegate;


/**
 *  显示
 **/
- (void)showInView:(UIView *)superView;

@end
