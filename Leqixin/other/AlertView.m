//
//  AlertView.m
//  AlertView
//
//  Created by 郝鹏飞 on 15/12/9.
//  Copyright © 2015年 郝鹏飞. All rights reserved.
//
//  Fix by Raija on 16/4/8.
//

#import "AlertView.h"

#define kWidth [[UIScreen mainScreen] bounds].size.width
#define kHeight [[UIScreen mainScreen] bounds].size.height
#define AUTOLAYTOU(a) ((a)*(kWidth/320))
//#define WARN_WIDTH (self.frame.size.width-AUTOLAYTOU(120))
//fix
#define WARN_WIDTH (self.frame.size.width-AUTOLAYTOU(150))

#define DEFAULT_SHOW_TIME 3
#define ONESEC_SHOW_TIME 1
#define TWOSEC_SHOW_TIME 2

#define buttonColor [UIColor colorWithRed:0/255.0 green:152/255.0 blue:234/255.0 alpha:0.85]

@implementation AlertView {
    kAlertViewStyle style;
    UIView *_backView;
    UILabel *_titleLabel,*_contentLabel;
    NSTimer *_timer;
    NSInteger _showTime;
    UIImageView *_popup_bgImgView,*_duandai_bgImgView;
    UIButton *_rushBtn,*_shutdown;
    UITextField *inputTF;
    UIDatePicker *_datePicker;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
   
    switch (style) {
        case kAlertViewStyleDefault: {
            [self drawDefaultView];
            break;
        }
        case kAlertViewStyleSuccess: {
            [self drawSuccessView];
            break;
        }
        case kAlertViewStyleFail: {
            [self drawFailView];
            break;
        }
        case kAlertViewStyleWarn: {
            [self drawWarnView];
            break;
        }
        default: {
            break;
        }
    }

}

//...不懂why write this.
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor whiteColor];
//        self.layer.cornerRadius = 10;
//        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        self.layer.borderWidth = 1.0f;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title target:(id<AlertViewDelegate>)delegate style:(kAlertViewStyle)kAlertViewStyle buttonsTitle:(NSArray *)titles {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(50, 50, kWidth - AUTOLAYTOU(120), kWidth - AUTOLAYTOU(160));
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 1.0f;
        self.clipsToBounds = YES;
        self.delegate = delegate;
        style = kAlertViewStyle;
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth ,kHeight)];
        _backView.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:0.8];
//        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, WARN_WIDTH + 16, self.frame.size.width-20, AUTOLAYTOU(20))];
        //fix
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, WARN_WIDTH + 36, self.frame.size.width-20, AUTOLAYTOU(20))];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.text = title;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        for (int i = 0; i < titles.count; i ++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:titles[i] forState:UIControlStateNormal];
            button.frame = CGRectMake(i*self.frame.size.width/titles.count, WARN_WIDTH + 66 + AUTOLAYTOU(20) + 10, self.frame.size.width/titles.count, self.frame.size.height - (WARN_WIDTH + 66 + AUTOLAYTOU(20) + 10));
            button.tag = i + 1;

