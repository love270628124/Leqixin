//
//  UpdateViewController.m
//  SDWTestProduct
//
//  Created by Raija on 16/4/19.
//  Copyright © 2016年 Lqing. All rights reserved.
//

#import "UpdateViewController.h"
#import "WebData.h"

#define kWidth [[UIScreen mainScreen] bounds].size.width
#define kHeight [[UIScreen mainScreen] bounds].size.height
#define AUTOLAYTOU(a) ((a)*(kWidth/320))

@interface UpdateViewController () <UITableViewDataSource,UITableViewDelegate> {
    NSMutableArray *alertNameArr;
    NSMutableArray *alertDataArr;
    NSString *alertDateStr;
}

@property (nonatomic, strong) UITableView *updataTView;     //数据列表
@property (nonatomic, strong) NSMutableArray *titleArr;     //统计时间数组
@property (nonatomic, strong) NSArray *nameArr;             //左侧名称数组
@property (nonatomic, strong) NSMutableArray *dataArray;    //右侧数据组

@property (nonatomic, strong) NSUserDefaults *defaults;
@property (nonatomic,strong)NSString *tokenStr;//登录E站获取的token
@property (nonatomic,strong)NSString *idStr;//登录E站获取的id
@property (nonatomic,strong)NSArray *modelArr;//模型数组

@end

@implementation UpdateViewController
-(NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(NSArray *)modelArr
{
    if (_modelArr == nil) {
        _modelArr = [NSArray array];
    }
    return _modelArr;
}
-(NSMutableArray *)titleArr
{
    if (_titleArr == nil) {
        _titleArr = [NSMutableArray array];
    }
    return _titleArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
//    if ([self.chergeString isEqualToString:@"true"]) {
        [[JSSDWProgressHUD shareProgressHud]showWithSuperView:self.view];
        [self userLogin];//用户登录E站
        //    alertNameArr = @[@"首页",@"产品页",@"新闻页"];
        //    alertDataArr = @[@"0",@"15",@"8"];
        
        [self alertDataWithRequestData];
//    }
    
}
//设置导航界面
-(void)setupNav
{
    self.view.backgroundColor =[UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1.0];
    //
    //    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 64)];
    //    bgView.backgroundColor =[UIColor colorWithRed:10/255.0 green:212/255.0 blue:134/255.0 alpha:1.0];
    //    [self.view addSubview:bgView];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"bt_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClick:)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    //
    //    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.title = @"数据更新";
    
}
-(void)backBtnClick:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //    self.updataTView.frame = CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-64);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //    [self.defaults setObject:self.titleArr forKey:@"titleArr"];
    //    [self.defaults setObject:self.dataArray forKey:@"dataArr"];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.titleArr count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //绘制cell
    static NSString *idetifier = @"cell";
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idetifier];
    UITableViewCell *cell;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idetifier];
        //backgroundImage
        UIImageView *topImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(self.updataTView.frame) - 20, AUTOLAYTOU(49))];
        topImgView.image = [UIImage imageNamed:@"web_bg_huang"];
        [cell.contentView addSubview:topImgView];
        
        UIImageView *bottomImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(topImgView.frame), CGRectGetWidth(self.updataTView.frame) - 20, AUTOLAYTOU(151))];
        bottomImgView.image = [UIImage imageNamed:@"web_bg_bai"];
        [cell.contentView addSubview:bottomImgView];
        
        for (int i = 0; i < self.nameArr.count; i++) {
            UIImageView *lineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(topImgView.frame) + (i + 1) * AUTOLAYTOU(50), CGRectGetWidth(topImgView.frame), 1)];
            lineImgView.image = [UIImage imageNamed:@"web_huixian"];
            [cell.contentView addSubview:lineImgView];
            
            // data
            UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(29, CGRectGetMaxY(topImgView.frame) + 20 + i * AUTOLAYTOU(50) , CGRectGetWidth(topImgView.frame) / 2, 20)];
            nameL.text = self.nameArr[i];
            nameL.textColor = [UIColor colorWithRed:53/255.0 green:53/255.0 blue:53/255.0 alpha:1.0f];
            nameL.font = [UIFont systemFontOfSize:15.0f];
            [cell.contentView addSubview:nameL];
            
            UILabel *resultL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.updataTView.frame) / 2 - 30, AUTOLAYTOU(49) + 20 + i * AUTOLAYTOU(50) , CGRectGetWidth(self.updataTView.frame) / 2, 20)];
            resultL.textAlignment = NSTextAlignmentRight;
            if (i == 2) {
                resultL.text = [NSString stringWithFormat:@"%@秒",self.dataArray[indexPath.section][i]];
            }else{
                resultL.text = self.dataArray[indexPath.section][i];
                
            }
            resultL.textColor = [UIColor blackColor];
            resultL.font = [UIFont systemFontOfSize:16.0f];
            [cell.contentView addSubview:resultL];
        }
        
        //name
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(23, AUTOLAYTOU(49) / 4, CGRectGetWidth(self.updataTView.frame) - 20, 30)];
        titleL.text = [NSString stringWithFormat:@"%@网站数据统计",self.titleArr[indexPath.section]];
        titleL.textColor = [UIColor whiteColor];
        titleL.font = [UIFont systemFontOfSize:16.0f];
        [cell.contentView addSubview:titleL];
        
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.selected = NO;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.updataTView.frame), 0)];
    UIButton *headerTitle = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 43, 20)];
    [headerTitle setTitle:@"9:00" forState:UIControlStateNormal];
    headerTitle.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [headerTitle setBackgroundImage:[UIImage imageNamed:@"web_bg_time"]
                           forState:UIControlStateNormal];
    [headerTitle setEnabled:NO];
    headerTitle.center = CGPointMake(self.updataTView.center.x, 10);
    [header addSubview:headerTitle];
    
    if (section == 0) {
        
        headerTitle.center = CGPointMake(self.updataTView.center.x, AUTOLAYTOU(234));
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        
        [df setDateFormat:@"MM月dd日"];
        
        NSString *dateStr = [df stringFromDate:[NSDate date]];
        
        [self subViewLoad:header withTopNameString:dateStr withTopImageString:@"data_red" withLeftDataArray:alertNameArr withRightDataArray:alertDataArr];
        
    }
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return (AUTOLAYTOU(260));
    } else {
        
        return AUTOLAYTOU(35);
    }
    
    //    return AUTOLAYTOU(50);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return AUTOLAYTOU(200);
}

