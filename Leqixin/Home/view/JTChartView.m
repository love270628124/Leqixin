//
//  JTChartView.m
//  JTChartView
//
//  Created by Jakub Truhlar on 01.07.15.
//  Copyright (c) 2015 Jakub Truhlar. All rights reserved.
//

#import "JTChartView.h"

@interface JTChartView()

@property (nonatomic, strong) NSArray *values;
@property (nonatomic, strong) UIColor *curveColor;
@property (nonatomic, assign) CGFloat curveWidth;
@property (nonatomic, strong) UIColor *topGradientColor;
@property (nonatomic, strong) UIColor *bottomGradientColor;
@property (nonatomic, assign) CGFloat minY;
@property (nonatomic, assign) CGFloat maxY;
@property (nonatomic, assign) CGFloat topPadding;


@end

@implementation JTChartView

-(CGPoint)maxPoint
{
    if (self.points == nil) {
        return CGPointZero;
    }
    _maxPoint = [self.points[0] CGPointValue];
    for (int i = 0; i<self.points.count; i++) {
        CGPoint p = [self.points[i] CGPointValue];;
        if (p.y<_maxPoint.y) {
            _maxPoint = p;
            _maxPointIndex = i;
        }
    }
    return _maxPoint;
}
-(CGPoint)minPoint
{
    if (self.points == nil) {
        return CGPointZero;
    }
    _minPoint = [self.points[0] CGPointValue];
    for (int i = 0; i<self.points.count; i++) {
        CGPoint p = [self.points[i] CGPointValue];;
        if (p.y>_minPoint.y) {
            _minPoint = p;
            _minPointIndex = i;
        }
    }
    return _minPoint;
}

#pragma mark - Initialize
- (instancetype)initWithFrame:(CGRect)frame values:(NSArray *)values curveColor:(UIColor *)curveColor curveWidth:(CGFloat)curveWidth topGradientColor:(UIColor *)topGradientColor bottomGradientColor:(UIColor *)bottomGradientColor minY:(CGFloat)minY maxY:(CGFloat)maxY topPadding:(CGFloat)topPadding {
    
    self = [super initWithFrame:frame];
    
    // NOTIFICATIONS
    [self createObservers];
    
    if (values.count < 1) {
        return self;
    }
    
    // DEFAULTS
    UIColor *curveColorDefault = curveColor ? curveColor : [UIColor blackColor];
    CGFloat curveWidthDefault = curveWidth ? curveWidth : 2.0;
    UIColor *topGradientColorDefault = topGradientColor ? topGradientColor : [UIColor grayColor];
    UIColor *bottomGradientColorDefault = bottomGradientColor ? bottomGradientColor : [UIColor lightGrayColor];
    CGFloat minYDefault = minY ? minY : 0.5;
    CGFloat maxYDefault = maxY ? maxY : 1.0;
    CGFloat topPaddingDefault = topPadding ? topPadding : 30.0;
    
    // STORE
    _values = values;
    _curveColor = curveColorDefault;
    _curveWidth = curveWidthDefault;
    _topGradientColor = topGradientColorDefault;
    _bottomGradientColor = bottomGradientColorDefault;
    _minY = minYDefault;
    _maxY = maxYDefault;
    _topPadding = topPaddingDefault;
    
    [self drawGraphWithValues:values inView:self minY:minYDefault maxY:maxYDefault topPadding:topPaddingDefault curveColor:curveColorDefault curveWidth:curveWidthDefault topGradientColor:topGradientColorDefault bottomGradientColor:bottomGradientColorDefault];
    
    return self;
}