//            [button setBackgroundColor:[UIColor colorWithRed:29/255.0 green:206/255.0 blue:115/255.0 alpha:1.0]];
            [button setBackgroundColor:buttonColor];

            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
        }
        
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, WARN_WIDTH + 66 + AUTOLAYTOU(20) + 9.5, self.frame.size.width, 0.5)];
        topLine.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:topLine];
        for (int i = 0; i < titles.count - 1 ; i ++) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake((i + 1)*self.frame.size.width/titles.count, WARN_WIDTH + 66 + AUTOLAYTOU(20) + 10, 0.5, self.frame.size.height - (WARN_WIDTH + 66 + AUTOLAYTOU(20) + 10))];
            line.backgroundColor = [UIColor lightGrayColor];
            [self addSubview:line];
        }
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)msg target:(id<AlertViewDelegate>)delegate buttonsTitle:(NSArray *)titles {
    
    self = [super init];
    if (self) {
        self.frame = CGRectMake(50, 50, kWidth - AUTOLAYTOU(120), kWidth - AUTOLAYTOU(160));
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 1.0f;
        self.clipsToBounds = YES;
        self.delegate = delegate;
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth ,kHeight)];
        _backView.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:0.8];
        //titleLabel
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, WARN_WIDTH - 20, self.frame.size.width-20, AUTOLAYTOU(20))];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:20];
        _titleLabel.text = title;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        //contentLabel
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, WARN_WIDTH + 26, self.frame.size.width-20, AUTOLAYTOU(20))];
        _contentLabel.textColor = [UIColor blackColor];
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.text = msg;
        _contentLabel.numberOfLines = 0;
        _contentLabel.adjustsFontSizeToFitWidth = YES;
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_contentLabel];
        //button
        for (int i = 0; i < titles.count; i ++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:titles[i] forState:UIControlStateNormal];
            button.frame = CGRectMake(i*self.frame.size.width/titles.count, WARN_WIDTH + 46 + AUTOLAYTOU(20) + 10, self.frame.size.width/titles.count, self.frame.size.height - (WARN_WIDTH + 46 + AUTOLAYTOU(20) + 10));
            button.tag = i + 1;
            //[button setBackgroundColor:[UIColor blueColor]];
//            [button setBackgroundColor:[UIColor colorWithRed:29/255.0 green:206/255.0 blue:115/255.0 alpha:1.0]];
            [button setBackgroundColor:buttonColor];

            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
        }
        //topLine
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, WARN_WIDTH + 46 + AUTOLAYTOU(20) + 9.5, self.frame.size.width, 0.5)];
        topLine.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:topLine];
        
        for (int i = 0; i < titles.count - 1 ; i ++) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake((i + 1)*self.frame.size.width/titles.count, WARN_WIDTH + 46 + AUTOLAYTOU(20) + 10, 0.5, self.frame.size.height - (WARN_WIDTH + 46 + AUTOLAYTOU(20) + 10))];
            line.backgroundColor = [UIColor lightGrayColor];
            [self addSubview:line];
        }
        
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title target:(id<AlertViewDelegate>)delegate buttonsTitle:(NSArray *)titles {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(50, 50, kWidth - AUTOLAYTOU(120), kWidth - AUTOLAYTOU(160));
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 1.0f;
        self.clipsToBounds = YES;
        self.delegate = delegate;
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth ,kHeight)];
        _backView.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:0.8];
        //titleLabel
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, WARN_WIDTH - 30, self.frame.size.width-20, AUTOLAYTOU(20))];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:20];
        _titleLabel.text = title;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        if ([title isEqualToString:@"性别"]) {
            NSArray *butNames = @[@"男",@"女"];
            for (int i = 0; i < 2; i++) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button setTitle:butNames[i] forState:UIControlStateNormal];
                button.frame = CGRectMake(0, WARN_WIDTH + 35 + i * AUTOLAYTOU(40) , self.frame.size.width, AUTOLAYTOU(40));
                button.tag = i + 10;
                
                //                [button setBackgroundColor:[UIColor colorWithRed:29/255.0 green:206/255.0 blue:115/255.0 alpha:1.0]];
                button.layer.borderColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.1].CGColor;
                button.layer.borderWidth = 0.5f;
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:button];
                
            }
        } else {
        
            //contentLabel
            inputTF = [[UITextField alloc] initWithFrame:CGRectMake(10, WARN_WIDTH + 26, self.frame.size.width-20, 30)];
            inputTF.borderStyle = UITextBorderStyleRoundedRect;
            inputTF.placeholder = @"请输入...";
            [self addSubview:inputTF];
            //button
            for (int i = 0; i < titles.count; i ++) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button setTitle:titles[i] forState:UIControlStateNormal];
                button.frame = CGRectMake(i*self.frame.size.width/titles.count, WARN_WIDTH + 46 + AUTOLAYTOU(20) + 10, self.frame.size.width/titles.count, self.frame.size.height - (WARN_WIDTH + 46 + AUTOLAYTOU(20) + 10));
                button.tag = i + 1;
                //[button setBackgroundColor:[UIColor blueColor]];