#pragma mark - 页面布局

- (void)subViewLoad:(UIView *)aSuperView
  withTopNameString:(NSString *)topNameStr
 withTopImageString:(NSString *)imgNameStr
  withLeftDataArray:(NSArray *)leftArr
 withRightDataArray:(NSArray *)rightArr{
    
    UIView *topUpDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 18, CGRectGetWidth(aSuperView.frame), AUTOLAYTOU(250) - AUTOLAYTOU(50))];
    [aSuperView addSubview:topUpDataView];
    
    UIImageView *topImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(self.updataTView.frame) - 20, AUTOLAYTOU(49))];
    topImgView.image = [UIImage imageNamed:imgNameStr];
    [topUpDataView addSubview:topImgView];
    
    UIImageView *bottomImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(topImgView.frame), CGRectGetWidth(self.updataTView.frame) - 20, CGRectGetHeight(topUpDataView.frame) - AUTOLAYTOU(49))];
    bottomImgView.image = [UIImage imageNamed:@"web_bg_bai"];
    [topUpDataView addSubview:bottomImgView];
    
    for (int i = 0; i < leftArr.count; i++) {
        //显示数据的label
        UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(29, CGRectGetMaxY(topImgView.frame) + 20 + i * AUTOLAYTOU(50) , CGRectGetWidth(topImgView.frame) - 80, 20)];
        nameL.text = [NSString stringWithFormat:@"%@",leftArr[i]];
        nameL.textColor = [UIColor colorWithRed:53/255.0 green:53/255.0 blue:53/255.0 alpha:1.0f];
        nameL.font = [UIFont systemFontOfSize:15.0f];
        [topUpDataView addSubview:nameL];
        //提醒等级的图标名称
        if (rightArr.count > 0) {
            NSString *imgName = [rightArr[i] intValue] >= 0 ? ([rightArr[i] intValue] >= 5 ? ([rightArr[i] intValue] >= 10 ? ([rightArr[i] intValue] >= 15 ? @"data_hongdeng" : @"data_huangdeng"): @"data_landeng") : @"data_lvdeng") : nil;
            if (imgName != nil) {
                UIImageView *rightImgView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(topImgView.frame) - 32, CGRectGetMaxY(topImgView.frame) + 20 + i * AUTOLAYTOU(50), 18, 18)];
                rightImgView.image = [UIImage imageNamed:imgName];
                rightImgView.contentMode = UIViewContentModeScaleToFill;
                [topUpDataView addSubview:rightImgView];
            }
        }
       
        //分割线
        UIImageView *lineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(topImgView.frame) + (i + 1) * AUTOLAYTOU(50), CGRectGetWidth(topImgView.frame), 1)];
        lineImgView.image = [UIImage imageNamed:@"web_huixian"];
        [topUpDataView addSubview:lineImgView];
    }
    //顶部标题名l
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(23, AUTOLAYTOU(49) / 4 + AUTOLAYTOU(8), CGRectGetWidth(self.updataTView.frame) - 20, 30)];
    //为空判断
    if (topNameStr == nil) {
        topNameStr = @"";
    }
    
    titleL.text = [NSString stringWithFormat:@"%@ 网站预警更新",topNameStr];
    titleL.textColor = [UIColor whiteColor];
    titleL.font = [UIFont systemFontOfSize:16.0f];
    [topUpDataView addSubview:titleL];
    //顶部预警帮助按钮
    UIButton *alertTopHelpBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(topImgView.frame) - 33, AUTOLAYTOU(49) / 4 + AUTOLAYTOU(10), 20, 20)];
    [alertTopHelpBtn setBackgroundImage:[UIImage imageNamed:@"data_anniu"] forState:UIControlStateNormal];
    [alertTopHelpBtn addTarget:self action:@selector(alertTopHelpButton:) forControlEvents:UIControlEventTouchUpInside];
    [topUpDataView addSubview:alertTopHelpBtn];
}

