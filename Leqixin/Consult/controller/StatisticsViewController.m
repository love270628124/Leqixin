//
//  StatisticsViewController.m
//  乐企信
//
//  Created by 震霄 张 on 16/3/18.
//  Copyright © 2016年 SDW. All rights reserved.
//

#import "StatisticsViewController.h"
#import "AppDelegate.h"
#import "WJItemsControlView.h"
#import "UUChart.h"
#import "ConsultTableViewCell.h"
#import "ComPassView.h"
#import "ConsultModel.h"
#import "VistorModel.h"
#import "ChatViewController.h"
#import "NewConsultModel.h"

#define padding 10
#define headViewHeight 30

@interface StatisticsViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UUChartDataSource>

@property (nonatomic,strong)WJItemsControlView *itemControlView;
@property (nonatomic,strong)UITableView *serviceInfoTableView;
@property (nonatomic,weak)UIScrollView *choiceScrollView;
@property (nonatomic,weak)UIView *dataView;
@property (nonatomic,strong)NSArray *choiceArr;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)UITableView *mineConsultTableView;
@property (nonatomic,weak)UUChart *chartView;
@property (nonatomic,weak)ComPassView *cpView;
@property (nonatomic,weak)UIView *remindView;
@property (nonatomic,weak)UILabel *dayLabel;//趋势图中的天数选项

@property (nonatomic,strong)ConsultModel *consultModel;//询盘接待数据
@property (nonatomic,strong)NSMutableArray *receptionInfoArr;//接待详情数组
@property (nonatomic,strong)NSMutableArray *mineRecInfoArr;//我的询盘
@property (nonatomic,strong)NSDictionary *list7;
@property (nonatomic,strong)NSDictionary *list30;
@property (nonatomic,assign)BOOL isList7;
@end

@implementation StatisticsViewController