//                [button setBackgroundColor:[UIColor colorWithRed:29/255.0 green:206/255.0 blue:115/255.0 alpha:1.0]];
                [button setBackgroundColor:buttonColor];

                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:button];
            }
            //topLine
            UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, WARN_WIDTH + 46 + AUTOLAYTOU(20) + 9.5, self.frame.size.width, 0.5)];
            topLine.backgroundColor = [UIColor lightGrayColor];
            [self addSubview:topLine];
            
            for (int i = 0; i < titles.count - 1 ; i ++) {
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake((i + 1)*self.frame.size.width/titles.count, WARN_WIDTH + 46 + AUTOLAYTOU(20) + 10, 0.5, self.frame.size.height - (WARN_WIDTH + 46 + AUTOLAYTOU(20) + 10))];
                line.backgroundColor = [UIColor lightGrayColor];
                [self addSubview:line];
            }
        }
    }
    return self;
    
}

- (instancetype)initWithTitle:(NSString *)title style:(kAlertViewStyle)kAlertViewStyle showTime:(kAlerViewShowTime)time {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(50, 50, kWidth - AUTOLAYTOU(120), kWidth - AUTOLAYTOU(180));
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 1.0f;
        self.clipsToBounds = YES;
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth ,kHeight)];
        _backView.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:0.8];
//        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, WARN_WIDTH + 16, self.frame.size.width-20, AUTOLAYTOU(20))];
        //fix
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, WARN_WIDTH + 36, self.frame.size.width-20, AUTOLAYTOU(20))];
        _titleLabel.textColor = [UIColor grayColor];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.text = title;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
        [self addSubview:_titleLabel];
        style = kAlertViewStyle;
        
        switch (time) {
            case kAlerViewShowTimeDefault: {
                _showTime = DEFAULT_SHOW_TIME;
                break;
            }
            case kAlerViewShowTimeOneSecond: {
                _showTime = ONESEC_SHOW_TIME;
                break;
            }
            case kAlerViewShowTimeTwoSeconds: {
                _showTime = TWOSEC_SHOW_TIME;
                break;
            }
            default: {
                break;
            }
        }
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
        [_timer fireDate];
    }
    return self;
}

- (instancetype)initWithObject:(NSString *)str target:(id<AlertViewDelegate>)delegate {
    
    self = [super init];
    if (self) {
        NSString *title = @"";
        NSString *content = @"";
        if (str == nil ) {
        } else {
            if ([str rangeOfString:@"IP:"].location != NSNotFound) {
             
                NSArray *strArray = [str componentsSeparatedByString:@"IP:"];
                title = strArray.firstObject;
                content = strArray.lastObject;
            } else {
                title = str;
            }
            
        }
        
        self.frame = CGRectMake(26, 26, kWidth - AUTOLAYTOU(26), kWidth - AUTOLAYTOU(90));
        self.backgroundColor = [UIColor clearColor];
        self.delegate = delegate;
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth ,kHeight)];
        _backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _popup_bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))] ;
        _popup_bgImgView.backgroundColor = [UIColor clearColor];
        _popup_bgImgView.image = [UIImage imageNamed:@"popup_bg"];
        _popup_bgImgView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_popup_bgImgView];
        //缎带
        _duandai_bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - 249)/2, 29, 249, 60)];
        _duandai_bgImgView.image = [UIImage imageNamed:@"duandai_bg"];
        _duandai_bgImgView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_duandai_bgImgView];
        //来访客户
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width - 200)/2, CGRectGetMaxY(_duandai_bgImgView.frame) + 40 * SCREEN_SCALE_H, 200, 30)];
        _titleLabel.text = title;
        _titleLabel.textColor = [UIColor colorWithRed:248/255.0 green:159/255.0 blue:17/255.0 alpha:1.0];  //248,159,17
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:16.0f];
//        _titleLabel.center = CGPointMake(_backView.center.x, _backView.center.y - 200);
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_titleLabel];
        //IP地址
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width - 200)/2,  CGRectGetMaxY(_titleLabel.frame) + 10 * SCREEN_SCALE_H, 200, 20)];
        _contentLabel.text = [NSString stringWithFormat:@"IP:%@",content];
        _contentLabel.textColor = [UIColor colorWithRed:248/255.0 green:159/255.0 blue:17/255.0 alpha:1.0];  //248,159,17
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.font = [UIFont systemFontOfSize:16.0f];
//        _contentLabel.center = CGPointMake(_backView.center.x, _backView.center.y - 160);
        [self addSubview:_contentLabel];
        //关闭按钮
        _shutdown = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shutdown setBackgroundImage:[UIImage imageNamed:@"bt_shutdown"]
                             forState:UIControlStateNormal];
        _shutdown.tag = 1;
        _shutdown.frame = CGRectMake(kWidth - AUTOLAYTOU(26) - 36, CGRectGetMidY(_backView.frame) - 274, 26, 50);
        [_shutdown addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_backView addSubview:_shutdown];
        //抢按钮
        _rushBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rushBtn setBackgroundImage:[UIImage imageNamed:@"icon_grap_chlick1"]
                           forState:UIControlStateNormal];
        _rushBtn.frame = CGRectMake(0, 0, 100, 100);
        _rushBtn.tag = 3;
        _rushBtn.center = CGPointMake(_backView.center.x, _backView.center.y + CGRectGetHeight(self.frame) / 2 + 4) ;
        [_rushBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_backView addSubview:_rushBtn];
        