//预警提醒按钮事件
- (void)alertTopHelpButton:(UIButton *)aButton {
    //AUTOLAYTOU(246),AUTOLAYTOU(295),date_tanchuang_bg
    //    NSLog(@"弹出提示窗口");
    //
    UIView *popView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_W , SCREEN_H)];
    popView.backgroundColor = [UIColor clearColor];
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:popView.frame];
    bgImgView.image = [UIImage imageNamed:@"data_heidi"];
    [popView addSubview:bgImgView];
    [[UIApplication sharedApplication].keyWindow addSubview:popView];
    //
    UIImageView *popImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 246, 295)];
    popImgView.image = [UIImage imageNamed:@"date_tanchuang_bg"];
    popImgView.contentMode = UIViewContentModeScaleToFill;
    popImgView.center = CGPointMake(CGRectGetMidX(popView.frame), CGRectGetMidY(popView.frame));
    [popView addSubview:popImgView];
    //
    UITextView *alertMes = [[UITextView alloc] initWithFrame:CGRectMake(10, 150, CGRectGetWidth(popImgView.frame) - 20, 100)];
    alertMes.text = @"长时间不更新内容会导致网站在搜索引擎下地排名下降！更新频率越高，越有利于网站的排名。";
    alertMes.textColor = ZXcolor(102, 102, 102);
    alertMes.font = [UIFont systemFontOfSize:16.0f];
    alertMes.center = CGPointMake(CGRectGetMidX(popImgView.frame), CGRectGetMidY(popImgView.frame) + 30);
    alertMes.editable = NO;
    [popView addSubview:alertMes];
    //
    UIButton *knowBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(popImgView.frame) - 45, popView.width, 41)];
    [knowBtn setTitle:@"我知道了" forState:UIControlStateNormal];
    UIColor *titleColor = ZXcolor(0, 170, 238);
    [knowBtn setTitleColor:titleColor forState:UIControlStateNormal];
    knowBtn.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    [knowBtn addTarget:self action:@selector(knowButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [popView addSubview:knowBtn];
    
}
//弹窗消失
- (void)knowButtonPressed:(UIButton *)aButton {
    //    NSLog(@"click I konw button");
    [aButton.superview removeFromSuperview];
    
}

#pragma mark - 预警提醒数据请求

- (void)alertDataWithRequestData {
    //  /index.php?g=Interface&m=New&a=url_detection_api
    AppDelegate *tempDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UserInfoModel *model = tempDelegate.userModel;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSString stringWithFormat:@"%ld",(long)model.companyid] forKey:@"userid"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
    [muDic setObject:@"Interface" forKey:@"g"];
    [muDic setObject:@"New" forKey:@"m"];
    [muDic setObject:@"url_detection_api" forKey:@"a"];
    [muDic setObject:[self dictionaryToJson:params] forKey:@"data"];
    
    [manager GET:[NSString stringWithFormat:@"%@/index.php",rootUrl] parameters:muDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",dic);
        alertNameArr = [NSMutableArray array];
        alertDataArr = [NSMutableArray array];
        NSArray *dicKeys = dic.allKeys;
        NSArray *_sortedArray= [dicKeys sortedArrayUsingSelector:@selector(compare:)];

        for (NSString *key in _sortedArray) {
            
            if([key rangeOfString:@"_t"].location == NSNotFound)//没有_t这个字段
            {
                [alertNameArr addObject:dic[key]];
            } else {
                [alertDataArr addObject:dic[key]];
            }
            
        }
//        NSArray *dicKeys = [dic allKeys];
//        if (dicKeys.count == 6) {
//            alertNameArr = [@[dic[@"url1"],dic[@"url2"],dic[@"url3"]] mutableCopy];
//            
//            alertDataArr = [@[dic[@"url1_t"],dic[@"url2_t"],dic[@"url3_t"]] mutableCopy];
//        }
//        [self.updataTView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        
    }];
    
}

