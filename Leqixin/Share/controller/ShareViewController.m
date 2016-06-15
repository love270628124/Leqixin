//
//  ShareViewController.m
//  乐企信
//
//  Created by 震霄 张 on 16/3/31.
//  Copyright © 2016年 SDW. All rights reserved.
//

#import "ShareViewController.h"
#import "shareDataModel.h"
#import "ShareTableViewCell.h"
#import "ShareInfoShowController.h"
#import "AppDelegate.h"


@interface ShareViewController ()<UITableViewDataSource,UITableViewDelegate,ShareTableViewCellDelegate>
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,assign)NSInteger refreshCount;



@end

@implementation ShareViewController

-(NSMutableArray *)dataArr
{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
        
    }
    return _dataArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ZXcolor(239, 239, 244);
    [self setupNav];
    [self setupShareView];
    //集成刷新控件
    [self setupRefresh];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self headerRereshing];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setupShareView
{
    UIView *bgView = [[UIView alloc]initWithFrame:self.view.bounds];
    //    bgView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:bgView];
    UILabel *showLabel = [[UILabel alloc]init];
    showLabel.text = @"暂无分享数据";
    showLabel.font = [UIFont systemFontOfSize:25];
    showLabel.frame = CGRectMake(0, SCREEN_H*0.4, SCREEN_W, 100);
    //    showLabel.backgroundColor = [UIColor orangeColor];
    showLabel.textColor = [UIColor grayColor];
    showLabel.adjustsFontSizeToFitWidth = YES;
    showLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:showLabel];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(5*SCREEN_SCALE_W, 0, SCREEN_W-10*SCREEN_SCALE_W, SCREEN_H-64)];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = ZXcolor(235, 235, 235);
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[ShareTableViewCell class] forCellReuseIdentifier:@"shareCell"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
//    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}
#pragma mark uitableViewdataSource/delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
-(ShareTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShareTableViewCell *cell = [ShareTableViewCell cellWithTableView:tableView indexpath:indexPath];
    cell.shareFrame = self.dataArr[indexPath.row];
    cell.delegate = self;
    if (indexPath.row == self.dataArr.count - 1) {
        cell.lineView.hidden = YES;
    }else{
        cell.lineView.hidden = NO;
    }

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    shareDataFrame *frame = self.dataArr[indexPath.row];
    return frame.cellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ShareInfoShowController *ssVc = [[ShareInfoShowController alloc]init];
    shareDataFrame *frame = self.dataArr[indexPath.row];
    ssVc.model = frame.model;
    [self.navigationController pushViewController:ssVc animated:YES];
    
}
-(void)setupNav
{
    //导航栏透明处理
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"bt_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClick:)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    self.title = @"协同分享";
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (void)backBtnClick:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark shareTableViewDelegate
-(void)createShareView:(shareDataModel *)model
{
    
//    NSLog(@"分享:%@",model.titleStr);
    [ShareObject shareDefault];
    
    NSMutableArray *dataArr = [NSMutableArray array];
    [dataArr addObject:[NSString stringWithFormat:@"%@%@",rootUrl,model.picture]];
    NSString *content = [NSString stringWithFormat:@"%@ 详情：%@",model.title,model.url];
    
//    UIImageView *imageView = [[UIImageView alloc]init];
//    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://180.76.164.79%@",model.picture]] placeholderImage:[UIImage imageNamed:@"smLogo"]];
//    [dataArr addObject:imageView.image];
    
    [[ShareObject shareDefault] sendMessageWithTitle:model.title withContent:content withUrl:model.url withImages:dataArr result:^(NSString *result, kAlertViewStyle style) {
        if ([result isEqualToString:@"0"]) {
            
            [self updateShareInfo:(shareDataModel *)model];
        }else if([result isEqualToString:@"2"]){
//            AlertView *view = [[AlertView alloc] initWithTitle:@"分享取消" style:style showTime:kAlerViewShowTimeOneSecond];
//            [view showInView:self.view];
        }else{
            AlertView *view = [[AlertView alloc] initWithTitle:@"分享失败" style:style showTime:kAlerViewShowTimeOneSecond];
            [view showInView:self.view];
        }
        
        [self headerRereshing];
    }];

}
-(void)updateShareInfo:(shareDataModel *)model
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:model.userid forKey:@"userid"];
    [params setObject:model.todoid forKey:@"todoid"];
    
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
        }else if([result isEqualToString:@"ON"]){
            AlertView *view = [[AlertView alloc] initWithTitle:@"分享失败" style:kAlertViewStyleFail showTime:kAlerViewShowTimeOneSecond];
            [view showInView:self.view];
        }else{
            AlertView *view = [[AlertView alloc] initWithTitle:@"查不到该分享" style:kAlertViewStyleFail showTime:kAlerViewShowTimeOneSecond];
            [view showInView:self.view];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        AlertView *showView = [[AlertView alloc]initWithTitle:@"网络异常" style:kAlertViewStyleFail showTime:kAlerViewShowTimeOneSecond];
        [showView showInView:self.view];
    }];
    
}


