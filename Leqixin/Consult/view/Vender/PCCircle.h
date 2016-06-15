//
//  PCCircle.h
//  PCCirle
//
//  Created by 任行亚 on 15/10/21.
//  Copyright © 2015年 BLUEMOBI. All rights reserved.
//

#import <UIKit/UIKit.h>
#define   DEGREES_TO_RADIANS(degrees)  ((M_PI * degrees)/ 180)

@interface PCCircle : UIView

//起点 角度
@property(nonatomic) CGFloat startAngle;
//终点 角度
@property(nonatomic)CGFloat endInnerAngle;
//线宽
@property(nonatomic)CGFloat lineWith;
//百分比数字
@property (nonatomic)CGFloat percentage;
//基准圆环颜色
@property(nonatomic,strong)UIColor *unfillColor;
//显示圆环颜色
@property(nonatomic,strong)UIColor *fillColor;
//中心数据显示标签
@property (nonatomic ,strong)UILabel *centerLable;

- (instancetype) initWithFrame:(CGRect)frame;

@end