#pragma mark - 数据的懒加载

- (UITableView *)updataTView {
    //懒加载tableView
    if (_updataTView == nil) {
        _updataTView = [[UITableView alloc] initWithFrame:CGRectZero
                                                    style:UITableViewStyleGrouped];
        _updataTView.dataSource = self;
        _updataTView.delegate = self;
        //去掉分割线
        _updataTView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _updataTView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        _updataTView.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.1];
        [self.view addSubview:_updataTView];
    }
    return _updataTView;
}

- (NSArray *)nameArr {
    //懒加载nameArr
    if (_nameArr == nil) {
        _nameArr = @[@"访问量",@"访客数",@"平均访时"];
    }
    return _nameArr;
}

-(void)userLogin
{
    AppDelegate *tempDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UserInfoModel *model = tempDelegate.userModel;
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    //    manger.requestSerializer.timeoutInterval = 5;
    NSString *Eurl = @"http://2016.iezhan.com/ezhan/phone/opt/login";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSString stringWithFormat:@"%ld",(long)model.companyid] forKey:@"uname"];
    [params setObject:@"sdw123456" forKey:@"upwd"];
    [manger POST:Eurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject[@"code"]);
        NSDictionary *loginInfoDic = responseObject[@"param"];
        if (loginInfoDic==nil) {
            return ;
        }
        self.tokenStr = loginInfoDic[@"token"];
        self.idStr = loginInfoDic[@"id"];
        
        NSDate *todayDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        //        NSString *todayStr = [dateFormatter stringFromDate:todayDate];
        
        NSDate *lastDayDate = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:todayDate];//前一天
        NSString *lastDayStr= [dateFormatter stringFromDate:lastDayDate];
        
        NSDate *last7DayDate = [NSDate dateWithTimeInterval:-24*60*60*7 sinceDate:todayDate];//前一天
        NSString *last7DayStr= [dateFormatter stringFromDate:last7DayDate];
        
        [self requestForData:last7DayStr endTime:lastDayStr];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        AlertView *showView = [[AlertView alloc]initWithTitle:@"网络异常" style:kAlertViewStyleFail showTime:kAlerViewShowTimeOneSecond];
        [showView showInView:self.view];
        [[JSSDWProgressHUD shareProgressHud]hiddenProgressHud];
        
    }];
    
}