//        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(setRushButtonAnimation) userInfo:nil repeats:YES];
        
    }
    return self;
}

- (void)timeChange {
    static int time = 0;
    if (time == _showTime) {
        [self removeFromSuperview];
        [_backView removeFromSuperview];
        _backView = nil;
        time = 0;
        [_timer invalidate];
        _timer = nil;
        if (_delegate) {
            [_delegate alertViewtimeFinishedToDo];
        }
        
    }
    time ++;
}
//默认弹窗提示（不带动画）
- (void)drawDefaultView {
//    inputTF = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
//    inputTF.borderStyle = UITextBorderStyleRoundedRect;
//    inputTF.text = @"123";
//    [self addSubview:inputTF];
    
}
//成功弹窗提示（带有打对号的动画）
- (void)drawSuccessView {
//     UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake((self.frame.size.width-WARN_WIDTH)/2, 8, WARN_WIDTH, WARN_WIDTH) cornerRadius:WARN_WIDTH/2];
//    [path moveToPoint:CGPointMake((self.frame.size.width-WARN_WIDTH)/2+10, WARN_WIDTH/2)];
//    [path addLineToPoint:CGPointMake(self.frame.size.width/2.0-10, WARN_WIDTH-20)];
//    [path addLineToPoint:CGPointMake(self.frame.size.width/2.0 + WARN_WIDTH/2-15, AUTOLAYTOU(35))];
//    
//    [self setDrawAnimationWithPath:path StrokeColor:[UIColor colorWithRed:13/255.0 green:150/255.0 blue:1/255.0 alpha:1]];
    //fix
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake((self.frame.size.width-WARN_WIDTH)/2, 20, WARN_WIDTH, WARN_WIDTH) cornerRadius:WARN_WIDTH/2];
    [path moveToPoint:CGPointMake((self.frame.size.width-WARN_WIDTH)/2+15, WARN_WIDTH/2 + 20)];
    [path addLineToPoint:CGPointMake(self.frame.size.width/2.0-5, WARN_WIDTH-20 + 20)];
    [path addLineToPoint:CGPointMake(self.frame.size.width/2.0 + WARN_WIDTH/2-15, AUTOLAYTOU(20) + 20)];
    
    [self setDrawAnimationWithPath:path StrokeColor:[UIColor colorWithRed:13/255.0 green:150/255.0 blue:1/255.0 alpha:1]];
    
}
//成功弹窗提示（带有打错号的动画）
- (void)drawFailView {
    //y 统一下移10
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake((self.frame.size.width-WARN_WIDTH)/2, 20, WARN_WIDTH, WARN_WIDTH) cornerRadius:WARN_WIDTH/2];
    [path moveToPoint:CGPointMake((self.frame.size.width-WARN_WIDTH)/2+AUTOLAYTOU(20)-6, AUTOLAYTOU(25) + 10)];
    [path addLineToPoint:CGPointMake(self.frame.size.width/2.0 + WARN_WIDTH/2-AUTOLAYTOU(20)+6, WARN_WIDTH-AUTOLAYTOU(15)+AUTOLAYTOU(3) + 15)];
    
    [path moveToPoint:CGPointMake(self.frame.size.width/2.0 + WARN_WIDTH/2-AUTOLAYTOU(20)+6, AUTOLAYTOU(25) + 10)];
    [path addLineToPoint:CGPointMake((self.frame.size.width-WARN_WIDTH)/2+AUTOLAYTOU(20)-6, WARN_WIDTH-AUTOLAYTOU(15)+AUTOLAYTOU(3) + 15)];
    
   [self setDrawAnimationWithPath:path StrokeColor:[UIColor redColor]];
}
//成功弹窗提示（带有打警告的动画）
- (void)drawWarnView {
    //y 统一下移20
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake((self.frame.size.width-WARN_WIDTH)/2, 20, WARN_WIDTH, WARN_WIDTH) cornerRadius:WARN_WIDTH/2];
    [path moveToPoint:CGPointMake(self.frame.size.width/2.0, AUTOLAYTOU(15) + 20)];
    [path addLineToPoint:CGPointMake(self.frame.size.width/2.0, WARN_WIDTH-AUTOLAYTOU(20) + 20)];
    
    [path moveToPoint:CGPointMake(self.frame.size.width/2.0, WARN_WIDTH-AUTOLAYTOU(15) + 20)];
    [path addLineToPoint:CGPointMake(self.frame.size.width/2.0, WARN_WIDTH-AUTOLAYTOU(8) + 20)];
    [self setDrawAnimationWithPath:path StrokeColor:[UIColor colorWithRed:230/255.0 green:180/255.0 blue:1/255.0 alpha:1]];
    
}