#pragma mark - Base method
- (void)drawGraphWithValues:(NSArray *)values inView:(UIView *)superview minY:(CGFloat)minY maxY:(CGFloat)maxY topPadding:(CGFloat)topPadding curveColor:(UIColor *)curveColor curveWidth:(CGFloat)curveWidth topGradientColor:(UIColor *)topGradientColor bottomGradientColor:(UIColor *)bottomGradientColor {

    // CREATE CGPOINTS
    NSArray *points = [self pointsFromValues:values withinView:superview minY:minY maxY:maxY topPadding:topPadding];
    self.points = [points copy];
    // CREATE THE CURVE
    UIBezierPath *curve = [self quadCurvedPathWithPoints:points];
    
    // CREATE LAYER WITH CURVE
    CAShapeLayer *curveLayer = [self createLayerWithCurve:curve color:curveColor width:curveWidth];
  
    // CREATE GRADIENT LAYER
    CAGradientLayer *gradientLayer = [self createGradientWithTopColor:topGradientColor bottomColor:bottomGradientColor inView:superview];
    
    // CREATE MASK
    CAShapeLayer *maskLayer = [self createMaskWithCurve:curve withinView:superview];
    
    // APPLY IT
    [self setupLine:superview];

    gradientLayer.mask = maskLayer;
    [superview.layer addSublayer:gradientLayer];
    [superview.layer addSublayer:curveLayer];
    // 添加圆到path
    [self createLayerWithPoints:points superView:superview];
    
}
-(void)createLayerWithPoints:(NSArray *)points superView:(UIView *)superview
{
    for (NSUInteger i = 0; i < points.count; i++) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        NSValue *value = points[i];
        CGPoint p = [value CGPointValue];
        [path addArcWithCenter:p radius:5.0 startAngle:0.0 endAngle:M_PI*2 clockwise:YES];
        [path fill];
        CAShapeLayer *circleLayer = [[CAShapeLayer alloc]init];
        circleLayer.fillColor = [UIColor whiteColor].CGColor;
        if (CGPointEqualToPoint(p, self.maxPoint)) {
            circleLayer.fillColor = [UIColor yellowColor].CGColor;
        }
        if (CGPointEqualToPoint(p, self.minPoint)) {
            circleLayer.fillColor = [UIColor colorWithRed:249/255.0 green:116/255.0 blue:90/255.0 alpha:1.0].CGColor;

        }
        circleLayer.path = path.CGPath;
        circleLayer.shadowColor = [UIColor grayColor].CGColor;
        circleLayer.shadowOffset = CGSizeMake(0.0f, 3.0f);
        circleLayer.shadowOpacity = 0.8;
        [superview.layer addSublayer:circleLayer];
    }
    
}

-(void)setupLine:(UIView *)superview
{
    CGFloat height = superview.frame.size.height / 5;
    for (int j = 0; j<4; j++) {
        UIBezierPath *linePath = [UIBezierPath bezierPath];
        [linePath moveToPoint:CGPointMake(0.0f, height+j*height)];
        [linePath addLineToPoint:CGPointMake(superview.frame.size.width, height+j*height)];
        [linePath stroke];
        CAShapeLayer *shaper= [[CAShapeLayer alloc]init];
        shaper.path = linePath.CGPath;
        UIColor *color = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.4];
        shaper.strokeColor = color.CGColor;
        [superview.layer addSublayer:shaper];
        
    }
}
#pragma mark - Extremes
- (CGFloat)maxValueInArray:(NSArray *)values {
    
    CGFloat max = CGFLOAT_MIN;
    
    for (int i = 0; i < values.count; i++) {
        CGFloat value = [[values objectAtIndex:i] floatValue];
        if (value > max) {
            max = value;
        }
    }
    return max;
}

- (CGFloat)minValueInArray:(NSArray *)values {
    
    CGFloat min = CGFLOAT_MAX;
    
    for (int i = 0; i < values.count; i++) {
        CGFloat value = [[values objectAtIndex:i] floatValue];
        if (value < min) {
            min = value;
        }
    }
    return min;
}

#pragma mark - Array calculating
- (NSMutableArray *)pointsFromValues:(NSArray *)values withinView:(UIView *)superview minY:(CGFloat)minY maxY:(CGFloat)maxY topPadding:(CGFloat)topPadding {
    
    NSMutableArray *points = [NSMutableArray new];
    
    for (int i = 0; i < values.count; i++) {
        CGFloat gap = fabs(superview.frame.size.width / MAX(values.count - 1, 0));//x轴相邻点的间隔
        CGFloat pX = i * gap;
        CGFloat verticalMin = superview.frame.size.height * minY;
        CGFloat verticalMax = superview.frame.size.height * maxY;
        // Curve also needs a floor
        CGFloat pY = (superview.frame.size.height + topPadding) - ((([[values objectAtIndex:i] floatValue] / verticalMax) * verticalMin) + verticalMin);
        pY = isnan(pY) ? 0.0 : pY;
        
        CGPoint p = CGPointMake(pX, pY);
        [points addObject:[NSValue valueWithCGPoint:p]];
    }
    
    return points;
}