-(void)requestForData:(NSString *)startTime endTime:(NSString *)endTime
{
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    NSString *Eurl = @"http://2016.iezhan.com/ezhan/phone/get/getAllDataMin";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.idStr forKey:@"id"];
    [params setObject:self.tokenStr forKey:@"token"];
    [params setObject:startTime forKey:@"startime"];
    [params setObject:endTime forKey:@"endtime"];
    
    [manger POST:Eurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject[@"code"]);
        
        NSMutableArray *dataArr = [WebData mj_objectArrayWithKeyValuesArray:responseObject[@"param"]];
        self.modelArr = [NSArray arrayWithArray:dataArr];
        
        //解析模型数据
        [self splitModelToDataArr];
        //加载界面
        [[JSSDWProgressHUD shareProgressHud]hiddenProgressHud];
        self.updataTView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        AlertView *showView = [[AlertView alloc]initWithTitle:@"网络异常" style:kAlertViewStyleFail showTime:kAlerViewShowTimeOneSecond];
        [showView showInView:self.view];
        [[JSSDWProgressHUD shareProgressHud]hiddenProgressHud];
        
    }];
    
}

-(void)splitModelToDataArr
{
    for (int i= 0; i<self.modelArr.count; i++) {
        WebData *data = self.modelArr[i];
        [self.titleArr insertObject:data.time atIndex:0];
        NSMutableArray *tempArr = [NSMutableArray array];
        [tempArr addObject:data.PV];
        [tempArr addObject:data.UV];
        [tempArr addObject:data.SP];
        [self.dataArray insertObject:tempArr atIndex:0];
    }
}

- (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


#if 0

#import "UpdateViewController.h"
#import "WebData.h"

#define kWidth [[UIScreen mainScreen] bounds].size.width
#define kHeight [[UIScreen mainScreen] bounds].size.height
#define AUTOLAYTOU(a) ((a)*(kWidth/320))


@interface UpdateViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *updataTView;     //数据列表
@property (nonatomic, strong) NSMutableArray *titleArr;     //统计时间数组
@property (nonatomic, strong) NSArray *nameArr;             //左侧名称数组
@property (nonatomic, strong) NSMutableArray *dataArray;    //右侧数据组

@property (nonatomic, strong) NSUserDefaults *defaults;
@property (nonatomic,strong)NSString *tokenStr;//登录E站获取的token
@property (nonatomic,strong)NSString *idStr;//登录E站获取的id
@property (nonatomic,strong)NSArray *modelArr;//模型数组
@end

@implementation UpdateViewController
-(NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(NSArray *)modelArr
{
    if (_modelArr == nil) {
        _modelArr = [NSArray array];
    }
    return _modelArr;
}
-(NSMutableArray *)titleArr
{
    if (_titleArr == nil) {
        _titleArr = [NSMutableArray array];
    }
    return _titleArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [[JSSDWProgressHUD shareProgressHud]showWithSuperView:self.view];
    [self userLogin];//用户登录E站

}
//设置导航界面
-(void)setupNav
{
    self.view.backgroundColor =[UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1.0];
//
//    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 64)];
//    bgView.backgroundColor =[UIColor colorWithRed:10/255.0 green:212/255.0 blue:134/255.0 alpha:1.0];
//    [self.view addSubview:bgView];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"bt_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClick:)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
//
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.title = @"数据更新";
    
}
-(void)backBtnClick:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.updataTView.frame = CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-64);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self.defaults setObject:self.titleArr forKey:@"titleArr"];
//    [self.defaults setObject:self.dataArray forKey:@"dataArr"];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.titleArr count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //绘制cell
    static NSString *idetifier = @"cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idetifier];
    UITableViewCell *cell;