-(NSMutableArray *)receptionInfoArr
{
    if (_receptionInfoArr == nil) {
        _receptionInfoArr = [NSMutableArray array];
    }
    return _receptionInfoArr;
}
-(NSMutableArray *)mineRecInfoArr
{
    if (_mineRecInfoArr == nil) {
        _mineRecInfoArr = [NSMutableArray array];
    }
    return _mineRecInfoArr;
}
//选择项数组
-(NSArray *)choiceArr
{
    if (_choiceArr == nil) {
        _choiceArr = @[@"综合统计",@"趋势图",@"我的询盘"];
    }
    return _choiceArr;
}
//综合统计数据
-(NSMutableArray *)dataArr
{
    if (_dataArr == nil) {
        
        _dataArr =[NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ZXcolor(235, 235, 235);
    self.isList7 = YES;

    [self setupNav];
    [[JSSDWProgressHUD shareProgressHud]showWithSuperView:self.view];
//    [self requestConsultData];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [[JSSDWProgressHUD shareProgressHud]showWithSuperView:self.view];
    [self requestConsultData];
    

}
-(void)requestConsultData
{
    AppDelegate *tempDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UserInfoModel *userModel = tempDelegate.userModel;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSString stringWithFormat:@"%ld",(long)userModel.companyid] forKey:@"userid"];
    [params setObject:[NSString stringWithFormat:@"%ld",(long)userModel.userid] forKey:@"itemid"];
    //    [params setObject:[NSString stringWithFormat:@"%ld",self.refreshCount] forKey:@"number"];
    
    NSString *changePswdUrl = [NSString stringWithFormat:@"%@/App.php/Xunpan/get_get",rootUrl];
    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
//    [muDic setObject:@"Interface" forKey:@"g"];
//    [muDic setObject:@"Newask" forKey:@"m"];
//    [muDic setObject:@"get_get" forKey:@"a"];
    
    [muDic setObject:[self dictionaryToJson:params] forKey:@"data"];
    [manager GET:changePswdUrl parameters:muDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ( [dic[@"result"] intValue] != 200) {
            return ;
        }
//        NSDictionary *dataDic = dic[@"data"];// 汇总数据
        ConsultModel *consultModel = [ConsultModel mj_objectWithKeyValues:dic[@"data"]];
        NSInteger recInt = [consultModel.reception integerValue];
        NSInteger totalInt = [consultModel.total integerValue];
        NSInteger recTodayInt = [consultModel.reception_today integerValue];
        NSInteger totalTodayInt = [consultModel.total_today integerValue];
        consultModel.totalReceptRate = [NSString stringWithFormat:@"%.2f",(double)recInt/totalInt];
        consultModel.todayReceptRate = [NSString stringWithFormat:@"%.2f",(double)recTodayInt/totalTodayInt];
        self.consultModel = consultModel;
        
//         @[@"总询盘数\n",@"总接待率\n",@"今日询盘数\n",@"今日接待率\n"]
        NSInteger rate1 = [self.consultModel.totalReceptRate doubleValue]*100;
        NSInteger rate2 = [self.consultModel.todayReceptRate doubleValue]*100;
        [self.dataArr addObject:[NSString stringWithFormat:@"总询盘数\n%@",self.consultModel.total]];
        [self.dataArr addObject:[NSString stringWithFormat:@"总接待率\n%ld%%",(long)rate1]];
        [self.dataArr addObject:[NSString stringWithFormat:@"今日询盘数\n%@",self.consultModel.total_today]];
        [self.dataArr addObject:[NSString stringWithFormat:@"今日接待率\n%ld%%",(long)rate2]];

        //接待详情数据
        self.receptionInfoArr = [VistorModel mj_objectArrayWithKeyValuesArray:dic[@"data_z"]];
        self.mineRecInfoArr = [VistorModel mj_objectArrayWithKeyValuesArray:dic[@"data_w"]];
        
        //检查是否有新消息
        [self setNewMsgTag];
        
        //趋势图数据
        NSDictionary *list7Dic = dic[@"list_7"];
        self.list7 = list7Dic;
        NSDictionary *list30Dic = dic[@"list_30"];
        self.list30 = list30Dic;


        //加载界面
        [self setupComPassView];
        [self setupDetialPic];

        [[JSSDWProgressHUD shareProgressHud]hiddenProgressHud];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        AlertView *showView = [[AlertView alloc]initWithTitle:@"网络异常" style:kAlertViewStyleFail showTime:kAlerViewShowTimeOneSecond];
        [showView showInView:self.view];
        [[JSSDWProgressHUD shareProgressHud]hiddenProgressHud];
    }];

}
//修改我的抢单中有新消息的红点状态
-(void)setNewMsgTag
{
    AppDelegate *tempDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (tempDelegate.haveNewMsgIdArr.count == 0) {
        return;
    }
    if (self.mineRecInfoArr.count == 0) {
        return;
    }
    for (int i = 0; i<tempDelegate.haveNewMsgIdArr.count; i++) {
        for (int j = 0; j<self.mineRecInfoArr.count; j++) {
            VistorModel *model = self.mineRecInfoArr[j];
            if ([tempDelegate.haveNewMsgIdArr[i] isEqualToString:model.itemid]) {
                model.isHaveNewMsg = YES;
                NSLog(@"newMsgId:%@",model.itemid);
                [self.mineRecInfoArr replaceObjectAtIndex:j withObject:model];

            }
        }
    }
    
    
}
-(NSArray *)arrayWithDic:(NSDictionary *)dic
{
    NSMutableArray *tempArr = [NSMutableArray array];
    for (int i = 0; i<7; i++) {
        NSString *x = [NSString stringWithFormat:@"%d",i+1];
        [tempArr addObject:dic[x]];
    }
    return [NSArray arrayWithArray:tempArr];
}

-(void)setupNav
{
//    //导航栏透明处理
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"daohaglan_bg"] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    //
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"bt_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClick:)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    self.title = @"访客咨询";
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