- (void)setDrawAnimationWithPath:(UIBezierPath *)path StrokeColor:(UIColor *)strokeColor {
    CAShapeLayer *lineLayer = [ CAShapeLayer layer];
    
    lineLayer. frame = CGRectZero;
    
    lineLayer. fillColor = [ UIColor clearColor ]. CGColor ;
    
    lineLayer. path = path. CGPath ;
    
    lineLayer. strokeColor = strokeColor. CGColor ;
    lineLayer.lineWidth = 5;
    lineLayer.cornerRadius = 5;
    
    CABasicAnimation *ani = [ CABasicAnimation animationWithKeyPath : NSStringFromSelector ( @selector (strokeEnd))];
    
    ani. fromValue = @0 ;
    
    ani. toValue = @1 ;
    
    ani. duration = 0.5 ;
    
    
    [lineLayer addAnimation :ani forKey : NSStringFromSelector ( @selector (strokeEnd))];
    
    [self.layer addSublayer :lineLayer];
}

- (void)showInView:(UIView *)superView {
    
    [self setPopAnimation];
    [superView addSubview:_backView];
    [_backView addSubview:self];
//    self.center = _backView.center;
    
    CGFloat y = 0;
    if (iPhone4) {
        
        y = 85+64;
    } else if(iPhone5){
        
        y = 45+64;
    }else
        y = 30+64;
    self.center = CGPointMake(_backView.center.x, _backView.center.y - y);
    if (_shutdown) {
        _shutdown.frame = CGRectMake(kWidth - AUTOLAYTOU(26) - 36, CGRectGetMinY(self.frame) - 50, 26, 50);
    }
    //如果有输入框，聚焦
    if (inputTF) {
        inputTF.keyboardType = _keyboardType;

        [inputTF becomeFirstResponder];
    }
}