//    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idetifier];
        
        //backgroundImage
        UIImageView *topImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(self.updataTView.frame) - 20, AUTOLAYTOU(49))];
        topImgView.image = [UIImage imageNamed:@"web_bg_huang"];
        [cell.contentView addSubview:topImgView];
        
        UIImageView *bottomImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(topImgView.frame), CGRectGetWidth(self.updataTView.frame) - 20, AUTOLAYTOU(151))];
        bottomImgView.image = [UIImage imageNamed:@"web_bg_bai"];
        [cell.contentView addSubview:bottomImgView];
        
        for (int i = 0; i < self.nameArr.count - 1; i++) {
            UIImageView *lineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(topImgView.frame) + (i + 1) * AUTOLAYTOU(50), CGRectGetWidth(topImgView.frame), 1)];
            lineImgView.image = [UIImage imageNamed:@"web_huixian"];
            [cell.contentView addSubview:lineImgView];
            
        }
        
        for (int i = 0; i < self.nameArr.count; i++) {
            // data
            UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(29, CGRectGetMaxY(topImgView.frame) + 20 + i * AUTOLAYTOU(50) , CGRectGetWidth(topImgView.frame) / 2, 20)];
            nameL.text = self.nameArr[i];
            nameL.textColor = [UIColor colorWithRed:53/255.0 green:53/255.0 blue:53/255.0 alpha:1.0f];
            nameL.font = [UIFont systemFontOfSize:15.0f];
            [cell.contentView addSubview:nameL];
            
            UILabel *resultL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.updataTView.frame) / 2 - 19, CGRectGetMaxY(topImgView.frame) + 20 + i * AUTOLAYTOU(50) , CGRectGetWidth(topImgView.frame) / 2, 20)];
            resultL.textAlignment = NSTextAlignmentRight;
            if (i == 2) {
                resultL.text = [NSString stringWithFormat:@"%@秒",self.dataArray[indexPath.section][i]];
            }else{
                resultL.text = self.dataArray[indexPath.section][i];

            }
            resultL.textColor = [UIColor blackColor];
            resultL.font = [UIFont systemFontOfSize:16.0f];
            [cell.contentView addSubview:resultL];
        }
//    }
    
    //name
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(23, AUTOLAYTOU(49) / 4, CGRectGetWidth(self.updataTView.frame) - 20, 30)];
    titleL.text = [NSString stringWithFormat:@"%@网站数据统计",self.titleArr[indexPath.section]];
    titleL.textColor = [UIColor whiteColor];
    titleL.font = [UIFont systemFontOfSize:16.0f];
    [cell.contentView addSubview:titleL];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.selected = NO;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.updataTView.frame), 0)];
    UIButton *headerTitle = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 43, 19)];
    [headerTitle setTitle:@"9:00" forState:UIControlStateNormal];
    headerTitle.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [headerTitle setBackgroundImage:[UIImage imageNamed:@"web_bg_time"]
                           forState:UIControlStateNormal];
    [headerTitle setEnabled:NO];
    headerTitle.center = CGPointMake(self.updataTView.center.x, AUTOLAYTOU(26));
    [header addSubview:headerTitle];
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return AUTOLAYTOU(50);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return AUTOLAYTOU(200);
}

#pragma mark - 数据的懒加载

- (UITableView *)updataTView {
    //懒加载tableView
    if (_updataTView == nil) {
        _updataTView = [[UITableView alloc] initWithFrame:CGRectZero
                                                    style:UITableViewStyleGrouped];
        _updataTView.dataSource = self;
        _updataTView.delegate = self;
        //去掉分割线
        _updataTView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _updataTView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        _updataTView.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.1];
        [self.view addSubview:_updataTView];
    }
    return _updataTView;
}

//- (NSMutableArray *)titleArr {
//    //懒加载titleArr
//    if (_titleArr == nil) {
//        //测试数据
//        _titleArr = [NSMutableArray new];
//        [_titleArr insertObject:self.upDataDict[@"time"] atIndex:0];
////        [_titleArr addObject:@"4月9号"];
////        [_titleArr addObject:@"4月8号"];
////        [_titleArr addObject:@"4月7号"];
////        [_titleArr addObject:@"4月6号"];
////        [_titleArr addObject:@"4月5号"];
//    }
//    
//    return _titleArr;
//}

- (NSArray *)nameArr {
    //懒加载nameArr
    if (_nameArr == nil) {
        _nameArr = @[@"访问量",@"访客数",@"平均访时"];
    }
    return _nameArr;
}

