//
//  JTChartView.h
//  JTChartView
//
//  Created by Jakub Truhlar on 01.07.15.
//  Copyright (c) 2015 Jakub Truhlar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JTChartView : UIView

@property (nonatomic,strong)NSArray *points;
@property (nonatomic,assign)CGPoint maxPoint;
@property (nonatomic,assign)CGPoint minPoint;
@property (nonatomic,assign)NSInteger maxPointIndex;
@property (nonatomic,assign)NSInteger minPointIndex;

@property (nonatomic,assign)double chartScale;

- (instancetype)initWithFrame:(CGRect)frame values:(NSArray *)values curveColor:(UIColor *)curveColor curveWidth:(CGFloat)curveWidth topGradientColor:(UIColor *)topGradientColor bottomGradientColor:(UIColor *)bottomGradientColor minY:(CGFloat)minY maxY:(CGFloat)maxY topPadding:(CGFloat)topPadding;

@end