/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    //    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    // dateKey用于存储刷新时间，可以保证不同界面拥有不同的刷新时间
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"commentTable"];
#warning 自动刷新(一进入程序就下拉刷新)
    [self.tableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.tableView.headerPullToRefreshText = @"下拉可以刷新了";
    self.tableView.headerReleaseToRefreshText = @"松开马上刷新了";
    self.tableView.headerRefreshingText = @"正在帮你刷新中,不客气";
    
    self.tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    self.tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    self.tableView.footerRefreshingText = @"正在帮你加载中,不客气";
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    //上刷一次数据全部删光，显示最新十条数据
    self.refreshCount = 1;
    
    AppDelegate *tempDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UserInfoModel *userModel = tempDelegate.userModel;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSString stringWithFormat:@"%ld",(long)userModel.userid] forKey:@"itemid"];
    [params setObject:@"0" forKey:@"type"];
    [params setObject:[NSString stringWithFormat:@"%ld",(long)self.refreshCount] forKey:@"number"];
    
    NSString *url = [NSString stringWithFormat:@"%@/index.php",rootUrl];
    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
    [muDic setObject:@"Interface" forKey:@"g"];
    [muDic setObject:@"Newshare" forKey:@"m"];
    [muDic setObject:@"get" forKey:@"a"];
    
    [muDic setObject:[self dictionaryToJson:params] forKey:@"data"];
    [manager GET:url parameters:muDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
#warning 没有分享任务要有弹窗
//        NSString *result  =[[ NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        if (!result) {
//            NSLog(@"没有分享任务");
//            self.tableView.alpha = 0.5;
//        }else{
//            self.tableView.alpha = 1.0;
//        }
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSMutableArray *modelArr = [shareDataModel mj_objectArrayWithKeyValuesArray:dic];
//
        if (modelArr.count == 0) {
            self.tableView.alpha = 0.5;
        }else{
            self.tableView.alpha = 1.0;
        }
        
        [self.dataArr removeAllObjects];
        
        for (int i = 0; i<modelArr.count; i++) {
            shareDataModel *shareModel = modelArr[i];
            shareDataFrame *shareFrame = [[shareDataFrame alloc]init];
            shareFrame.model = shareModel;
//            [self.dataArr insertObject:shareFrame atIndex:0];
            [self.dataArr addObject:shareFrame];
        }
//        // 刷新表格
        [self.tableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView headerEndRefreshing];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [self.tableView headerEndRefreshing];
        AlertView *showView = [[AlertView alloc]initWithTitle:@"网络异常" style:kAlertViewStyleFail showTime:kAlerViewShowTimeOneSecond];
        [showView showInView:self.view];
    }];
    
}

- (void)footerRereshing
{
    
    self.refreshCount += 1;
    
    AppDelegate *tempDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UserInfoModel *userModel = tempDelegate.userModel;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSString stringWithFormat:@"%ld",(long)userModel.userid] forKey:@"itemid"];
    [params setObject:@"0" forKey:@"type"];
    [params setObject:[NSString stringWithFormat:@"%ld",(long)self.refreshCount] forKey:@"number"];
    
    NSString *changePswdUrl = [NSString stringWithFormat:@"%@/index.php",rootUrl];
    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
    [muDic setObject:@"Interface" forKey:@"g"];
    [muDic setObject:@"Newshare" forKey:@"m"];
    [muDic setObject:@"get" forKey:@"a"];
    
    [muDic setObject:[self dictionaryToJson:params] forKey:@"data"];
    [manager GET:changePswdUrl parameters:muDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"result:%@",dic);
        
        NSMutableArray *modelArr = [shareDataModel mj_objectArrayWithKeyValuesArray:dic];
        NSLog(@"arr:%@",modelArr);
        for (int i = 0; i<modelArr.count; i++) {
            shareDataModel *shareModel = modelArr[i];
            shareDataFrame *shareFrame = [[shareDataFrame alloc]init];
            shareFrame.model = shareModel;
            [self.dataArr addObject:shareFrame ];
        }
        // 刷新表格
        [self.tableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView footerEndRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [self.tableView footerEndRefreshing];
        
    }];
}

//字典转json字符串
- (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

@end
