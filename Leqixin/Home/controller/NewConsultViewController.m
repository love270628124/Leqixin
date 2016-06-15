//
//  NewConsultViewController.m
//  乐企信
//
//  Created by 震霄 张 on 16/3/21.
//  Copyright © 2016年 SDW. All rights reserved.
//

#import "NewConsultViewController.h"
#import "NewConsultViewController.h"
#import "GrabTableViewCell.h"
#import "AppDelegate.h"
#import "StatisticsViewController.h"
#import "ChatViewController.h"
#import "NewConsultModel.h"

@interface NewConsultViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *consultArr;
@end

@implementation NewConsultViewController

-(NSMutableArray *)consultArr
{
    if (_consultArr == nil) {
        _consultArr = [NSMutableArray array];
    }
    return _consultArr;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self headerRereshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupNav];
    [self setupNewConsultView];

    //集成刷新控件
    [self setupRefresh];

}

-(void)setupNav
{
  
//    self.view.backgroundColor = ZXcolor(242, 242, 248);
    self.title = @"询盘抢单";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"统计" style:UIBarButtonItemStylePlain target:self action:@selector(checkMineConsult)];
     self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"bt_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClick:)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
}
-(void)checkMineConsult
{
    StatisticsViewController *vc = [[StatisticsViewController alloc]init];
    vc.isShowMineFirst = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)backBtnClick:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setupNewConsultView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64)];
    [self.tableView registerClass:[GrabTableViewCell class] forCellReuseIdentifier:@"grabCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = ZXcolor(235, 235, 235);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    self.automaticallyAdjustsScrollViewInsets = false;//去掉顶部空白
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
//字典转json字符串
- (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}
#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    AppDelegate *tempDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UserInfoModel *userModel = tempDelegate.userModel;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSString stringWithFormat:@"%ld",userModel.companyid] forKey:@"userid"];
    [params setObject:@"1" forKey:@"number"];
    
    NSString *changePswdUrl = [NSString stringWithFormat:@"%@/App.php/Xunpan/get_all",rootUrl];
    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
    
    [muDic setObject:[self dictionaryToJson:params] forKey:@"data"];
    [manager GET:changePswdUrl parameters:muDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
       self.consultArr = [NewConsultModel mj_objectArrayWithKeyValuesArray:dic[@"data"]];
        
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

- (void)footerRereshing {
    //
    int count = (int)self.consultArr.count / 10;
    int number = count + 1;
    if (number == 1) {
        number = 2;
    }
    AppDelegate *tempDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UserInfoModel *userModel = tempDelegate.userModel;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSString stringWithFormat:@"%ld",userModel.companyid] forKey:@"userid"];
    [params setObject:[NSString stringWithFormat:@"%i",number] forKey:@"number"];
    
    NSString *changePswdUrl = [NSString stringWithFormat:@"%@/App.php/Xunpan/get_all",rootUrl];
    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
    
    [muDic setObject:[self dictionaryToJson:params] forKey:@"data"];
    [manager GET:changePswdUrl parameters:muDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSArray *tmpArr = [NewConsultModel mj_objectArrayWithKeyValuesArray:dic[@"data"]];
        
        [self.consultArr addObjectsFromArray:tmpArr];
        // 刷新表格
        [self.tableView reloadData];
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView footerEndRefreshing];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [self.tableView headerEndRefreshing];
        AlertView *showView = [[AlertView alloc]initWithTitle:@"网络异常" style:kAlertViewStyleFail showTime:kAlerViewShowTimeOneSecond];
        [showView showInView:self.view];
        
    }];
}

-(void)checkDetial
{
    AppDelegate * tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [tempAppDelegate.mainNavigationController pushViewController:[[StatisticsViewController alloc] init] animated:YES];

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backBtnOnClick:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma  mark tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.consultArr.count;
}
-(GrabTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GrabTableViewCell *cell = [GrabTableViewCell cellWithTableView:tableView indexpath:indexPath];
    cell.model = self.consultArr[indexPath.row];
    UIButton *qiangBtn = [cell.contentView viewWithTag:1010];
    [qiangBtn addTarget:self action:@selector(qiangButton:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80 * SCREEN_SCALE_H;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NewConsultModel *model = self.consultArr[indexPath.row];
    if ([model.workerid integerValue]==0) {
        
        [self requestGrabCaseWithModel:model];
        
    }else{
        AlertView *alterView = [[AlertView alloc]initWithTitle:@"已被抢" style:kAlertViewStyleWarn showTime:kAlerViewShowTimeOneSecond];
        [alterView showInView:self.view];
    }
    
}

-(void)requestGrabCaseWithModel:(NewConsultModel *)model
{
    AppDelegate *tempDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UserInfoModel *userModel = tempDelegate.userModel;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:model.itemid forKey:@"visitorid"];
    [params setObject:[NSString stringWithFormat:@"%ld",userModel.userid] forKey:@"itemid"];
    
    NSString *changePswdUrl = [NSString stringWithFormat:@"%@/App.php/Xunpan/single",rootUrl];
    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
    
    [muDic setObject:[self dictionaryToJson:params] forKey:@"data"];
    [manager GET:changePswdUrl parameters:muDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([dic[@"return"]isEqualToString:@"1"]) {
            ChatViewController *vistor = [[ChatViewController alloc]init];
            vistor.msgDic = [NSMutableDictionary dictionary];
            [vistor.msgDic setObject:model.itemid forKey:@"itemid"];
            [vistor.msgDic setObject:dic[@"nameid"] forKey:@"nameid"];
            
            vistor.title = [NSString stringWithFormat:@"%@客户",model.country];
            [self.navigationController pushViewController:vistor animated:YES];
            
        } else{
            AlertView *alterView = [[AlertView alloc]initWithTitle:@"抢单失败" style:kAlertViewStyleWarn showTime:kAlerViewShowTimeOneSecond];
            [alterView showInView:self.view];
        }
        
        [self.tableView reloadData];
        
        [self headerRereshing];
        
        NSLog(@"%@",dic[@"return"]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        AlertView *alterView = [[AlertView alloc]initWithTitle:@"抢单失败" style:kAlertViewStyleWarn showTime:kAlerViewShowTimeOneSecond];
        [alterView showInView:self.view];
        
        
    }];


}

- (void)qiangButton:(UIButton *)sender {
    NSLog(@"qiang.......");
    [sender setImage:[UIImage imageNamed:@"icon_grap_default"] forState:UIControlStateNormal];
    UITableViewCell * cell = (UITableViewCell *)[[sender superview] superview];
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    [self tableView:self.tableView didSelectRowAtIndexPath:path];
}

@end
