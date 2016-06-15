//
//  ComPassView.m
//  SDWTestProduct
//
//  Created by Raija on 16/3/30.
//  Copyright © 2016年 Lqing. All rights reserved.
//

#import "ComPassView.h"
#import "NSString+Extension.h"

#define Screen_W    [UIScreen mainScreen].bounds.size.width
#define Screen_H    [UIScreen mainScreen].bounds.size.height

@interface ComPassView () {
    UILabel *totalL,*zeroL,*thirtyL,*fiftyL,*seventy,*hundredL,*scoreL;
    UIColor *textColor;
    UIImageView *cirImgView;
}

@property (nonatomic, strong) CALayer *animationLayer;
@property (nonatomic, strong) UIImageView *pointImgView;

@end

@implementation ComPassView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        UIImageView *VbgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        VbgImgView.image = [UIImage imageNamed:@"bg_lansedi.png"];
        VbgImgView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:VbgImgView];
        
//        cirImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_yuan"]];
//        cirImgView.contentMode = UIViewContentModeScaleAspectFill;
//        cirImgView.center = self.center;
//        [self addSubview:cirImgView];
    }
    
    return self;
}

- (void)circularAnimationLayerWithRect:(CGRect)frame {
    //判断有没有修改初始值
    [self initWithDrawPathWithData];
    
//    _pointImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _radius - _lineWidth, _radius - _lineWidth)];
//    _pointImgView.image = [UIImage imageNamed:@"bg_shanxing.png"];
    
     _pointImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (_radius - _lineWidth - 6) * 2, (_radius - _lineWidth - 6) * 2)];
    _pointImgView.image = [UIImage imageNamed:@"bg_yuanpan"];
    _pointImgView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:_pointImgView];
    
    CALayer *centerCir = [[CALayer alloc] init];
    centerCir.frame = CGRectMake(0, 0, 10, 10);
    centerCir.cornerRadius = centerCir.frame.size.width / 2;
    centerCir.position = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2);
    centerCir.backgroundColor = [UIColor whiteColor].CGColor;
    [self.layer addSublayer:centerCir];
    //指针轨迹外侧圆
    UIBezierPath * path = [UIBezierPath bezierPath];
    //参数依次是：圆心坐标，半径，开始弧度，结束弧度   画线方向：yes为顺时针，no为逆时针
    [path addArcWithCenter:CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2)radius:_radius startAngle:M_PI * 3 / 4 endAngle:(M_PI * 6 / 4)/100 * _Fvalue - M_PI * 5 /4 clockwise:TRUE];
    CAShapeLayer * pathLayer = [CAShapeLayer layer];
    pathLayer.path = path.CGPath;
    pathLayer.strokeColor = _strokeColor.CGColor;//画线颜色
    pathLayer.fillColor = [[UIColor clearColor]CGColor];//填充颜色
    pathLayer.lineJoin = kCALineJoinRound;
    pathLayer.lineWidth = _lineWidth;
    [self.layer addSublayer:pathLayer];
    [self setAnimationLayer:pathLayer];//把pathLayer赋给属性animationLayer
    //指针轨迹圆
    UIBezierPath * path2 = [UIBezierPath bezierPath];
    //参数依次是：圆心坐标，半径，开始弧度，结束弧度   画线方向：yes为顺时针，no为逆时针
    [path2 addArcWithCenter:CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2)radius:_radius - _lineWidth startAngle:0 endAngle:(M_PI * 2 ) clockwise:TRUE];
    CAShapeLayer * pathLayer2 = [CAShapeLayer layer];
    pathLayer2.path = path2.CGPath;
//    pathLayer2.strokeColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.1].CGColor;//画线颜色
    pathLayer2.fillColor = [[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:0.15] CGColor];//填充颜色
    pathLayer2.lineJoin = kCALineJoinRound;
    pathLayer2.lineWidth = 6;
    [self.layer addSublayer:pathLayer2];
    
    
}

