//
//  ComPassView.h
//  SDWTestProduct
//
//  Created by Raija on 16/3/30.
//  Copyright © 2016年 Lqing. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  对象初始化必须用 initWithFrame: 否则无效
 *  radius 的值必须小于 对象的高度
 **/
@interface ComPassView : UIView
/**
 *  Fvalue = [0,100] 控制旋转的角度
 **/
@property (nonatomic, assign) CGFloat Fvalue;
/**
 *  Sview 添加到的父视图
 **/
@property (nonatomic, strong) UIView *Sview;
/**
 *  radius 画环的半径 默认80.0
 **/
@property (nonatomic, assign) CGFloat radius;
/**
 *  strokeColor 画线的颜色 默认白色
 **/
@property (nonatomic, strong) UIColor *strokeColor;
/**
 *  lineWidth 画线的宽度 默认12.0
 **/
@property (nonatomic, assign) CGFloat lineWidth;
/**
 *  duration 动画执行时间 默认3.0
 **/
@property (nonatomic, assign) CGFloat duration;
/**
 *  totleScore 总询盘数
 **/
@property (nonatomic, assign) CGFloat totleScore;


/**
 *  初始化实例对象
 **/
- (id)initWithFrame:(CGRect)frame;
/**
 *  初始加载执行动画
 **/
//- (void)circularBeginAnimation;

@end
