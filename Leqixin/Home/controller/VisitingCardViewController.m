//
//  VisitingCardViewController.m
//  乐企信
//
//  Created by 震霄 张 on 16/5/22.
//  Copyright © 2016年 SDW. All rights reserved.
//

#import "VisitingCardViewController.h"
#import "AppDelegate.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"

@interface VisitingCardViewController ()<UIWebViewDelegate,NJKWebViewProgressDelegate>

@property (nonatomic,strong)UIWebView *webView;

@end

@implementation VisitingCardViewController{
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
    NSString *urlString;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"bt_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClick:)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(shareClick)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64)];
    [self.view addSubview: self.webView];
    
    self.webView.scalesPageToFit = YES;
    
    AppDelegate *tempDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    NSURL* url = [NSURL URLWithString:tempDelegate.userModel.domain];//创建URL
    //    NSURL* url = [NSURL URLWithString:@"http://www.taobao.com"];//创建URL
    urlString = [NSString stringWithFormat:@"http://shimai.leqixin.cc/busycard.php?id=%ld",(long)tempDelegate.userModel.userid];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    [self.webView loadRequest:request];
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:_progressView];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Remove progress view
    // because UINavigationBar is shared with other ViewControllers
    [_progressView removeFromSuperview];
}
#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}
-(void)shareClick
{
    AppDelegate *tempDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSString *title = [NSString stringWithFormat:@"%@的电子名片",tempDelegate.userModel.truename];
    NSString *content = [NSString stringWithFormat:@"%@,%@",tempDelegate.userModel.companyname,tempDelegate.userModel.officer];
    NSArray *imgs = @[tempDelegate.userModel.headimg];
    
    [[ShareObject shareDefault] sendMessageWithTitle:title withContent:content withUrl:urlString withImages:imgs result:^(NSString *result, kAlertViewStyle style) {
        
        if ([result isEqualToString:@"0"]) {
            AlertView *view = [[AlertView alloc] initWithTitle:@"分享成功" style:style showTime:kAlerViewShowTimeOneSecond];
            [view showInView:self.view];
            
        }else if([result isEqualToString:@"2"]){
//            AlertView *view = [[AlertView alloc] initWithTitle:@"分享取消" style:style showTime:kAlerViewShowTimeOneSecond];
//            [view showInView:self.view];
        }else{
            AlertView *view = [[AlertView alloc] initWithTitle:@"分享失败" style:style showTime:kAlerViewShowTimeOneSecond];
            [view showInView:self.view];
        }
    }];
    
//    [[ShareObject shareDefault] sendMessage:[NSString stringWithFormat:@"%@",urlString] result:^(NSString *result, kAlertViewStyle style) {
//        NSLog(@"%@",result);
//        
//        //"0"-成功
//        //"1"-失败
//        //"2"-取消
//        if ([result isEqualToString:@"0"]) {
//            AlertView *view = [[AlertView alloc] initWithTitle:@"分享成功" style:style showTime:kAlerViewShowTimeOneSecond];
//            [view showInView:self.view];
//            
//        }else if([result isEqualToString:@"2"]){
//            AlertView *view = [[AlertView alloc] initWithTitle:@"分享取消" style:style showTime:kAlerViewShowTimeOneSecond];
//            [view showInView:self.view];
//        }else{
//            AlertView *view = [[AlertView alloc] initWithTitle:@"分享失败" style:style showTime:kAlerViewShowTimeOneSecond];
//            [view showInView:self.view];
//        }
//    }];
    
    
}
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    CGPoint point = scrollView.contentOffset;
//    if (point.x > 0) {
//        scrollView.contentOffset = CGPointMake(0, point.y);//这里不要设置为CGPointMake(0, point.y)，这样我们在文章下面左右滑动的时候，就跳到文章的起始位置，不科学
//    }
//}
-(void)backBtnClick:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