//- (NSMutableArray *)dataArray {
//    //懒加载左侧数据
//    if (_dataArray == nil) {
//        //测试数据
//        _dataArray = [NSMutableArray new];
//        [_dataArray insertObject:self.upDataDict[@"value"] atIndex:0];
////        [_dataArray addObject:@[@"50",@"30",@"15秒",@"35%"]];
////        [_dataArray addObject:@[@"40",@"40",@"35秒",@"50%"]];
////        [_dataArray addObject:@[@"30",@"20",@"25秒",@"30%"]];
////        [_dataArray addObject:@[@"20",@"10",@"15秒",@"20%"]];
////        [_dataArray addObject:@[@"10",@"10",@"10秒",@"10%"]];
//        
//        NSLog(@"dataArray count = %li",_dataArray.count);
//    }
//    return _dataArray;
//}

//- (NSDictionary *)upDataDict {
//    //懒加载upDataDict
//    if (_upDataDict == nil) {
//        //测试数据
////        self.upDataDict = [NSDictionary dictionaryWithObjectsAndKeys:@"4月10号",@"time",@[@"50",@"30",@"15秒",@"35%"],@"value", nil];
//    }
//    
//    NSLog(@"tableView section = %li",_dataArray.count);
//    
//    return _upDataDict;
//}
-(void)userLogin
{
    AppDelegate *tempDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UserInfoModel *model = tempDelegate.userModel;
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
//    manger.requestSerializer.timeoutInterval = 5;
    NSString *Eurl = @"http://2016.iezhan.com/ezhan/phone/opt/login";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSString stringWithFormat:@"%ld",model.companyid] forKey:@"uname"];
    [params setObject:@"sdw123456" forKey:@"upwd"];
    [manger POST:Eurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject[@"code"]);
        NSDictionary *loginInfoDic = responseObject[@"param"];
        self.tokenStr = loginInfoDic[@"token"];
        self.idStr = loginInfoDic[@"id"];
        
        NSDate *todayDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//        NSString *todayStr = [dateFormatter stringFromDate:todayDate];
        
        NSDate *lastDayDate = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:todayDate];//前一天
        NSString *lastDayStr= [dateFormatter stringFromDate:lastDayDate];
        
        NSDate *last7DayDate = [NSDate dateWithTimeInterval:-24*60*60*7 sinceDate:todayDate];//前一天
        NSString *last7DayStr= [dateFormatter stringFromDate:last7DayDate];
        
        [self requestForData:last7DayStr endTime:lastDayStr];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        AlertView *showView = [[AlertView alloc]initWithTitle:@"网络异常" style:kAlertViewStyleFail showTime:kAlerViewShowTimeOneSecond];
        [showView showInView:self.view];
        [[JSSDWProgressHUD shareProgressHud]hiddenProgressHud];

    }];
    
}
-(void)requestForData:(NSString *)startTime endTime:(NSString *)endTime
{
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    NSString *Eurl = @"http://2016.iezhan.com/ezhan/phone/get/getAllDataMin";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.idStr forKey:@"id"];
    [params setObject:self.tokenStr forKey:@"token"];
    [params setObject:startTime forKey:@"startime"];
    [params setObject:endTime forKey:@"endtime"];
    
    [manger POST:Eurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject[@"code"]);
        
        NSMutableArray *dataArr = [WebData mj_objectArrayWithKeyValuesArray:responseObject[@"param"]];
        self.modelArr = [NSArray arrayWithArray:dataArr];
        
        //解析模型数据
        [self splitModelToDataArr];
        //加载界面
        [[JSSDWProgressHUD shareProgressHud]hiddenProgressHud];
        self.updataTView.frame = CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-64);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        AlertView *showView = [[AlertView alloc]initWithTitle:@"网络异常" style:kAlertViewStyleFail showTime:kAlerViewShowTimeOneSecond];
        [showView showInView:self.view];
        [[JSSDWProgressHUD shareProgressHud]hiddenProgressHud];

    }];
    
    

}
-(void)splitModelToDataArr
{
    for (int i= 0; i<self.modelArr.count; i++) {
        WebData *data = self.modelArr[i];
        [self.titleArr insertObject:data.time atIndex:0];
        NSMutableArray *tempArr = [NSMutableArray array];
        [tempArr addObject:data.PV];
        [tempArr addObject:data.UV];
        [tempArr addObject:data.SP];
        [self.dataArray insertObject:tempArr atIndex:0];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

#endif