- (void)circularBeginAnimation {
    
    [self circularAnimationLayerWithRect:self.frame];
    [self drawCircularLayerWithFrame:self.frame];
    //画线动画
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = _duration;
    pathAnimation.fromValue = @(0);
    pathAnimation.toValue = @(1);
    [self.animationLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
    
    //指针旋转
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat:- M_PI * 3 / 4];
    rotationAnimation.toValue = [NSNumber numberWithFloat: (M_PI * 6 / 4)/100 * _Fvalue - (M_PI * 3 / 4)];
    rotationAnimation.duration = _duration;
    rotationAnimation.cumulative = NO;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
//    _pointImgView.layer.anchorPoint = CGPointMake(1, 1);
    _pointImgView.layer.position = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2);
    [_pointImgView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)drawRect:(CGRect)rect {
    [self circularBeginAnimation];
    
    //最外侧圆弧
    UIBezierPath * path = [UIBezierPath bezierPath];
    //参数依次是：圆心坐标，半径，开始弧度，结束弧度   画线方向：yes为顺时针，no为逆时针
    [path addArcWithCenter:CGPointMake(CGRectGetWidth(rect) / 2, CGRectGetHeight(rect) / 2)radius:_radius + _lineWidth startAngle:M_PI * 3 / 4 endAngle:(M_PI * 6 / 4)/100 * 100 - M_PI * 5 /4 clockwise:TRUE];
    CAShapeLayer * pathLayer = [CAShapeLayer layer];
    pathLayer.path = path.CGPath;
    pathLayer.strokeColor = [UIColor whiteColor].CGColor;//画线颜色
    pathLayer.fillColor = [[UIColor clearColor]CGColor];//填充颜色
    pathLayer.lineJoin = kCALineJoinRound;
    pathLayer.lineWidth = 1.5;
    [self.layer addSublayer:pathLayer];
    //总询盘数
    totalL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    totalL.text = [NSString stringWithFormat:@"总询盘数:%.0f",_totleScore];
    totalL.textColor = textColor;
    totalL.font = [UIFont systemFontOfSize:13];
    totalL.textAlignment = NSTextAlignmentCenter;
    CGSize titleSize = [totalL.text sizeWithFont:[UIFont systemFontOfSize:13]];
    totalL.frame = CGRectMake(0, 0, titleSize.width + 10, 30);
    totalL.center = CGPointMake(CGRectGetWidth(rect) - CGRectGetWidth(totalL.frame) / 2 - 8, CGRectGetMidY(rect) - _radius - _lineWidth * 2);
    totalL.layer.cornerRadius = 10.0;
    totalL.layer.borderColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.7].CGColor;
    totalL.layer.borderWidth = 1.5;
    totalL.adjustsFontSizeToFitWidth = YES;
    [self addSubview:totalL];
    //0
    zeroL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    zeroL.text = @"0";
    zeroL.textColor = textColor;
    zeroL.center = CGPointMake(CGRectGetMidX(rect) - _radius * 4 / 5, CGRectGetMidY(rect) + _radius * 5 / 6);
    [self addSubview:zeroL];
    //30
    thirtyL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    thirtyL.text = @"30";
    thirtyL.textColor = textColor;
    thirtyL.center = CGPointMake(CGRectGetMidX(rect) - _radius, CGRectGetMidY(rect) - _radius * 3 / 4);
    [self addSubview:thirtyL];
    //50
    fiftyL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    fiftyL.text = @"50";
    fiftyL.textColor = textColor;
    fiftyL.center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect) - _radius - _lineWidth * 2);
    [self addSubview:fiftyL];
    //70
    seventy = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    seventy.text = @"70";
    seventy.textColor = textColor;
    seventy.center = CGPointMake(CGRectGetMidX(rect) + _radius + _lineWidth * 2, CGRectGetMidY(rect) - _radius * 3 / 4);
//    seventy.center = CGPointMake(CGRectGetMidX(rect) + _radius + _lineWidth, CGRectGetMidY(rect) - _radius * 3 / 4);
    [self addSubview:seventy];
    //100
    hundredL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    hundredL.text = @"100";
    hundredL.textColor = textColor;
    hundredL.textAlignment = NSTextAlignmentCenter;
    hundredL.center = CGPointMake(CGRectGetMidX(rect) +  _radius + _lineWidth, CGRectGetMidY(rect) + _radius * 5 / 6);
    [self addSubview:hundredL];
    //总接待率
    scoreL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
    scoreL.attributedText = [self mString];     //用的属性字符串
    scoreL.textColor = textColor;
    scoreL.textAlignment = NSTextAlignmentCenter;
    scoreL.adjustsFontSizeToFitWidth = YES;
    scoreL.center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect) + _radius + 20);
    [self addSubview:scoreL];
}

- (void)drawCircularLayerWithFrame:(CGRect)frame {
    
//    NSLog(@"draw circilar");
}

//对底部数字进行放大
- (NSMutableAttributedString *)mString {
    //把普通字符串变成属性化字符串
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"总接待率:%.0f%%",_Fvalue] ];
    //计算出要放大的字符串占的字符数
    int count = _Fvalue < 100 ? 3 : 4;
    if (_Fvalue<10) {
        count = 2;
    }
    //放大区间的字符
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30] range:NSMakeRange(5, count)];
    //返回属性字符串
    return str;
}

//默认值的定义
- (void)initWithDrawPathWithData {
    
    if (_radius == 0) {
        if (iPhone4) {
            
            _radius = 50;
        } else if (iPhone5){
            
            _radius = 60;
        } else {
            
            _radius = 70;
        }
        
    }
    
    if (_lineWidth == 0) {
        if (iPhone4) {
            
            _lineWidth = 8.0;
        } else if (iPhone5) {
            
            _lineWidth = 10.0;
        } else {
            
            _lineWidth = 12.0;
        }
        
    }
    
    
    
//    if (_radius == 0) {
//        _radius = 70;
//    }
    if (_strokeColor == nil) {
        _strokeColor = [UIColor whiteColor];
    }
//    if (_lineWidth == 0) {
//        _lineWidth = 12.0;
//    }
    if (_duration == 0) {
        _duration = 3.0;
    }
    //界面文字的颜色
    textColor = [UIColor whiteColor];
}

@end