-(void)backBtnClick:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setupComPassView
{
    ComPassView *cpView = [[ComPassView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H * 0.35)];
    cpView.Fvalue = [self.consultModel.totalReceptRate doubleValue] * 100;
    cpView.totleScore = [self.consultModel.total integerValue];
    cpView.duration = 1.0f;
    [self.view addSubview:cpView];
    self.cpView = cpView;

}
//加载细节图
-(void)setupDetialPic
{
    //NSArray *array = @[@"综合统计",@"趋势图",@"我的询盘"];
    
    float widht = [UIScreen mainScreen].bounds.size.width;
    float heith = [UIScreen mainScreen].bounds.size.height-self.cpView.height;
    CGFloat choiceHeight = 44;
    
    //3页内容的scrollView
    UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.cpView.frame)+choiceHeight, widht, heith-choiceHeight)];
    scroll.backgroundColor = [UIColor whiteColor];
    scroll.bounces = NO;//禁止滑动弹性
    scroll.delegate = self;
    scroll.pagingEnabled = YES;
    scroll.contentSize = CGSizeMake(widht*self.choiceArr.count, 100);
    self.choiceScrollView = scroll;
    //加载接待详情页面
    [self setupServiceInfoView];
    //加载趋势图页面
    [self setupDataPicView];
    //加载我的询盘页面
    [self setupMineConsultView];
    
    [self.view addSubview:scroll];
    
    //头部控制的segMent
    WJItemsConfig *config = [[WJItemsConfig alloc]init];
    config.itemWidth = widht/3.0;
    
    _itemControlView = [[WJItemsControlView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.cpView.frame), widht, choiceHeight)];
    _itemControlView.tapAnimation = YES;
    _itemControlView.config = config;
    _itemControlView.titleArray = self.choiceArr;

    
    __weak typeof (scroll)weakScrollView = scroll;
    [_itemControlView setTapItemWithIndex:^(NSInteger index,BOOL animation){
        
        [weakScrollView scrollRectToVisible:CGRectMake(index*weakScrollView.frame.size.width, 0.0, weakScrollView.frame.size.width,weakScrollView.frame.size.height) animated:animation];
    }];
    
    if (self.isShowMineFirst) {
        _itemControlView.tapItemWithIndex(2,YES);
        
    }else{
        _itemControlView.tapItemWithIndex(0,YES);
    }
    
    [self.view addSubview:_itemControlView];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        return;
    }
    float offset = scrollView.contentOffset.x;
    offset = offset/CGRectGetWidth(scrollView.frame);
    [_itemControlView moveToIndex:offset];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        return;
    }
    float offset = scrollView.contentOffset.x;
    offset = offset/CGRectGetWidth(scrollView.frame);
    [_itemControlView endMoveToIndex:offset];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)openLeftVCAction
//{
//    if ([self.sideMenuViewController respondsToSelector:@selector(presentLeftViewController)]) {
//        [self.sideMenuViewController presentLeftViewController];
//    }
//}

#pragma mark - serviceInfoTableView
-(void)setupServiceInfoView
{
    UIView *dataView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 60*SCREEN_SCALE_H)];
    dataView.backgroundColor = [UIColor whiteColor];
    CGFloat labelWidth = (SCREEN_W-2*3) * 0.25;
//    dataView.backgroundColor = [UIColor blueColor];
    for (int i = 0; i<4; i++) {
//        UIImageView *lineView = [[UIImageView alloc]init];
        UIView *line = [[UIView alloc]init];
//        lineView.image = [UIImage imageNamed:@"icon_line"];
        if (i>0) {
            line.x = labelWidth * i;
            line.y = 5;
            line.width = 1;
            line.height = dataView.height - 10;
            line.backgroundColor = ZXcolor(235, 235, 235);
            [dataView addSubview:line];
        }
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((labelWidth+2) * i, 0, labelWidth-4, dataView.height)];
        label.backgroundColor = [UIColor whiteColor];
        
        label.textAlignment = NSTextAlignmentCenter;
        label.text = self.dataArr[i];
        label.font = [UIFont systemFontOfSize:14];
        label.adjustsFontSizeToFitWidth = YES;
