//
//  ShareInfoShowController.m
//  乐企信
//
//  Created by 震霄 张 on 16/4/1.
//  Copyright © 2016年 SDW. All rights reserved.
//

#import "ShareInfoShowController.h"
#import "AppDelegate.h"
#import "shareDetialModel.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"

@interface ShareInfoShowController ()<UIWebViewDelegate,NJKWebViewProgressDelegate>
@property (nonatomic,weak)UILabel *titleLabel;
@property (nonatomic,weak)UILabel *timeLabel;
@property (nonatomic,strong)shareDetialModel *detialModel;
@property (nonatomic,strong)UIWebView *webView;

@property (nonatomic,weak)UILabel *sharedNumLabel;
@property (nonatomic,weak)UILabel *noSharedNumLabel;
@end

@implementation ShareInfoShowController{
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ZXcolor(239, 239, 244);

    [self setupNav];
    [[JSSDWProgressHUD shareProgressHud] showWithSuperView:self.view];
    [self requestShareInfo];

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
-(void)requestShareInfo
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.model.todoid forKey:@"itemid"];
    [params setObject:@"0" forKey:@"type"];
    
    NSString *url = [NSString stringWithFormat:@"%@/index.php",rootUrl];
    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
    [muDic setObject:@"Interface" forKey:@"g"];
    [muDic setObject:@"Newshare" forKey:@"m"];
    [muDic setObject:@"get_single" forKey:@"a"];
    
    [muDic setObject:[self dictionaryToJson:params] forKey:@"data"];
    [manager GET:url parameters:muDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
#warning 没有分享任务要有弹窗
        NSString *result  =[[ NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if (!result) {
            NSLog(@"没有分享任务");
            
        }
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        shareDetialModel *modelDetial = [shareDetialModel mj_objectWithKeyValues:dic];
        self.detialModel = modelDetial;
        
        [[JSSDWProgressHUD shareProgressHud] hiddenProgressHud];
        [self setupShowDetialView];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];

}
-(void)setupNav
{
    //导航栏透明处理
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"bt_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClick:)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(shareBtnClick:)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];

    self.title = @"分享内容";
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
}
-(void)shareBtnClick:(UIButton *)btn
{
    NSLog(@"分享");
    [ShareObject shareDefault];

    NSMutableArray *dataArr = [NSMutableArray array];
    [dataArr addObject:[NSString stringWithFormat:@"%@%@",rootUrl,self.detialModel.picture]];
    NSString *content = [NSString stringWithFormat:@"%@",self.detialModel.url];
    
    [[ShareObject shareDefault] sendMessageWithTitle:self.detialModel.title withContent:content withUrl:content withImages:dataArr result:^(NSString *result, kAlertViewStyle style) {
        
        if ([result isEqualToString:@"0"]) {
            
            [self updateShareInfo];
        }else if([result isEqualToString:@"2"]){
//            AlertView *view = [[AlertView alloc] initWithTitle:@"分享取消" style:style showTime:kAlerViewShowTimeOneSecond];
//            [view showInView:self.view];
        }else{
            AlertView *view = [[AlertView alloc] initWithTitle:@"分享失败" style:style showTime:kAlerViewShowTimeOneSecond];
            [view showInView:self.view];
        }
    }];
    
//    [[ShareObject shareDefault]sendMessageWithTitle:self.detialModel.title withContent:content withImages:dataArr result:^(NSString *result, kAlertViewStyle style) {
//        if ([result isEqualToString:@"0"]) {
//
//            [self updateShareInfo];
//        }else if([result isEqualToString:@"2"]){
//            AlertView *view = [[AlertView alloc] initWithTitle:@"分享取消" style:style showTime:kAlerViewShowTimeOneSecond];
//            [view showInView:self.view];
//        }else{
//            AlertView *view = [[AlertView alloc] initWithTitle:@"分享失败" style:style showTime:kAlerViewShowTimeOneSecond];
//            [view showInView:self.view];
//        }
//    }];

}
-(void)updateShareInfo
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.model.userid forKey:@"userid"];
    [params setObject:self.model.todoid forKey:@"todoid"];
    
    NSString *url = [NSString stringWithFormat:@"%@/index.php",rootUrl];
    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
    [muDic setObject:@"Interface" forKey:@"g"];
    [muDic setObject:@"Newshare" forKey:@"m"];
    [muDic setObject:@"update" forKey:@"a"];
    
    [muDic setObject:[self dictionaryToJson:params] forKey:@"data"];
    [manager GET:url parameters:muDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *result  =[[ NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([result isEqualToString:@"OK"]) {
            AlertView *view = [[AlertView alloc] initWithTitle:@"分享成功" style:kAlertViewStyleSuccess showTime:kAlerViewShowTimeOneSecond];
            [view showInView:self.view];
            
            [self updateShareStatusData];//更新分享人数label的数据
        }else{
            AlertView *view = [[AlertView alloc] initWithTitle:@"分享失败" style:kAlertViewStyleFail showTime:kAlerViewShowTimeOneSecond];
            [view showInView:self.view];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
-(void)updateShareStatusData
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.model.todoid forKey:@"itemid"];
    [params setObject:@"0" forKey:@"type"];
    
    NSString *url = [NSString stringWithFormat:@"%@/index.php",rootUrl];
    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
    [muDic setObject:@"Interface" forKey:@"g"];
    [muDic setObject:@"Newshare" forKey:@"m"];
    [muDic setObject:@"get_single" forKey:@"a"];
    
    [muDic setObject:[self dictionaryToJson:params] forKey:@"data"];
    [manager GET:url parameters:muDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
#warning 没有分享任务要有弹窗
        NSString *result  =[[ NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if (!result) {
            NSLog(@"没有分享任务");
            
        }
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        shareDetialModel *modelDetial = [shareDetialModel mj_objectWithKeyValues:dic];
        self.detialModel = modelDetial;
        
        self.sharedNumLabel.text = [NSString stringWithFormat:@"%@人已分享",modelDetial.share_true];
        self.noSharedNumLabel.text = [NSString stringWithFormat:@"%@人未分享",modelDetial.share_false];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];

}
-(void)backBtnClick:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupShowDetialView
{
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(56 * SCREEN_SCALE_W,8*SCREEN_SCALE_H, SCREEN_W - 112*SCREEN_SCALE_W, 35*SCREEN_SCALE_H)];
    titleLabel.textColor = ZXcolor(51, 51, 51);
    titleLabel.textAlignment = NSTextAlignmentCenter;
   // titleLabel.backgroundColor = [UIColor redColor];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.text = self.detialModel.conten;
    [self.view addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.x, CGRectGetMaxY(titleLabel.frame), titleLabel.width, titleLabel.height)];
    timeLabel.textColor = ZXcolor(136, 136, 136);
    timeLabel.textAlignment = NSTextAlignmentCenter;
   // timeLabel.backgroundColor = [UIColor redColor];
    timeLabel.font = [UIFont systemFontOfSize:16];
    timeLabel.text = self.detialModel.effectTime;
    [self.view addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
//    UIImageView *contentView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_tupian"]];
//    contentView.frame = CGRectMake(10*SCREEN_SCALE_W, CGRectGetMaxY(timeLabel.frame)+8*SCREEN_SCALE_H, SCREEN_W-20*SCREEN_SCALE_W, 500*SCREEN_SCALE_H);
//    [self.view addSubview:contentView];
    
    UIWebView *webView = [[UIWebView alloc]init];
    webView.frame = CGRectMake(10*SCREEN_SCALE_W, CGRectGetMaxY(timeLabel.frame)+8*SCREEN_SCALE_H, SCREEN_W-20*SCREEN_SCALE_W, 470*SCREEN_SCALE_H);
    webView.scalesPageToFit = YES;
    self.webView = webView;
    [self.view addSubview:webView];
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    [self.navigationController.navigationBar addSubview:_progressView];

    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    NSURL* url = [NSURL URLWithString:self.detialModel.url];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    [webView loadRequest:request];
    
    UIView *dataView = [[UIView alloc]init];
    dataView.frame = CGRectMake(0, CGRectGetMaxY(webView.frame), SCREEN_W, SCREEN_H - CGRectGetMaxY(webView.frame)-64);
    dataView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:dataView];

    UIImageView *lineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(dataView.frame), 1)];
    lineImgView.image = [UIImage imageNamed:@"share_huixian"];
    lineImgView.contentMode = UIViewContentModeScaleToFill;
    [dataView addSubview:lineImgView];
    
    UILabel *sharedNumLabel = [[UILabel alloc]init];
    sharedNumLabel.x = 0;
    sharedNumLabel.y = 0;
    sharedNumLabel.width = (SCREEN_W-1)*0.5;
    sharedNumLabel.height = dataView.height;
    sharedNumLabel.text = [NSString stringWithFormat:@"%@人已分享",self.detialModel.share_true];
    sharedNumLabel.font = [UIFont systemFontOfSize:17];
    sharedNumLabel.textColor = ZXcolor(119, 119, 119);
    sharedNumLabel.textAlignment = NSTextAlignmentCenter;
    self.sharedNumLabel = sharedNumLabel;
    [dataView addSubview:sharedNumLabel];
    
    UILabel *noShareNumLabel = [[UILabel alloc]init];
    noShareNumLabel.font = [UIFont systemFontOfSize:17];
    noShareNumLabel.text = [NSString stringWithFormat:@"%@人未分享",self.detialModel.share_false];
    noShareNumLabel.textColor = ZXcolor(119, 119, 119);
    noShareNumLabel.textAlignment = NSTextAlignmentCenter;
    noShareNumLabel.x = CGRectGetMaxX(sharedNumLabel.frame)+1*SCREEN_SCALE_W;
    noShareNumLabel.y= 0;
    noShareNumLabel.width = sharedNumLabel.width;
    noShareNumLabel.height = sharedNumLabel.height;
    [dataView addSubview:noShareNumLabel];
    self.noSharedNumLabel = noShareNumLabel;
    
    UIImageView *lineView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_shuxian"]];
    lineView.x = CGRectGetMaxX(sharedNumLabel.frame);
    lineView.width = 1 * SCREEN_SCALE_W;
    lineView.height = 32*SCREEN_SCALE_H;
    lineView.y = (dataView.height - lineView.height)*0.5;
    [dataView addSubview:lineView];
    
    
}
//字典转json字符串
- (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}


@end
