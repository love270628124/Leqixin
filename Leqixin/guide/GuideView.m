//
//  GuideView.m
//  乐企信
//
//  Created by 震霄 张 on 16/4/6.
//  Copyright © 2016年 SDW. All rights reserved.
//

#import "GuideView.h"
#import "AppDelegate.h"
#import "LoginViewController.h"

#define imageNum 2//引导页张数
@interface GuideView()

@property (nonatomic,weak)UIScrollView *scrollView;
@end

@implementation GuideView

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self =[super initWithFrame:frame]){
        UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        scrollView.backgroundColor = [UIColor whiteColor];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.contentSize = CGSizeMake(SCREEN_W*imageNum, SCREEN_H);
        scrollView.pagingEnabled = YES;
        self.scrollView = scrollView;
        [self addSubview:scrollView];
        for (int i = 0; i<imageNum; i++) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*SCREEN_W, 0, SCREEN_W, SCREEN_H)];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"Intro&Guide-View%d",i+1]];
            [scrollView addSubview:imageView];
            
            if (i == imageNum - 1) {
                UIButton* start = [UIButton buttonWithType:UIButtonTypeCustom];
                UIImage *image = [UIImage imageNamed:@"button_try"];
//                start.frame = CGRectMake(SCREEN_W*0.5- 0.5*image.size.width+i*SCREEN_W, SCREEN_H - image.size.height - 75 * SCREEN_SCALE_H, image.size.width, image.size.height);
                start.width = image.size.width*1.5;
                start.height = image.size.height*1.5;
                start.x = (SCREEN_W-start.width)*0.5+i*SCREEN_W;
                start.y = SCREEN_H - start.height - 75*SCREEN_SCALE_H;
//                start.layer.cornerRadius = 5;
//                start.layer.borderWidth = 0.5;
                [start setBackgroundImage:image forState:UIControlStateNormal];
//                [start setTitle:@"" forState:UIControlStateNormal];
                [start addTarget:self action:@selector(startBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [scrollView addSubview:start];
            }

        }
    
    }
    return self;
}
    
-(void)startBtnClick:(UIButton *)btn
{
    NSLog(@"开始");
    AppDelegate * tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];

    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:[[LoginViewController alloc]init]];
    tempAppDelegate.window.rootViewController = nav;
}

@end
