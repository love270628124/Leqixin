//
//  CommentViewController.m
//  乐企信
//
//  Created by 震霄 张 on 16/4/1.
//  Copyright © 2016年 SDW. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentTableViewCell.h"
#import "CommentModel.h"
#import "CommentFrame.h"
#import "RecordViewController.h"
#import "CmInfoViewController.h"
#import "AppDelegate.h"
#import "AlertView.h"
@interface CommentViewController ()<UITableViewDataSource,UITableViewDelegate,commentCellDelegate>
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *commentArr;
//@property (nonatomic,strong)NSMutableArray *showArr;
@property (nonatomic,assign)NSInteger refreshCount;
@end

@implementation CommentViewController


-(NSMutableArray *)commentArr
{
    if (_commentArr  == nil) {
        _commentArr = [NSMutableArray array];
    }
    return _commentArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ZXcolor(239, 239, 244);

    [self setupNav];
    [self setupCommentManageView];
    //集成刷新控件
    [self setupRefresh];
}


-(void)setupNav
{
    //导航栏透明处理
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_celan"] style:UIBarButtonItemStylePlain target:self action:@selector(openLeftVCAction)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"bt_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClick:)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    self.title = @"全员互动";
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"记录" style:UIBarButtonItemStylePlain target:self action:@selector(checkRecord)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];

}
-(void)checkRecord
{
    [self.navigationController pushViewController:[[RecordViewController alloc]init] animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)backBtnClick:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setupCommentManageView
{
    UIView *bgView = [[UIView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:bgView];
    UILabel *showLabel = [[UILabel alloc]init];
    showLabel.text = @"暂无互动数据";
    showLabel.font = [UIFont systemFontOfSize:25];
    showLabel.frame = CGRectMake(0, SCREEN_H*0.4, SCREEN_W, 100);
    showLabel.textColor = [UIColor grayColor];
    showLabel.adjustsFontSizeToFitWidth = YES;
    showLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:showLabel];
    
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64)];
    tableView.backgroundColor = ZXcolor(235, 235, 235);
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[CommentTableViewCell class] forCellReuseIdentifier:@"commentCell"];
    self.tableView = tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentArr.count;
}
-(CommentTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentTableViewCell *cell = [CommentTableViewCell cellWithTableView:tableView indexpath:indexPath];
    cell.cmframe = self.commentArr[indexPath.row];
    cell.delegate = self;
    if (indexPath.row == self.commentArr.count-1) {
        cell.lineView.hidden = YES;
    }else{
        cell.lineView.hidden = NO;
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentFrame *cmFrame = self.commentArr[indexPath.row];
    return cmFrame.cellHeight;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    CmInfoViewController *vc = [[CmInfoViewController alloc]init];
//    vc.cmframe = self.commentArr[indexPath.row];
//    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark commentCellDelegate
-(void)commentPassed:(CommentFrame *)cmFrame
{
    NSLog(@"passed name:%@",cmFrame.model.customername);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSString stringWithFormat:@"%ld",cmFrame.model.itemid] forKey:@"itemid"];
    [params setObject:@"1" forKey:@"judge"];
    //    [params setObject:[NSString stringWithFormat:@"%ld",self.refreshCount] forKey:@"number"];
    
    NSString *url =[NSString stringWithFormat:@"%@/index.php",rootUrl];
    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
    [muDic setObject:@"Interface" forKey:@"g"];
    [muDic setObject:@"Newpinlun" forKey:@"m"];
    [muDic setObject:@"audit" forKey:@"a"];
    
    [muDic setObject:[self dictionaryToJson:params] forKey:@"data"];
    
    [manager GET:url parameters:muDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSInteger result = [dic[@"result"]integerValue];
        if (result == 1) {//数据更新成功
            AlertView *showView = [[AlertView alloc]initWithTitle:@"更新成功" style:kAlertViewStyleSuccess showTime:kAlerViewShowTimeOneSecond];
            [showView showInView:self.view];
            cmFrame.model.status = CommentStatusPassed;
            cmFrame.model.ischecked = @"1";
            [self.commentArr removeObject:cmFrame];
            [self.tableView reloadData];
            CmInfoViewController *vc = [[CmInfoViewController alloc]init];
            vc.cmframe = cmFrame;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (result == 2){//评论已处理
            NSLog(@"评论已处理");
            AlertView *showView = [[AlertView alloc]initWithTitle:@"评论已处理" style:kAlertViewStyleWarn showTime:kAlerViewShowTimeOneSecond];
            [showView showInView:self.view];
        }else{
            NSLog(@"系统错误");
            AlertView *showView = [[AlertView alloc]initWithTitle:@"系统错误" style:kAlertViewStyleFail showTime:kAlerViewShowTimeOneSecond];
            [showView showInView:self.view];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        AlertView *showView = [[AlertView alloc]initWithTitle:@"网络异常" style:kAlertViewStyleFail showTime:kAlerViewShowTimeOneSecond];
        [showView showInView:self.view];
    }];
}
-(void)commentTrashed:(CommentFrame *)cmFrame
{
    NSLog(@"trashed name:%@",cmFrame.model.customername);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSString stringWithFormat:@"%ld",cmFrame.model.itemid] forKey:@"itemid"];
    [params setObject:@"2" forKey:@"judge"];
    //    [params setObject:[NSString stringWithFormat:@"%ld",self.refreshCount] forKey:@"number"];
    
    NSString *url = [NSString stringWithFormat:@"%@/index.php",rootUrl];
    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
    [muDic setObject:@"Interface" forKey:@"g"];
    [muDic setObject:@"Newpinlun" forKey:@"m"];
    [muDic setObject:@"audit" forKey:@"a"];
    
    [muDic setObject:[self dictionaryToJson:params] forKey:@"data"];
    
    [manager GET:url parameters:muDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSInteger result = [dic[@"result"]integerValue];
        if (result == 1) {//数据更新成功
            AlertView *showView = [[AlertView alloc]initWithTitle:@"更新成功" style:kAlertViewStyleSuccess showTime:kAlerViewShowTimeOneSecond];
            [showView showInView:self.view];
            cmFrame.model.status = CommentStatusTrash;
            cmFrame.model.ischecked = @"2";
            [self.commentArr removeObject:cmFrame];
            [self.tableView reloadData];
        }else if (result == 2){//评论已处理
            NSLog(@"评论已处理");
            AlertView *showView = [[AlertView alloc]initWithTitle:@"评论已处理" style:kAlertViewStyleWarn showTime:kAlerViewShowTimeOneSecond];
            [showView showInView:self.view];
        }else{
            NSLog(@"系统错误");
            AlertView *showView = [[AlertView alloc]initWithTitle:@"系统错误" style:kAlertViewStyleFail showTime:kAlerViewShowTimeOneSecond];
            [showView showInView:self.view];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        AlertView *showView = [[AlertView alloc]initWithTitle:@"网络异常" style:kAlertViewStyleFail showTime:kAlerViewShowTimeOneSecond];
        [showView showInView:self.view];
    }];

}
-(void)commentDeleted:(CommentFrame *)cmFrame
{
    NSLog(@"deleted name:%@",cmFrame.model.customername);
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSString stringWithFormat:@"%ld",cmFrame.model.itemid] forKey:@"itemid"];
    [params setObject:@"3" forKey:@"judge"];
    //    [params setObject:[NSString stringWithFormat:@"%ld",self.refreshCount] forKey:@"number"];
    
    NSString *url = [NSString stringWithFormat:@"%@/index.php",rootUrl];
    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
    [muDic setObject:@"Interface" forKey:@"g"];
    [muDic setObject:@"Newpinlun" forKey:@"m"];
    [muDic setObject:@"audit" forKey:@"a"];
    
    [muDic setObject:[self dictionaryToJson:params] forKey:@"data"];
    
    [manager GET:url parameters:muDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSInteger result = [dic[@"result"]integerValue];
        if (result == 1) {//数据更新成功
            AlertView *showView = [[AlertView alloc]initWithTitle:@"更新成功" style:kAlertViewStyleSuccess showTime:kAlerViewShowTimeOneSecond];
            [showView showInView:self.view];
            cmFrame.model.status = CommentStatusDeleted;
            cmFrame.model.ischecked = @"3";
            [self.commentArr removeObject:cmFrame];
            [self.tableView reloadData];
        }else if (result == 2){//评论已处理
            NSLog(@"评论已处理");
            AlertView *showView = [[AlertView alloc]initWithTitle:@"评论已处理" style:kAlertViewStyleWarn showTime:kAlerViewShowTimeOneSecond];
            [showView showInView:self.view];
        }else{
            NSLog(@"系统错误");
            AlertView *showView = [[AlertView alloc]initWithTitle:@"系统错误" style:kAlertViewStyleFail showTime:kAlerViewShowTimeOneSecond];
            [showView showInView:self.view];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        AlertView *showView = [[AlertView alloc]initWithTitle:@"网络异常" style:kAlertViewStyleFail showTime:kAlerViewShowTimeOneSecond];
        [showView showInView:self.view];
    }];
}