#pragma mark - Bezier curve handle
- (UIBezierPath *)quadCurvedPathWithPoints:(NSArray *)points {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    NSValue *value = points[0];
    CGPoint p1 = [value CGPointValue];
    [path moveToPoint:p1];
    
    if (points.count == 2) {
        value = points[1];
        CGPoint p2 = [value CGPointValue];
        [path addLineToPoint:p2];
        return path;
    }
    
    for (NSUInteger i = 1; i < points.count; i++) {
        value = points[i];
        CGPoint p2 = [value CGPointValue];
        
        CGPoint midPoint = [self midPointForPointOne:p1 pointTwo:p2];
        [path addQuadCurveToPoint:midPoint controlPoint:[self controlPointForPointOne:midPoint pointTwo:p1]];
        [path addQuadCurveToPoint:p2 controlPoint:[self controlPointForPointOne:midPoint pointTwo:p2]];
        p1 = p2;
    }
    
    return path;
}

- (CGPoint)midPointForPointOne:(CGPoint)p1 pointTwo:(CGPoint)p2 {
    
    return CGPointMake((p1.x + p2.x) / 2, (p1.y + p2.y) / 2);
}

- (CGPoint)controlPointForPointOne:(CGPoint)p1 pointTwo:(CGPoint)p2 {
    
    CGPoint controlPoint = [self midPointForPointOne:p1 pointTwo:p2];
    CGFloat diffY = fabs(p2.y - controlPoint.y);
    
    if (p1.y < p2.y) {
        controlPoint.y += diffY;
        
    } else if (p1.y > p2.y) {
        controlPoint.y -= diffY;
    }
    
    return controlPoint;
}

#pragma mark - Layers
- (CAShapeLayer *)createMaskWithCurve:(UIBezierPath *)curve withinView:(UIView *)superview {
    
    CAShapeLayer *mask = [CAShapeLayer new];
    mask.frame = superview.bounds;
    [curve addLineToPoint:CGPointMake(superview.frame.size.width, superview.frame.size.height)];
    [curve addLineToPoint:CGPointMake(0, superview.frame.size.height)];
    [curve closePath];
    mask.path = curve.CGPath;
    
    return mask;
}

- (CAShapeLayer *)createLayerWithCurve:(UIBezierPath *)curve color:(UIColor *)color width:(CGFloat)width {
    
    CAShapeLayer *shapeLayer = [CAShapeLayer new];
    shapeLayer.path = [curve CGPath];
    
    shapeLayer.strokeColor = color.CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = width;
    shapeLayer.fillRule = kCAFillRuleEvenOdd;
    [shapeLayer setLineCap:kCALineCapRound];
    
    return shapeLayer;
}

- (CAGradientLayer *)createGradientWithTopColor:(UIColor *)topColor bottomColor:(UIColor *)bottomColor inView:(UIView *)superview {
    
    CAGradientLayer *gradientLayer = [CAGradientLayer new];
    gradientLayer.frame = superview.bounds;
    gradientLayer.colors = @[(id)topColor.CGColor,
                             (id)bottomColor.CGColor];
    return gradientLayer;
}

#pragma mark - Orientation handle
- (void)createObservers {
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
}

//- (void)dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}

//- (void)orientationDidChange {
//    if (_values.count < 1) {
//        return;
//    }
//    
//    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
//    CGRect f = self.superview.bounds;
//    
//    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) {
//        f.size = CGSizeMake(f.size.height, f.size.width);
//    } else {
//        f.size = CGSizeMake(f.size.width, f.size.height);
//    }
//    self.frame = f;
//    
//    [self drawGraphWithValues:_values inView:self minY:_minY maxY:_maxY topPadding:_topPadding curveColor:_curveColor curveWidth:_curveWidth topGradientColor:_topGradientColor bottomGradientColor:_bottomGradientColor];
//}

@end
