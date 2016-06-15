//
//  RecordViewController.m
//  乐企信
//
//  Created by 震霄 张 on 16/4/5.
//  Copyright © 2016年 SDW. All rights reserved.
//

#import "RecordViewController.h"
#import "RecordCmCell.h"
#import "CommentModel.h"
#import "CommentFrame.h"
#import "WBPopMenuModel.h"
#import "WBPopMenuSingleton.h"
#import "CmInfoViewController.h"
#import "AppDelegate.h"

@interface RecordViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)NSMutableArray *recordArr;
@property (nonatomic,strong)NSMutableArray *choiceArr;
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,assign)ChoiceStatus choiceStatus;
@property (nonatomic,assign)NSInteger refreshCount;

@end

@implementation RecordViewController



-(NSMutableArray *)recordArr
{
    if (_recordArr == nil) {
        _recordArr  = [NSMutableArray array];
    }
    return _recordArr;
}

-(NSMutableArray *)choiceArr
{
    if (_choiceArr == nil) {
        _choiceArr = [NSMutableArray array];
    }
    return _choiceArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ZXcolor(239, 239, 244);
    self.choiceStatus = ChoiceStatusHandled;

    [self setupNav];
    [self setupRecordCommentView];
    
    //集成刷新控件
    [self setupRefresh];
}
-(void)setupNav
{
    //导航栏透明处理
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
     self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"bt_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClick:)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    self.title = @"评论记录";
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"全部" style:UIBarButtonItemStylePlain target:self action:@selector(screenOut)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    

    
}

-(void)screenOut
{
    NSMutableArray *obj = [NSMutableArray array];
    
    for (NSInteger i = 0; i < [self titles].count; i++) {
        
        WBPopMenuModel * info = [WBPopMenuModel new];
        info.image = [self images][i];
        info.title = [self titles][i];
        [obj addObject:info];
    }
    
    [[WBPopMenuSingleton shareManager]showPopMenuSelecteWithFrame:150
                                                             item:obj
                                                           action:^(NSInteger index)
    {
        NSLog(@"index:%ld",(long)index);
                                                               
       if (index == 0) {
           self.choiceStatus = ChoiceStatusHandled;
           [self.navigationItem.rightBarButtonItem setTitle:@"全部"];

       }else if (index == 1){
           self.choiceStatus = ChoiceStatusPassed;
           [self.navigationItem.rightBarButtonItem setTitle:@"通过"];
       }else{
           self.choiceStatus = ChoiceStatusTrash;
           [self.navigationItem.rightBarButtonItem setTitle:@"垃圾"];

       }
       
        [self arrayChoiceWithStatus:self.choiceStatus];

        [self.tableView reloadData];
   }];
}
- (NSArray *) titles {
    return @[@"全部",
             @"通过",
             @"垃圾"
             ];
}

- (NSArray *) images {
    return @[@"icont-quanbu",
             @"icon_tongguo",
             @"icon_laji"
             ];
}
-(void)arrayChoiceWithStatus:(ChoiceStatus)choiceStatus
{
    //NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self.recordArr];
    self.choiceArr = nil;
    if (choiceStatus == ChoiceStatusPassed) {
        for (int i = 0;i<self.recordArr.count;i++) {
            CommentFrame *f = (CommentFrame *)self.recordArr[i];
            if ([f.model.ischecked isEqualToString:@"1"]) {
                [self.choiceArr addObject:f];
            }
        }
    }else if(choiceStatus == ChoiceStatusTrash){
        for (int i = 0;i<self.recordArr.count;i++) {
            CommentFrame *f = (CommentFrame *)self.recordArr[i];
            if ([f.model.ischecked isEqualToString:@"2"]) {
                [self.choiceArr addObject:f];
            }
        }
    }else{//已经处理的//![f.model.ischecked isEqualToString:@"1"] && ![f.model.ischecked isEqualToString:@"2"]
        for (int i = 0;i<self.recordArr.count;i++) {
            CommentFrame *f = (CommentFrame *)self.recordArr[i];
            if ([f.model.ischecked isEqualToString:@"1"] || [f.model.ischecked isEqualToString:@"2"]) {
                [self.choiceArr addObject:f];
            }
        }
    }

}
-(void)backBtnClick:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupRecordCommentView
{
    UIView *bgView = [[UIView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:bgView];
    UILabel *showLabel = [[UILabel alloc]init];
    showLabel.text = @"暂无记录数据";
    showLabel.font = [UIFont systemFontOfSize:25];
    showLabel.frame = CGRectMake(0, SCREEN_H*0.4, SCREEN_W, 100);
    showLabel.textColor = [UIColor grayColor];
    showLabel.adjustsFontSizeToFitWidth = YES;
    showLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:showLabel];
    
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64)];
    tableView.backgroundColor = ZXcolor(235, 235, 235);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[RecordCmCell class] forCellReuseIdentifier:@"recordCmCell"];
    self.tableView = tableView;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    [self.view addSubview:tableView];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.choiceArr.count;
}
-(RecordCmCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecordCmCell *cell = [RecordCmCell cellWithTableView:tableView indexpath:indexPath];

    cell.cmframe = self.choiceArr[indexPath.row];
    if (indexPath.row == self.choiceArr.count-1) {
        cell.lineView.hidden = YES;
    }else{
        cell.lineView.hidden = NO;
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentFrame *cmFrame = self.choiceArr[indexPath.row];
    return cmFrame.cellHeight;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CommentFrame *cmFrame = self.choiceArr[indexPath.row];
    CmInfoViewController *vc = [[CmInfoViewController alloc]init];
    
    if ([cmFrame.model.ischecked isEqualToString:@"1"]) {//通过
        vc.cmframe = cmFrame;
        [self.navigationController pushViewController:vc animated:YES];

    }
   }


/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    //    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    // dateKey用于存储刷新时间，可以保证不同界面拥有不同的刷新时间
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"recordTable"];
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
    [params setObject:@"4" forKey:@"judge"];
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
        
        if (modelArr.count == 0) {
            self.tableView.alpha = 0.5;
        }else{
            self.tableView.alpha = 1.0;
        }
        
        [self.recordArr removeAllObjects];
        
        for (int i = 0; i<modelArr.count; i++) {
            CommentModel *cmModel = modelArr[i];
//            cmModel.status = CommentStatusNoHandle;
            CommentFrame *cmFrame = [[CommentFrame alloc]init];
            cmFrame.model = cmModel;
            if (![cmModel.ischecked isEqualToString:@""]) {
            
                [self.recordArr addObject:cmFrame];
            }
        }
        
        self.choiceArr = self.recordArr;
        [self arrayChoiceWithStatus:self.choiceStatus];
        // 刷新表格
        [self.tableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView headerEndRefreshing];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [self.tableView headerEndRefreshing];
        
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
    [params setObject:@"1" forKey:@"judge"];
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
            [self.recordArr addObject:cmFrame];
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