#pragma mark -下拉刷新

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
    [params setObject:@"3" forKey:@"judge"];
//    [params setObject:[NSString stringWithFormat:@"%ld",self.refreshCount] forKey:@"number"];
    
    NSString *changePswdUrl = [NSString stringWithFormat:@"%@/index.php",rootUrl];
    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
    [muDic setObject:@"Interface" forKey:@"g"];
    [muDic setObject:@"Newpinlun" forKey:@"m"];
    [muDic setObject:@"get_custom" forKey:@"a"];
    
    [muDic setObject:[self dictionaryToJson:params] forKey:@"data"];
    [manager GET:changePswdUrl parameters:muDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSMutableArray *modelArr = [CommentModel mj_objectArrayWithKeyValuesArray:dic];

        [self.commentArr removeAllObjects];
        
        if (modelArr.count == 0) {
            self.tableView.alpha = 0.5;
        }else{
            self.tableView.alpha = 1.0;
        }
        
        
        for (int i = 0; i<modelArr.count; i++) {
            CommentModel *cmModel = modelArr[i];
            cmModel.status = CommentStatusNoHandle;
            CommentFrame *cmFrame = [[CommentFrame alloc]init];
            cmFrame.model = cmModel;
           //[self.commentArr insertObject:cmFrame atIndex:0];
            [self.commentArr addObject:cmFrame];
        }
        // 刷新表格
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
    [params setObject:@"3" forKey:@"judge"];
    [params setObject:[NSString stringWithFormat:@"%ld",(long)self.refreshCount] forKey:@"number"];
    
    NSString *changePswdUrl = [NSString stringWithFormat:@"%@/index.php",rootUrl];
    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
    [muDic setObject:@"Interface" forKey:@"g"];
    [muDic setObject:@"Newpinlun" forKey:@"m"];
    [muDic setObject:@"get_custom" forKey:@"a"];
    
    [muDic setObject:[self dictionaryToJson:params] forKey:@"data"];
    [manager GET:changePswdUrl parameters:muDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"result:%@",dic);
        
        NSMutableArray *modelArr = [CommentModel mj_objectArrayWithKeyValuesArray:dic];
        NSLog(@"arr:%@",modelArr);
        for (int i = 0; i<modelArr.count; i++) {
            CommentFrame *cmFrame = [[CommentFrame alloc]init];
            cmFrame.model = modelArr[i];
            [self.commentArr addObject:cmFrame];
        }
        // 刷新表格
        [self.tableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView footerEndRefreshing];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [self.tableView footerEndRefreshing];
        AlertView *showView = [[AlertView alloc]initWithTitle:@"网络异常" style:kAlertViewStyleFail showTime:kAlerViewShowTimeOneSecond];
        [showView showInView:self.view];
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