//        label.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
//        label.textColor = [UIColor grayColor];

        label.numberOfLines = 0;
        [dataView addSubview:label];
    }
    
    [self.choiceScrollView addSubview:dataView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(dataView.frame), SCREEN_W, 10)];
    lineView.backgroundColor = ZXcolor(235, 235, 235);
    [self.choiceScrollView addSubview:lineView];
    
    self.dataView = dataView;

    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.dataView.frame)+10, SCREEN_W, self.choiceScrollView.height-dataView.height-54*SCREEN_SCALE_H-headViewHeight * SCREEN_SCALE_H)];
    [self.choiceScrollView addSubview:bgView];
    UILabel *showLabel = [[UILabel alloc]init];
    showLabel.text = @"暂无询盘数据";
    showLabel.font = [UIFont systemFontOfSize:25];
    CGSize size = [showLabel.text sizeWithFont:[UIFont systemFontOfSize:25]];
    showLabel.frame = CGRectMake(0, bgView.height*0.4, bgView.width, size.height);
    showLabel.textColor = [UIColor grayColor];
    showLabel.adjustsFontSizeToFitWidth = YES;
    showLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:showLabel];
    
    
    self.serviceInfoTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.dataView.frame)+10, SCREEN_W, self.choiceScrollView.height-dataView.height-54*SCREEN_SCALE_H-headViewHeight * SCREEN_SCALE_H)];
    
    self.serviceInfoTableView.tag = SER_TABLE_TAG;
    self.serviceInfoTableView.dataSource = self;
    self.serviceInfoTableView.delegate = self;
    self.serviceInfoTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.serviceInfoTableView registerClass:[ConsultTableViewCell class] forCellReuseIdentifier:@"consultCell"];
    [self.choiceScrollView addSubview:self.serviceInfoTableView];
   
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == SER_TABLE_TAG) {

        if (self.receptionInfoArr.count == 0) {
            self.serviceInfoTableView.alpha = 0.5;
        }else{
            self.serviceInfoTableView.alpha = 1.0;
        }
        return self.receptionInfoArr.count;
        
    }else if (tableView.tag == MINE_TABLE_TAG){

        if (self.mineRecInfoArr.count == 0) {
            self.mineConsultTableView.alpha = 0.5;
        }else{
            self.mineConsultTableView.alpha = 1.0;
        }
        return self.mineRecInfoArr.count;


    }else
        return 0;
}