- (void)buttonClicked:(UIButton *)sender {
    if (_delegate) {
        if (inputTF.text.length > 0) {
            
            [_delegate alertView:self clickedButtonAtIndex:sender.tag - 1 withString:inputTF.text];
        } else if (_datePicker) {
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];//设置输出的格式
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];//四个y就是2014－10-15，2个y就是14-10-15，这是输出字符串的时候用到的
            NSString *dateString = [dateFormatter stringFromDate:_datePicker.date];
            
            if (sender.tag == 1) {
                
                [_delegate alertView:self clickedButtonAtIndex:sender.tag - 1 withString:dateString];
            }
        } else  {
            if ([sender.titleLabel.text isEqualToString:@"男"]) {
                [_delegate alertView:self clickedButtonAtIndex:sender.tag - 1 withString:@"0"];
            }else if([sender.titleLabel.text isEqualToString:@"女"]){
                [_delegate alertView:self clickedButtonAtIndex:sender.tag - 1 withString:@"1"];

            }else{
                [_delegate alertView:self clickedButtonAtIndex:sender.tag - 1 withString:nil];

            }
        

        }
    }
    if (self.superview) {
        [self.superview removeFromSuperview];
    }
    [_rushBtn.layer removeAllAnimations];
    [self removeFromSuperview];
    [_backView removeFromSuperview];
    [inputTF removeFromSuperview];
    _backView = nil;

}

- (void)setPopAnimation {
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:
                                      kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.layer addAnimation:popAnimation forKey:nil];
    [_shutdown.layer addAnimation:popAnimation forKey:nil];
    [_rushBtn.layer addAnimation:popAnimation forKey:nil];
    [self setRushButtonAnimation];
}

- (void)setRushButtonAnimation {
    // 设定为缩放
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    // 动画选项设定
    animation.duration = 0.3; // 动画持续时间
    animation.repeatCount = MAXFLOAT; // 重复次数
    animation.autoreverses = YES; // 动画结束时执行逆动画
    // 缩放倍数
    animation.fromValue = [NSNumber numberWithFloat:1.0]; // 开始时的倍率
    animation.toValue = [NSNumber numberWithFloat:1.3]; // 结束时的倍率
    // 添加动画
    [_rushBtn.layer addAnimation:animation forKey:@"scale-layer"];
}
- (instancetype)initWithPopBirthdatePickerWithtarget:(id<AlertViewDelegate>)delegate {
    
    self = [super init];
    if (self) {
        
        if (isIOS9) {
            self.frame = CGRectMake(40, 50, kWidth - 80, kWidth - AUTOLAYTOU(140));
        } else {
            
            self.frame = CGRectMake(40, 50, kWidth - 80, kWidth - AUTOLAYTOU(110));

        }
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 1.0f;
        self.clipsToBounds = YES;
        self.delegate = delegate;
        
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth ,kHeight)];
        _backView.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:0.8];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.frame = CGRectMake(0, 10, CGRectGetWidth(self.frame), AUTOLAYTOU(20));
        _titleLabel.text = @"修改出生日期";
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:20];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
//        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, AUTOLAYTOU(30), CGRectGetWidth(self.frame), 105)];
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.frame = CGRectMake(0, AUTOLAYTOU(30), CGRectGetWidth(self.frame), AUTOLAYTOU(90));
        _datePicker.datePickerMode = UIDatePickerModeDate;//模式选择
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文
        _datePicker.locale = locale;
        //        _datePicker.backgroundColor = [UIColor blueColor];
        [self addSubview:_datePicker];
        
        NSArray *titles = @[@"确定",@"取消"];
        //button
        for (int i = 0; i < titles.count; i ++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:titles[i] forState:UIControlStateNormal];
            button.frame = CGRectMake(i*self.frame.size.width/titles.count,CGRectGetMaxY(_datePicker.frame) + 10, self.frame.size.width/titles.count, self.frame.size.height - (CGRectGetMaxY(_datePicker.frame) + 10));
            button.tag = i + 1;
            //[button setBackgroundColor:[UIColor blueColor]];
            [button setBackgroundColor:buttonColor];
            
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
        }
        //topLine
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_datePicker.frame) + 9.5, self.frame.size.width, 0.5)];
        topLine.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:topLine];
        
        for (int i = 0; i < titles.count - 1 ; i ++) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake((i + 1)*self.frame.size.width/titles.count, CGRectGetMaxY(_datePicker.frame) + 10, 0.5, self.frame.size.height - (CGRectGetMaxY(_datePicker.frame) + 10))];
            line.backgroundColor = [UIColor lightGrayColor];
            [self addSubview:line];
        }
    }
    return self;
}
@end
