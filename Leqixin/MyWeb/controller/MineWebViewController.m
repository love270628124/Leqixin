//
//  MineWebViewController.m
//  乐企信
//
//  Created by 震霄 张 on 16/5/4.
//  Copyright © 2016年 SDW. All rights reserved.
//

#import "MineWebViewController.h"
#import "AppDelegate.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"

@interface MineWebViewController ()<UIWebViewDelegate,NJKWebViewProgressDelegate>
@property (nonatomic,strong)UIWebView *webView;
@end

@implementation MineWebViewController{
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
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
    
    if ([self.urlString rangeOfString:@"http://"].location == NSNotFound) {
        self.urlString = [NSString stringWithFormat:@"http://%@",self.urlString];
    }
    NSURL* url = [NSURL URLWithString:self.urlString];//创建URL
//    NSURL* url = [NSURL URLWithString:@"http://www.taobao.com"];//创建URL
    
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
    
    NSString *content = [NSString stringWithFormat:@"%@官网详情",self.title];
    NSArray *imgs = [NSArray array];
    NSString *imgString = tempDelegate.userModel.thumb;
    if (imgString == nil || [imgString isEqualToString:@""]) {
        imgString = @"smLogo";
        UIImage *img = [UIImage imageNamed:imgString];
        imgs = @[img];
    } else {
        imgs = @[imgString];
    }

    [[ShareObject shareDefault] sendMessageWithTitle:tempDelegate.userModel.companyname withContent:content withUrl:self.urlString withImages:imgs result:^(NSString *result, kAlertViewStyle style) {
        
        if ([result isEqualToString:@"0"]) {
            AlertView *view = [[AlertView alloc] initWithTitle:@"分享成功" style:style showTime:kAlerViewShowTimeOneSecond];
            [view showInView:self.view];

        }else if([result isEqualToString:@"2"]){
            
            
        }else{
            AlertView *view = [[AlertView alloc] initWithTitle:@"分享失败" style:style showTime:kAlerViewShowTimeOneSecond];
            [view showInView:self.view];
        }
    }];
    

}

-(void)backBtnClick:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