-(ConsultTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == SER_TABLE_TAG) {
        ConsultTableViewCell *cell = [ConsultTableViewCell cellWithTableView:tableView indexpath:indexPath];
        cell.vistorModel = self.receptionInfoArr[indexPath.row];
        return cell;
    }else if(tableView.tag == MINE_TABLE_TAG){
        ConsultTableViewCell *cell = [ConsultTableViewCell cellWithTableView:tableView indexpath:indexPath];
        cell.vistorModel = self.mineRecInfoArr[indexPath.row];
        return cell;
    }else
        return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView.tag == SER_TABLE_TAG) {
        return headViewHeight * SCREEN_SCALE_H;
    }else
        return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W - 20*SCREEN_SCALE_W, headViewHeight*SCREEN_SCALE_H)];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(12*SCREEN_SCALE_W, 0, SCREEN_W-20*SCREEN_SCALE_W, headView.height)];
    titleLabel.text = @"接待详情";
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = ZXcolor(153, 153, 153);
    headView.backgroundColor = [UIColor whiteColor];
    [headView addSubview:titleLabel];
    
    UIImageView *lineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame), self.serviceInfoTableView.frame.size.width, 1)];
    lineImgView.image = [UIImage imageNamed:@"data_huixian"];
    [headView addSubview:lineImgView];
    
    if (tableView.tag == SER_TABLE_TAG) {
        return headView;
    }else
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView.tag != MINE_TABLE_TAG) {
        return;
    }
    VistorModel *vistor = self.mineRecInfoArr[indexPath.row];
    
    ChatViewController *chatVc = [[ChatViewController alloc]init];
    chatVc.msgDic = [NSMutableDictionary dictionary];
    [chatVc.msgDic setValue:vistor.itemid forKey:@"itemid"];
    [chatVc.msgDic setObject:vistor.nameid forKey:@"nameid"];
    chatVc.title = [NSString stringWithFormat:@"%@客户",vistor.itemid];
    [self.navigationController pushViewController:chatVc animated:YES];
    
    AppDelegate *tempDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (tempDelegate.haveNewMsgIdArr.count==0) {
        return;
    }
    for (int i = 0; i<tempDelegate.haveNewMsgIdArr.count; i++) {
        if ([tempDelegate.haveNewMsgIdArr[i] isEqualToString:vistor.itemid]) {
            [tempDelegate.haveNewMsgIdArr removeObjectAtIndex:i];
            vistor.isHaveNewMsg = NO;
            [self.mineRecInfoArr replaceObjectAtIndex:indexPath.row withObject:vistor];
        }
    }
    
    [self.mineConsultTableView reloadData];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70 * SCREEN_SCALE_H;
}
#pragma mark   加载趋势图页面
-(void)setupDataPicView
{
    UIButton *daySelectBtn = [[UIButton alloc]init];
    if (self.isList7 == YES) {
        [daySelectBtn setBackgroundImage:[UIImage imageNamed:@"btn_qiehuan7"] forState:UIControlStateNormal];
    }else{
        [daySelectBtn setBackgroundImage:[UIImage imageNamed:@"btn_qiehuan30"] forState:UIControlStateNormal];

    }
    daySelectBtn.height = 22* SCREEN_SCALE_H;
    daySelectBtn.width = 66 * SCREEN_SCALE_W;
    daySelectBtn.x = SCREEN_W - daySelectBtn.width - 12 * SCREEN_SCALE_W + SCREEN_W;
    daySelectBtn.y = 7 * SCREEN_SCALE_H;
    [daySelectBtn addTarget:self action:@selector(daySelectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.choiceScrollView addSubview:daySelectBtn];
    
    UIView *remindView = [[UIView alloc]init];
    remindView.backgroundColor = [UIColor whiteColor];
    remindView.frame = CGRectMake(SCREEN_W+12*SCREEN_SCALE_W, 36*SCREEN_SCALE_H, SCREEN_W-20*SCREEN_SCALE_W, 72*SCREEN_SCALE_H);
    [self.choiceScrollView addSubview:remindView];
    self.remindView = remindView;
    self.remindView.backgroundColor = [UIColor whiteColor];
    [self setupRemindView];
    
    UUChart *chartView = [[UUChart alloc]initWithFrame:CGRectMake(SCREEN_W*1+12*SCREEN_SCALE_W, CGRectGetMaxY(remindView.frame), remindView.width, 170*SCREEN_SCALE_H)
                                            dataSource:self
                                            style:UUChartStyleLine];
    self.chartView = chartView;
    [chartView showInView:self.choiceScrollView];

}
-(void)setupRemindView
{
    UILabel *label1 = [[UILabel alloc]init];
    label1.textColor = ZXcolor(102, 102, 102);
    label1.x = 10 * SCREEN_SCALE_W;
    label1.y = 10 * SCREEN_SCALE_H;
    label1.text = @"已接待";
    label1.font = [UIFont systemFontOfSize:12];
    label1.size = [label1.text sizeWithFont:[UIFont systemFontOfSize:12]];
    [self.remindView addSubview:label1];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label1.frame)+8*SCREEN_SCALE_W, label1.centerY, 30*SCREEN_SCALE_W, 1)];
    line1.backgroundColor = ZXcolor(10, 212, 134);
    [self.remindView addSubview:line1];

    UILabel *label2 = [[UILabel alloc]init];
    label2.textColor = ZXcolor(102, 102, 102);
    label2.x = label1.x;
    label2.y = CGRectGetMaxY(label1.frame)+2*SCREEN_SCALE_H;
    label2.text = @"未接待";
    label2.font = [UIFont systemFontOfSize:12];
    label2.size = [label1.text sizeWithFont:[UIFont systemFontOfSize:12]];
    [self.remindView addSubview:label2];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(line1.x, label2.centerY, 30*SCREEN_SCALE_W, 1)];
    line2.backgroundColor = ZXcolor(247, 168, 29);
    [self.remindView addSubview:line2];
    
    UILabel *label3 = [[UILabel alloc]init];
    label3.textColor = ZXcolor(102, 102, 102);
    label3.x = label1.x;
    label3.y = CGRectGetMaxY(label2.frame)+2*SCREEN_SCALE_H;
    label3.text = @"我接待";
    label3.font = [UIFont systemFontOfSize:12];
    label3.size = [label1.text sizeWithFont:[UIFont systemFontOfSize:12]];
    [self.remindView addSubview:label3];
    
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(line1.x, label3.centerY, 30*SCREEN_SCALE_W, 1)];
    line3.backgroundColor = ZXcolor(204, 204, 204);
    [self.remindView addSubview:line3];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"询盘统计";
    titleLabel.textColor = ZXcolor(51, 51, 51);
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.y = 0;
    titleLabel.size = [titleLabel.text sizeWithFont:[UIFont systemFontOfSize:18]];
    titleLabel.x = self.remindView.width*0.5 - titleLabel.size.width * 0.5;
    [self.remindView addSubview:titleLabel];
    
    UILabel *dayLabel = [[UILabel alloc]init];
    self.dayLabel = dayLabel;
    dayLabel.y = CGRectGetMaxY(titleLabel.frame)+5*SCREEN_SCALE_H;
    if (self.isList7) {
        dayLabel.text = @"最近7天走势图";
    }else{
        dayLabel.text = @"最近30天走势图";

    }
    dayLabel.font = [UIFont systemFontOfSize:14];
    dayLabel.textColor = ZXcolor(102, 102, 102);
    dayLabel.size = [dayLabel.text sizeWithFont:[UIFont systemFontOfSize:14]];
    dayLabel.x = (self.remindView.width - dayLabel.size.width)*0.5;
    [self.remindView addSubview:dayLabel];
}
-(void)daySelectBtnClick:(UIButton *)btn
{
    self.isList7 = !self.isList7;
    [self setupDataPicView];
}
#pragma  mark 加载我的询盘页面
-(void)setupMineConsultView
{
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_W*2, 0, SCREEN_W, SCREEN_H-CGRectGetMaxY(self.cpView.frame)-54*SCREEN_SCALE_H)];
    [self.choiceScrollView addSubview:bgView];
    UILabel *showLabel = [[UILabel alloc]init];
    showLabel.text = @"暂无询盘数据";
    showLabel.font = [UIFont systemFontOfSize:25];
    CGSize size = [showLabel.text sizeWithFont:[UIFont systemFontOfSize:25]];
    showLabel.frame = CGRectMake(0, bgView.height*0.4, bgView.width, size.height);
    showLabel.textColor = [UIColor grayColor];
    showLabel.adjustsFontSizeToFitWidth = YES;
    showLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:showLabel];
    
    
    self.mineConsultTableView = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_W*2, 0, SCREEN_W, SCREEN_H-CGRectGetMaxY(self.cpView.frame)-54*SCREEN_SCALE_H-64)];
    self.mineConsultTableView.tag = MINE_TABLE_TAG;
    self.mineConsultTableView.dataSource = self;
    self.mineConsultTableView.delegate = self;
    self.mineConsultTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    [self.mineConsultTableView registerClass:[ConsultTableViewCell class] forCellReuseIdentifier:@"consultCell"];
    [self.choiceScrollView addSubview:self.mineConsultTableView];

}


