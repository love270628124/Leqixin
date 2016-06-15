//
//  PCCircle.m
//  PCCirle
//
//  Created by 任行亚 on 15/10/21.
//  Copyright © 2015年 BLUEMOBI. All rights reserved.
//

#import "PCCircle.h"
//#import 

@interface PCCircle ()
{
    CGFloat radius;
}
@property(nonatomic) CGPoint CGPoinCerter;
@property(nonatomic) CGFloat endAngle;
@property(nonatomic) BOOL clockwise;

@end

@implementation PCCircle
//
//
//
- (instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.lineWith = 10.0;
        self.fillColor = [UIColor greenColor];
        self.unfillColor = [UIColor lightGrayColor];
        self.clockwise = YES;
        self.backgroundColor = [UIColor clearColor];
        self.percentage = 0.5;
        self.startAngle = 180;
        self.endAngle = 360;
        
       
    }
    return self;
}
#pragma mark setMethod
/**
 *  画图函数
 *
 *  @param rect rect description
 */
-(void)drawRect:(CGRect)rect{
    [self initData];
    [self drawMiddlecircle];
    [self drawOutCCircle];
}
/**
 *  参数设置
 */
-(void)initData{
    //中心标签设置
    CGFloat center =MIN(self.bounds.size.height/2, self.bounds.size.width/2);
    self.CGPoinCerter = CGPointMake(center, center);
    self.centerLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 2*center, 2*center)];
    self.centerLable.textAlignment=NSTextAlignmentCenter;
    self.centerLable.backgroundColor=[UIColor clearColor];
    self.centerLable.adjustsFontSizeToFitWidth = YES;
    self.centerLable.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.contentMode = UIViewContentModeRedraw;
    [self addSubview: self.centerLable];
    
    if(self.percentage>1){
        self.percentage = 1.0;
    }
    else if(self.percentage < 0){
        self.percentage = 0;
    }
    //半径计算
    radius = MIN(self.bounds.size.height/2-self.lineWith/2, self.bounds.size.width/2-self.lineWith/2);
    self.centerLable.font = [UIFont systemFontOfSize:radius/3];
    self.centerLable.text = [NSString stringWithFormat:@"%.0lf%%",self.percentage*100];
    //起点与终点坐标
    self.endInnerAngle = DEGREES_TO_RADIANS(self.endInnerAngle);
    self.startAngle = DEGREES_TO_RADIANS(self.startAngle);
    self.endAngle = self.percentage*(self.endInnerAngle - self.startAngle) + self.startAngle;
    //0%标签
    UILabel *zeroPercentLable = [[UILabel alloc]init];
    zeroPercentLable.text = [NSString stringWithFormat:@"0%%"];
    CGFloat zeroPercentLableX =radius + radius*cos(self.startAngle);
    CGFloat zeroPercentLableY = radius*sin(self.startAngle)+(self.startAngle>DEGREES_TO_RADIANS(180)?-radius:radius);
    zeroPercentLable.frame = CGRectMake(zeroPercentLableX, zeroPercentLableY+self.lineWith, 2.1*radius/7.5, 25);
    zeroPercentLable.textAlignment = NSTextAlignmentCenter;
    zeroPercentLable.font = [UIFont boldSystemFontOfSize:radius/7.5];
    zeroPercentLable.textColor = [UIColor orangeColor];
    [self addSubview:zeroPercentLable];
    //100%标签
    UILabel *hundredPercentLable = [[UILabel alloc]init];
    hundredPercentLable.text = [NSString stringWithFormat:@"100%%"];
    CGFloat hundredPercentLableX =radius + radius*cos(self.endInnerAngle)-8;
    CGFloat hundredPercentLableY = radius*sin(self.endInnerAngle)+(self.endInnerAngle<DEGREES_TO_RADIANS(180)?-radius:radius);
    hundredPercentLable.frame = CGRectMake(hundredPercentLableX, hundredPercentLableY+self.lineWith, 2.9*radius/7.5, 25);
    hundredPercentLable.textAlignment = NSTextAlignmentCenter;
    hundredPercentLable.font = [UIFont boldSystemFontOfSize:radius/7.5];
    hundredPercentLable.textColor = [UIColor orangeColor];
    [self addSubview:hundredPercentLable];
}
/**
 *  显示圆环
 */
-(void )drawOutCCircle{
    UIBezierPath *bPath = [UIBezierPath bezierPathWithArcCenter:self.CGPoinCerter radius:radius startAngle:self.startAngle endAngle:self.endAngle clockwise:self.clockwise];
    bPath.lineWidth=self.lineWith;
    bPath.lineCapStyle = kCGLineCapRound;
    bPath.lineJoinStyle = kCGLineJoinRound;
    [self.fillColor setStroke];
    [bPath stroke];
}
/**
 *  辅助圆环
 */
-(void)drawMiddlecircle{
    UIBezierPath *cPath = [UIBezierPath bezierPathWithArcCenter:self.CGPoinCerter radius:radius startAngle:self.startAngle endAngle:self.endInnerAngle clockwise:self.clockwise];
    cPath.lineWidth=self.lineWith;
    cPath.lineCapStyle = kCGLineCapRound;
    cPath.lineJoinStyle = kCGLineJoinRound;
    UIColor *color = self.unfillColor;
    [color setStroke];
    [cPath stroke];
}
@end