#pragma mark UUChartDataSource
- (NSArray *)getXTitles:(int)num
{
    if (self.isList7) {
        return @[@"1",@"2",@"3",@"4",@"5",@"6",@"7"];
    }else{
        return @[@"1",@"6",@"11",@"16",@"21",@"26",@"30"];
    }
}

#pragma mark - @required
//横坐标标题数组
- (NSArray *)chartConfigAxisXLabel:(UUChart *)chart
{
    return [self getXTitles:7];
    
}
//数值多重数组
- (NSArray *)chartConfigAxisYValue:(UUChart *)chart
{
    
    if (self.isList7) {
        NSArray *ary1 = [self arrayWithDic:self.list7[@"yi"]];
        NSArray *ary2 = [self arrayWithDic:self.list7[@"wei"]];
        NSArray *ary3 = [self arrayWithDic:self.list7[@"wo"]];
        
        return @[ary1,ary2,ary3];
    }else{
        NSArray *ary1 = [self arrayWithDic:self.list30[@"yi"]];
        NSArray *ary2 = [self arrayWithDic:self.list30[@"wei"]];
        NSArray *ary3 = [self arrayWithDic:self.list30[@"wo"]];
        
        return @[ary1,ary2,ary3];
    }
}

#pragma mark - @optional
//颜色数组
- (NSArray *)chartConfigColors:(UUChart *)chart
{
    return @[[UUColor green],[UUColor orangeColor],[UUColor grayColor]];
}
//显示数值范围
- (CGRange)chartRange:(UUChart *)chart
{
//    return CGRangeMake(12, 0);
    if (self.isList7) {
        NSArray *ary1 = [self arrayWithDic:self.list7[@"yi"]];
        NSArray *ary2 = [self arrayWithDic:self.list7[@"wo"]];
        NSArray *ary3 = [self arrayWithDic:self.list7[@"wei"]];
        NSInteger a = [self getMaxValueFromArr:ary1];
        NSInteger b = [self getMaxValueFromArr:ary2];
        NSInteger c = [self getMaxValueFromArr:ary3];
        NSInteger max = (a>b?(a>c?a:c):(b>c?b:c));
        NSInteger maxH = [self getMaxH:max];
        
        return CGRangeMake(maxH, 0);
    }else{
        NSArray *ary1 = [self arrayWithDic:self.list30[@"yi"]];
        NSArray *ary2 = [self arrayWithDic:self.list30[@"wo"]];
        NSArray *ary3 = [self arrayWithDic:self.list30[@"wei"]];
        NSInteger a = [self getMaxValueFromArr:ary1];
        NSInteger b = [self getMaxValueFromArr:ary2];
        NSInteger c = [self getMaxValueFromArr:ary3];
        NSInteger max = (a>b?(a>c?a:c):(b>c?b:c));
        NSInteger maxH = [self getMaxH:max];
        return CGRangeMake(maxH, 0);
    }
    
}
//获取数组中的最大值
-(NSInteger)getMaxValueFromArr:(NSArray *)strArray
{
    if (strArray.count == 0) {
        return 0;
    }
    NSInteger max = [strArray[0] integerValue];
    for (int i = 0; i<strArray.count; i++) {
        if ([strArray[i] integerValue]>max) {
            max = [strArray[i] integerValue];
        }
    }
    return max;
}
-(NSInteger)getMaxH:(NSInteger)max
{
    NSInteger i = 1;
    while (max>i*4) {
        i++;
    }
    
    NSInteger maxH = i*4+10;
    while (maxH%10!=0) {
        maxH++;
    }
    return maxH;
}
#pragma mark 折线图专享功能

//判断显示横线条
- (BOOL)chart:(UUChart *)chart showHorizonLineAtIndex:(NSInteger)index
{
    return YES;
}

//判断显示最大最小值
- (BOOL)chart:(UUChart *)chart showMaxMinAtIndex:(NSInteger)index
{
    return YES;
}
//字典转json字符串
- (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}
@end
