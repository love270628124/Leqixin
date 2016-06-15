//
//  WebDataViewController.m
//  乐企信
//
//  Created by 震霄 张 on 16/3/28.
//  Copyright © 2016年 SDW. All rights reserved.
//

#import "WebDataViewController.h"
#import "WJItemsControlView.h"
#import "UUChart.h"
#import "WebData.h"
#import "WebDetialData.h"
#import "AppDelegate.h"

#define downViewHeight 60

typedef enum {
    WebDataTypePV  = 0,
    WebDataTypeUV,
    WebDataTypeSP,
    WebDataTypeTransform,
} WebDataType;

typedef enum {
    DayTypeToday  = 0,
    DayTypeLastDay,
    DayTypeLast7Day,
    DayTypeLast30Day,
} DayType;


typedef enum {
    DataTypePV  = 0,
    DataTypeUV,
    DataTypeSP,
    //DataTypeCHG,//转化率
} DataType;


@interface WebDataViewController ()<UIScrollViewDelegate,UUChartDataSource,AlertViewDelegate>
@property (nonatomic,strong)WJItemsControlView *itemControlView;
@property (nonatomic,weak)UIScrollView *choiceScrollView;
@property (nonatomic,weak)UIView *excelView;//表格图
@property (nonatomic,weak)UUChart *chartView;
@property (nonatomic,strong)NSMutableArray *excelArr;//表格数组

@property (nonatomic,weak)UILabel *checkNumLabel;//访问量label
@property (nonatomic,weak)UILabel *vistorNumLabel;//访客数label
@property (nonatomic,weak)UILabel *vistorTimeLabel;//平均访问时间
@property (nonatomic,weak)UILabel *changeNumLabel;//转化次数

@property (nonatomic,strong)NSString *tokenStr;//登录E站获取的token
@property (nonatomic,strong)NSString *idStr;//登录E站获取的id
//@property (nonatomic,strong)WebData *data;//单个数据
@property (nonatomic,strong)NSMutableDictionary *dataDic;//多个总数据存储子一个字典中
@property (nonatomic,strong)NSMutableArray *detialDataArr;

@property (nonatomic,strong)NSMutableArray *pvTodayHourArr;//访问量今天小时分布数据
@property (nonatomic,strong)NSMutableArray *pvLastDayHourArr;//访问量今天小时分布数据
@property (nonatomic,strong)NSMutableArray *pvLast7DayArr;//访客量过去7天的按天分布数据
@property (nonatomic,strong)NSMutableArray *pvLast30DayArr;//访客量过去30天的按天分布数据

@property (nonatomic,strong)NSMutableArray *uvTodayHourArr;//访客数今天小时分布数据
@property (nonatomic,strong)NSMutableArray *uvLastDayHourArr;//访客数今天小时分布数据
@property (nonatomic,strong)NSMutableArray *uvLast7DayArr;//访客数过去7天的按天分布数据
@property (nonatomic,strong)NSMutableArray *uvLast30DayArr;//访客数过去30天的按天分布数据

@property (nonatomic,strong)NSMutableArray *spTodayHourArr;//
@property (nonatomic,strong)NSMutableArray *spLastDayHourArr;//
@property (nonatomic,strong)NSMutableArray *spLast7DayArr;//过去7天的按天分布数据
@property (nonatomic,strong)NSMutableArray *spLast30DayArr;//过去30天的按天分布数据
@property (nonatomic,assign)BOOL AllDataReady;
@property (nonatomic,assign)BOOL DetialDataReady;

@property (nonatomic,weak)UIView *downView;
@property (nonatomic,assign)DataType datatype;

@property (nonatomic,strong)NSArray *todayHourXvalueArr;
@property (nonatomic,strong)NSArray *yesterdayHourXvalueArr;
@property (nonatomic,strong)NSArray *weekDayXvalueArr;
@property (nonatomic,strong)NSArray *monDayXvalueArr;


@property (nonatomic,assign)NSInteger index;
@property (nonatomic,weak)UIScrollView *scrollView;



@end

@implementation WebDataViewController

-(NSMutableArray *)spTodayHourArr
{
    if (_spTodayHourArr == nil) {
        _spTodayHourArr = [NSMutableArray array];
    }
    return _spTodayHourArr;
}
-(NSMutableArray *)spLastDayHourArr
{
    if (_spLastDayHourArr == nil) {
        _spLastDayHourArr = [NSMutableArray array];
    }
    return _spLastDayHourArr;
}
-(NSMutableArray *)spLast30DayArr
{
    if (_spLast30DayArr == nil) {
        _spLast30DayArr = [NSMutableArray array];
    }
    return _spLast30DayArr;
}
-(NSMutableArray *)spLast7DayArr
{
    if (_spLast7DayArr == nil) {
        _spLast7DayArr = [NSMutableArray array];
    }
    return _spLast7DayArr;
}

-(NSMutableArray *)uvLast30DayArr
{
    if (_uvLast30DayArr == nil) {
        _uvLast30DayArr = [NSMutableArray array];
    }
    return _uvLast30DayArr;
}
-(NSMutableArray *)uvLast7DayArr
{
    if (_uvLast7DayArr == nil) {
        _uvLast7DayArr = [NSMutableArray array];
    }
    return _uvLast7DayArr;
}
-(NSMutableArray *)uvLastDayHourArr
{
    if (_uvLastDayHourArr == nil) {
        _uvLastDayHourArr = [NSMutableArray array];
    }
    return _uvLastDayHourArr;
}
-(NSMutableArray *)uvTodayHourArrl
{
    if (_uvTodayHourArr == nil) {
        _uvTodayHourArr = [NSMutableArray array];
    }
    return _uvTodayHourArr;
}


-(NSMutableArray *)pvLast30DayArr
{
    if (_pvLast30DayArr == nil) {
        _pvLast30DayArr = [NSMutableArray array];
    }
    return _pvLast30DayArr;
}
-(NSMutableArray *)pvLast7DayArr
{
    if (_pvLast7DayArr == nil) {
        _pvLast7DayArr = [NSMutableArray array];
    }
    return _pvLast7DayArr;
}
-(NSMutableArray *)pvLastDayHourArr
{
    if (_pvLastDayHourArr == nil) {
        _pvLastDayHourArr = [NSMutableArray array];
    }
    return _pvLastDayHourArr;
}
-(NSMutableArray *)pvTodayHourArr
{
    if (_pvTodayHourArr == nil) {
        _pvTodayHourArr = [NSMutableArray array];
    }
    return _pvTodayHourArr;
}


-(NSMutableArray *)detialDataArr
{
    if (_detialDataArr == nil) {
        _detialDataArr = [NSMutableArray array];
    }
    return _detialDataArr;
}
-(NSMutableDictionary *)dataDic
{
    if (_dataDic == nil) {
        _dataDic = [NSMutableDictionary dictionary];
    }
    return _dataDic;
}
-(NSMutableArray *)excelArr
{
    if (_excelArr == nil) {
        _excelArr = [NSMutableArray array];
    }
    return _excelArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    //初始默认pv
    self.datatype = DataTypePV;
    self.todayHourXvalueArr = @[@"1",@"4",@"8",@"12",@"16",@"20",@"24"];
    self.yesterdayHourXvalueArr = @[@"1",@"4",@"8",@"12",@"16",@"20",@"24"];
    self.weekDayXvalueArr = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7"];
    self.monDayXvalueArr =  @[@"1",@"6",@"11",@"16",@"21",@"26",@"30"];
    
//    if ([self.chergeString isEqualToString:@"true"]) {
         [[JSSDWProgressHUD shareProgressHud] showWithSuperView:self.view];
        [self userLogin];//用户登录E站
//    }
  
//    [self requestData];
    
    self.index = 0;

    
}

-(void)requestData
{
    
    NSDate *todayDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *todayStr = [dateFormatter stringFromDate:todayDate];
    
    NSDate *lastDayDate = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:todayDate];//前一天
    NSString *lastDayStr= [dateFormatter stringFromDate:lastDayDate];
    
    NSDate *last7DayDate = [NSDate dateWithTimeInterval:-24*60*60*7 sinceDate:todayDate];//前一天
    NSString *last7DayStr= [dateFormatter stringFromDate:last7DayDate];
    
    NSDate *last30DayDate = [NSDate dateWithTimeInterval:-24*60*60*30 sinceDate:todayDate];//前一天
    NSString *last30DayStr= [dateFormatter stringFromDate:last30DayDate];
    [self requestForDataWithStartTime:todayStr endTime:todayStr type:@"1"];//请求今天数据
    [self requestForDataWithStartTime:lastDayStr endTime:lastDayStr type:@"2"];//请求昨天数据
    [self requestForDataWithStartTime:last7DayStr endTime:lastDayStr type:@"3"];//请求7天数据
    [self requestForDataWithStartTime:last30DayStr endTime:lastDayStr type:@"4"];//请求30天数据
    [self requestDetialDataQuick];
}
-(void)requestForDataWithStartTime:(NSString *)startTime endTime:(NSString *)endTime type:(NSString *)type
{

    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    NSString *Eurl = @"http://2016.iezhan.com/ezhan/phone/get/getAllData";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.idStr forKey:@"id"];
    [params setObject:self.tokenStr forKey:@"token"];
    [params setObject:startTime forKey:@"startime"];
    [params setObject:endTime forKey:@"endtime"];

    [manger POST:Eurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject[@"code"]);
        WebData *data = [WebData mj_objectWithKeyValues:responseObject[@"param"]];
//        self.data = data;
        [self.dataDic setObject:data forKey:type];
        NSLog(@"DATA:%@",self.dataDic);
        if ([[self.dataDic allKeys]count]==4) {
            self.AllDataReady = YES;
        }
        
        if (self.AllDataReady && self.DetialDataReady) {
            
            [self setupShowView];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}
-(void)requestDetialDataQuick
{
    AppDelegate *tempDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    if (tempDelegate.idStr == nil || tempDelegate.tokenStr == nil) {
//        AlertView *showView = [[AlertView alloc]initWithTitle:@"E站数据异常" style:kAlertViewStyleWarn showTime:kAlerViewShowTimeOneSecond];
//        showView.delegate = self;
//        [showView showInView:self.view];
////        [NSThread sleepForTimeInterval:1.0];
//        return;
//    }
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    NSString *Eurl = @"http://2016.iezhan.com/ezhan/phone/get/getAllDataDescMin";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.idStr forKey:@"id"];
    [params setObject:self.tokenStr forKey:@"token"];
    
    [manger POST:Eurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject[@"code"]);

        self.pvLast30DayArr = [WebDetialData mj_objectArrayWithKeyValuesArray:[responseObject[@"param"] valueForKey:@"mon_pv"]];
        self.pvTodayHourArr =[WebDetialData mj_objectArrayWithKeyValuesArray:[responseObject[@"param"] valueForKey:@"today_pv"]];
        self.pvLastDayHourArr = [WebDetialData mj_objectArrayWithKeyValuesArray:[responseObject[@"param"] valueForKey:@"yestoday_pv"]];
        self.pvLast7DayArr = [WebDetialData mj_objectArrayWithKeyValuesArray:[responseObject[@"param"] valueForKey:@"week_pv"]];
        self.uvTodayHourArr = [WebDetialData mj_objectArrayWithKeyValuesArray:[responseObject[@"param"] valueForKey:@"today_uv"]];
        self.uvLastDayHourArr =[WebDetialData mj_objectArrayWithKeyValuesArray:[responseObject[@"param"] valueForKey:@"yestoday_uv"]];
        self.uvLast7DayArr = [WebDetialData mj_objectArrayWithKeyValuesArray:[responseObject[@"param"] valueForKey:@"week_uv"]];
        self.uvLast30DayArr = [WebDetialData mj_objectArrayWithKeyValuesArray:[responseObject[@"param"] valueForKey:@"mon_uv"]];
        self.spLast7DayArr = [WebDetialData mj_objectArrayWithKeyValuesArray:[responseObject[@"param"] valueForKey:@"week_sp"]];
        self.spLast30DayArr = [WebDetialData mj_objectArrayWithKeyValuesArray:[responseObject[@"param"] valueForKey:@"mon_sp"]];
        self.spTodayHourArr =[WebDetialData mj_objectArrayWithKeyValuesArray:[responseObject[@"param"] valueForKey:@"today_sp"]];
        self.spLastDayHourArr = [WebDetialData mj_objectArrayWithKeyValuesArray:[responseObject[@"param"] valueForKey:@"yestoday_sp"]];
        
        //把首页要显示的数据保存到appdelegate中
        tempDelegate.pvLast7DayArr = [self.pvLast7DayArr copy];
        tempDelegate.uvLast7DayArr = [self.uvLast7DayArr copy];
        tempDelegate.spLast7DayArr = [self.spLast7DayArr copy];
        
        self.DetialDataReady = YES;
        
        if (self.AllDataReady && self.DetialDataReady) {
            [[JSSDWProgressHUD shareProgressHud] hiddenProgressHud];
            
            [self setupShowView];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

//获取今天小时分布图(访问量，访客数)
-(NSMutableArray *)dataArrFromDetialDataWithType:(WebDataType)dataType
{
    NSMutableArray *temp = [NSMutableArray array];
    for (int i = 0; i<self.detialDataArr.count; i++) {
        WebDetialData *data = self.detialDataArr[i];
        if (dataType == WebDataTypePV) {
        [temp addObject:data.pv];
        }else if (dataType == WebDataTypeUV){
            [temp addObject:data.uv];
        }
    }
    return temp;
}

-(void)userLogin
{
    AppDelegate *tempDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UserInfoModel *model = tempDelegate.userModel;
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    NSString *Eurl = @"http://2016.iezhan.com/ezhan/phone/opt/login";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSString stringWithFormat:@"%ld",(long)model.companyid] forKey:@"uname"];
    [params setObject:@"sdw123456" forKey:@"upwd"];
    [manger POST:Eurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject[@"code"]);
 
        
        
        if ([responseObject[@"code"] intValue] == 200) {
            
            NSDictionary *loginInfoDic = responseObject[@"param"];
            self.tokenStr = loginInfoDic[@"token"];
            self.idStr = loginInfoDic[@"id"];
            [self requestData];

            
        } else if ([responseObject[@"code"] intValue]== 400) {
            
            AlertView *alter = [[AlertView alloc] initWithTitle:responseObject[@"message"] style:kAlertViewStyleWarn showTime:kAlerViewShowTimeOneSecond];
            [alter showInView:self.view];
            [[JSSDWProgressHUD shareProgressHud] hiddenProgressHud];
        }

        

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        AlertView *showView = [[AlertView alloc]initWithTitle:@"E站数据异常" style:kAlertViewStyleWarn showTime:kAlerViewShowTimeOneSecond];
        [showView showInView:self.view];
        [[JSSDWProgressHUD shareProgressHud] hiddenProgressHud];

    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//设置导航界面
-(void)setupNav
{
    self.view.backgroundColor = [UIColor whiteColor];
//    self.view.backgroundColor =[UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1.0];
//    
//    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 64)];
//    bgView.backgroundColor =[UIColor colorWithRed:10/255.0 green:212/255.0 blue:134/255.0 alpha:1.0];
//    [self.view addSubview:bgView];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"bt_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClick:)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.title = @"数据中心";
    
}
-(void)backBtnClick:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
//加载主体页面
-(void)setupShowView
{
    NSArray *array = @[@"今天",@"昨天",@"7天",@"30天"];
    
    NSArray *choiceArr = @[@"访问量",@"访客数",@"平均访时"];
    
//    NSArray *dataDic = @[@{@"type":@"访问量",@"value":@"63"},
//                         @{@"type":@"访客数",@"value":@"12"},
//                         @{@"type":@"平均访时",@"value":@"15秒"},
//                         @{@"type":@"转化次数",@"value":@"5"}
//                         ];
    CGFloat choiceHeight = 44;
    CGFloat dataWidth = (SCREEN_W-2) / choiceArr.count;
    CGFloat dataHeight = 80;
//    CGFloat labelHeight = 40;
//    CGFloat labelWidth = dataWidth;
    //3页内容的scrollView
    UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_W,SCREEN_H-64-downViewHeight)];
    scroll.delegate = self;
    scroll.pagingEnabled = YES;
    scroll.contentSize = CGSizeMake(SCREEN_W*array.count, 100);
    self.choiceScrollView = scroll;
    scroll.backgroundColor = ZXcolor(239, 239, 239);
    [self.view addSubview:scroll];
    scroll.bounces = NO;//禁止滑动弹性
    self.scrollView = scroll;
    for (int p = 0; p<array.count; p++) {
        NSString *key = [NSString stringWithFormat:@"%d",p+1];
        WebData *dataModel = [self.dataDic valueForKey:key];

        //数据
        UIView *dataView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_W * p, choiceHeight, SCREEN_W, dataHeight)];
        for (int i = 0; i<choiceArr.count; i++) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((dataWidth+1) * i, 0, dataWidth, dataHeight * SCREEN_SCALE_H)];
            label.adjustsFontSizeToFitWidth = YES;
            label.textAlignment = NSTextAlignmentCenter;
            label.numberOfLines = 0;
            label.backgroundColor = [UIColor whiteColor];
//            label.text = [NSString stringWithFormat:@"%@\n\n%@",dataDic[i][@"type"],dataDic[i][@"value"]];

            if (i==0) {
                label.text = [NSString stringWithFormat:@"%@\n\n%@",choiceArr[i],dataModel.PV];
            }else if(i==1){
                label.text = [NSString stringWithFormat:@"%@\n\n%@",choiceArr[i],dataModel.UV];
            }else if (i==2){
                label.text = [NSString stringWithFormat:@"%@\n\n%@秒",choiceArr[i],dataModel.SP];

            }else{
            //TO do计算转化率
                NSLog(@"数据计算error");
//                label.text = [NSString stringWithFormat:@"%@\n\n待计算",choiceArr[i]];

            }
            [dataView addSubview:label];
        }
        
        [self.choiceScrollView addSubview:dataView];

        //表格图
        UIView *excelView = [[UIView alloc]init];
        excelView.x = SCREEN_W * p;
        excelView.width = SCREEN_W;
        excelView.height = self.choiceScrollView.height - CGRectGetMaxY(dataView.frame)-10;
        excelView.y = CGRectGetMaxY(dataView.frame)+10*SCREEN_SCALE_H;
        excelView.backgroundColor = [UIColor whiteColor];
        
        UUChart *chartView = [[UUChart alloc]initWithFrame:CGRectMake(SCREEN_W * 0.05, excelView.height*0.1, SCREEN_W*0.9, excelView.height*0.8)
                                                dataSource:self
                                                     style:UUChartStyleLine];
        chartView.tag = execlTag+p;
        [self.excelArr addObject:chartView];

        self.chartView = chartView;
        [chartView showInView:excelView];
//
        [self.choiceScrollView addSubview:excelView];
        
    
    }
    
    //底部按键
        CGFloat btnWidth = SCREEN_W / choiceArr.count;
        UIView *downView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_H - downViewHeight-64, SCREEN_W, downViewHeight)];
        for (int i = 0; i<choiceArr.count; i++) {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(btnWidth * i, 0, btnWidth, downViewHeight)];
            [btn setTitle:choiceArr[i] forState:UIControlStateNormal];
//            [btn setBackgroundColor:[UIColor colorWithRed:26/255.0 green:165/255.0 blue:239/255.0 alpha:1.0]];
            [btn setBackgroundImage:[UIImage imageNamed:@"btn_fk_mormal"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"btn_fk_click"] forState:UIControlStateSelected];
            btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
            btn.tag = dataBtnTag+i;
            [btn addTarget:self action:@selector(choiceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [downView addSubview:btn];

        }
    UIButton *selectBtn = nil;
    if (self.datatype == DataTypePV) {
//        [downView.subviews[0] setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
        selectBtn = downView.subviews[0];
        
    }else if(self.datatype == DataTypeUV){
        selectBtn = downView.subviews[1];
//        [downView.subviews[1] setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];

    }else if(self.datatype == DataTypeSP){
        selectBtn = downView.subviews[2];
//        [downView.subviews[2] setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
        
    }
    if (selectBtn != nil) {
        selectBtn.selected = YES;
    }
//    else if(self.datatype == DataTypeCHG){
//        [downView.subviews[3] setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
//        
//    }
        [self.view addSubview:downView];
    self.downView = downView;

    
    //头部控制的segMent
    WJItemsConfig *config = [[WJItemsConfig alloc]init];
    config.itemWidth = SCREEN_W/4.0;
    
    _itemControlView = [[WJItemsControlView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, choiceHeight)];
    _itemControlView.tapAnimation = YES;
    _itemControlView.config = config;
    _itemControlView.titleArray = array;
    
    __weak typeof (scroll)weakScrollView = scroll;
    [_itemControlView setTapItemWithIndex:^(NSInteger index,BOOL animation){
        
        _index = index;
        
        [weakScrollView scrollRectToVisible:CGRectMake(index*weakScrollView.frame.size.width, 0.0, weakScrollView.frame.size.width,weakScrollView.frame.size.height) animated:animation];
        
    }];
    
    [_itemControlView setTapItemWithIndex:^(NSInteger index,BOOL animation){
        
        _index = index;
        
        [weakScrollView scrollRectToVisible:CGRectMake(index*weakScrollView.frame.size.width, 0.0, weakScrollView.frame.size.width,weakScrollView.frame.size.height) animated:animation];
        
    }];
    [self.view addSubview:_itemControlView];
    
    
}

-(void)choiceBtnClick:(UIButton *)btn
{
    NSLog(@"点击");
    NSArray *btns=[self.downView subviews];
    
    for (int i = 0; i<btns.count; i++) {
        if ([btns[i] isKindOfClass:[UIButton class]]) {
            [btns[i] setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
    switch (btn.tag) {
        case dataBtnTag:
            self.datatype = DataTypePV;
            break;
        case dataBtnTag+1:
            self.datatype = DataTypeUV;
            break;
        case  dataBtnTag+2:
            self.datatype = DataTypeSP;
            break;
//        case dataBtnTag +3:
//            self.datatype = DataTypeCHG;
//            break;
        default:
            break;
    }
    [self setupShowView];

}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float offset = scrollView.contentOffset.x;
    offset = offset/CGRectGetWidth(scrollView.frame);
    [_itemControlView moveToIndex:offset];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float offset = scrollView.contentOffset.x;
    offset = offset/CGRectGetWidth(scrollView.frame);
    [_itemControlView endMoveToIndex:offset];
}
//- (void)openLeftVCAction
//{
//    
//    [self.sideMenuViewController presentLeftViewController];
//}
#pragma mark UUChartDataSource
- (NSArray *)getXTitles:(DayType)daytype
{
    NSArray *xTitles = [NSMutableArray array];
    if (daytype == DayTypeToday) {
        xTitles = self.todayHourXvalueArr;
    }else if(daytype == DayTypeLastDay){
        xTitles = self.yesterdayHourXvalueArr;
    }else if(daytype == DayTypeLast7Day){
        xTitles = self.weekDayXvalueArr;
    }else if(daytype == DayTypeLast30Day){
        xTitles = self.monDayXvalueArr;
    }else{
        NSLog(@"daytype error");
    }
    return xTitles;
}

#pragma mark - @required
//横坐标标题数组
- (NSArray *)chartConfigAxisXLabel:(UUChart *)chart
{
    NSInteger exTag = chart.tag;
    if (exTag ==execlTag ) {
        return [self getXTitles:DayTypeToday];
    }else if (exTag == execlTag+1){
        return [self getXTitles:DayTypeLastDay];
    }else if(exTag == execlTag+2){
        return [self getXTitles:DayTypeLast7Day];
    }else if (exTag == execlTag+3){
        return [self getXTitles:DayTypeLast30Day];
    }else{
        NSLog(@"横坐标获取失败");
    }
    return nil;
}
//数值多重数组
- (NSArray *)chartConfigAxisYValue:(UUChart *)chart
{
    //访问量-今天
    NSInteger exTag = chart.tag;
    NSMutableArray *MuDataArr = [NSMutableArray array];
    switch (exTag) {
        case execlTag:
            if (self.datatype == DataTypePV) {
                [MuDataArr addObject:[self getNumFromArr:[self cutOutWithArr:self.pvTodayHourArr target:@"pv"] withXarr:self.todayHourXvalueArr]];
            }else if (self.datatype == DataTypeUV){
                [MuDataArr addObject:[self getNumFromArr:[self cutOutWithArr:self.uvTodayHourArr target:@"uv"] withXarr:self.todayHourXvalueArr]];
            }else if(self.datatype == DataTypeSP){
                [MuDataArr addObject:[self getNumFromArr:[self cutOutWithArr:self.spTodayHourArr target:@"sp"] withXarr:self.todayHourXvalueArr]];
            }
//            else if(self.datatype == DataTypeCHG){
//                //TO DO
//                
//            }
            else{
                NSLog(@"dataType error");
            }            break;
            break;
        case execlTag+1:
            if (self.datatype == DataTypePV) {
                [MuDataArr addObject:[self getNumFromArr:[self cutOutWithArr:self.pvLastDayHourArr target:@"pv"] withXarr:self.yesterdayHourXvalueArr]];
            }else if (self.datatype == DataTypeUV){
                [MuDataArr addObject:[self getNumFromArr:[self cutOutWithArr:self.uvLastDayHourArr target:@"uv"] withXarr:self.yesterdayHourXvalueArr]];
            }else if(self.datatype == DataTypeSP){
                [MuDataArr addObject:[self getNumFromArr:[self cutOutWithArr:self.spLastDayHourArr target:@"sp"] withXarr:self.yesterdayHourXvalueArr]];
            }
//            else if(self.datatype == DataTypeCHG){
//                //TO DO
//                
//            }
            else{
                NSLog(@"dataType error");
            }            break;
            break;
        case execlTag+2:
            if (self.datatype == DataTypePV) {
                [MuDataArr addObject:[self getNumFromArr:[self cutOutWithArr:self.pvLast7DayArr target:@"pv"] withXarr:self.weekDayXvalueArr]];
            }else if (self.datatype == DataTypeUV){
                [MuDataArr addObject:[self getNumFromArr:[self cutOutWithArr:self.uvLast7DayArr target:@"uv"] withXarr:self.weekDayXvalueArr]];
            }else if(self.datatype == DataTypeSP){
                [MuDataArr addObject:[self getNumFromArr:[self cutOutWithArr:self.spLast7DayArr target:@"sp"] withXarr:self.weekDayXvalueArr]];
            }
//            else if(self.datatype == DataTypeCHG){
//                //TO DO
//                
//            }
            else{
                NSLog(@"dataType error");
            }            break;
        case execlTag+3:
            if (self.datatype == DataTypePV) {
                [MuDataArr addObject:[self getNumFromArr:[self cutOutWithArr:self.pvLast30DayArr target:@"pv"] withXarr:self.monDayXvalueArr]];
            }else if (self.datatype == DataTypeUV){
                [MuDataArr addObject:[self getNumFromArr:[self cutOutWithArr:self.uvLast30DayArr target:@"uv"] withXarr:self.monDayXvalueArr]];
            }else if(self.datatype == DataTypeSP){
                [MuDataArr addObject:[self getNumFromArr:[self cutOutWithArr:self.spLast30DayArr target:@"sp"] withXarr:self.monDayXvalueArr]];
            }
//            else if(self.datatype == DataTypeCHG){
//                //TO DO
//                
//            }
            else{
                NSLog(@"dataType error");
            }
            break;
        default:
            break;
    }
    
    return MuDataArr;
}
//从模型数组中抽出数据组成数组
-(NSMutableArray *)cutOutWithArr:(NSMutableArray *)arrayModel target:(NSString *)target
{
    NSMutableArray* tempArr = [NSMutableArray array];
    for (int i = 0; i<arrayModel.count; i++) {
        WebDetialData *dataModel = arrayModel[i];
        if ([target isEqualToString:@"pv"]) {
            [tempArr addObject:dataModel.pv];
        }else if ([target isEqualToString:@"uv"]){
            [tempArr addObject:dataModel.uv];
        }else if([target isEqualToString:@"sp"]){
            [tempArr addObject:dataModel.sp];
        }else if([target isEqualToString:@"chg"]){
        //todo
        }else{
            NSLog(@"target is error");
        }
    }
    return tempArr;
}

//根据下标数组来获取值的数组
-(NSMutableArray *)getNumFromArr:(NSArray *)fromArr withXarr:(NSArray *)Xarr
{
    if (fromArr.count==0) {
        return [NSMutableArray array];
    }
    
    NSMutableArray *arrMut = [NSMutableArray arrayWithArray:fromArr];
    for (int j = 0; j<fromArr.count; j++) {
        NSString *tempStr = fromArr[j];
        NSRange foundObj = [tempStr rangeOfString:@","];
        if (foundObj.length>0) {
          NSString *resultStr = [tempStr stringByReplacingCharactersInRange:foundObj withString:@""];
            [arrMut replaceObjectAtIndex:j withObject:resultStr];
        }
    }
    
    NSMutableArray *outArr = [NSMutableArray array];
    for (int i = 0; i<Xarr.count; i++) {
        NSInteger index = [Xarr[i] integerValue] - 1;//转化下标要剪掉1
        [outArr addObject:arrMut[index]];
    }
    return outArr;
}
//获取数组中的最大值
-(NSInteger)getMaxValueFromArr:(NSArray *)strArray
{
//    NSMutableArray *arrMut = [NSMutableArray arrayWithArray:strArray];
    if (strArray.count == 0) {
        return 0;
    }
//    for (int j = 0; j<strArray.count; j++) {
//        NSString *tempStr = strArray[j];
//        NSRange foundObj = [tempStr rangeOfString:@","];
//        if (foundObj.length>0) {
//            
//        [arrMut replaceObjectAtIndex:j withObject:[tempStr stringByReplacingCharactersInRange:foundObj withString:@""]];
//        }
//    }
//    
//    
    NSInteger max = [strArray[0] integerValue];
    for (int i = 0; i<strArray.count; i++) {
        if ([strArray[i] integerValue]>max) {
            max = [strArray[i] integerValue];
        }
    }
    return max;
}
#pragma mark - @optional
//颜色数组
- (NSArray *)chartConfigColors:(UUChart *)chart
{
    return @[[UUColor green],[UUColor red],[UUColor brown]];
}
//显示数值范围
- (CGRange)chartRange:(UUChart *)chart
{
//    if (chart.tag<execlTag+2) {
//        return CGRangeMake(1000, 0);
//    }else{
//        return CGRangeMake(5000, 0);
//
//    }
    NSInteger exTag = chart.tag;
    NSInteger maxH = 0;
    NSArray *tempArr = [NSArray array];
    switch (exTag) {
        case execlTag:
            if (self.datatype == DataTypePV) {
               tempArr = [self getNumFromArr:[self cutOutWithArr:self.pvTodayHourArr target:@"pv"] withXarr:self.todayHourXvalueArr];

            }else if (self.datatype == DataTypeUV){
               tempArr =  [self getNumFromArr:[self cutOutWithArr:self.uvTodayHourArr target:@"uv"] withXarr:self.todayHourXvalueArr];

            }else if(self.datatype == DataTypeSP){
               tempArr =  [self getNumFromArr:[self cutOutWithArr:self.spTodayHourArr target:@"sp"] withXarr:self.todayHourXvalueArr];
            }else{
                NSLog(@"dataType error");
            }
            break;
        case execlTag+1:
            if (self.datatype == DataTypePV) {
             tempArr = [self getNumFromArr:[self cutOutWithArr:self.pvLastDayHourArr target:@"pv"] withXarr:self.yesterdayHourXvalueArr];
 
            }else if (self.datatype == DataTypeUV){
               tempArr = [self getNumFromArr:[self cutOutWithArr:self.uvLastDayHourArr target:@"uv"] withXarr:self.yesterdayHourXvalueArr];
            }else if(self.datatype == DataTypeSP){
                tempArr =  [self getNumFromArr:[self cutOutWithArr:self.spLastDayHourArr target:@"sp"] withXarr:self.yesterdayHourXvalueArr];
            }else{
                NSLog(@"dataType error");
            }
            break;
        case execlTag+2:
            if (self.datatype == DataTypePV) {
                tempArr = [self getNumFromArr:[self cutOutWithArr:self.pvLast7DayArr target:@"pv"] withXarr:self.weekDayXvalueArr];
            }else if (self.datatype == DataTypeUV){
                tempArr = [self getNumFromArr:[self cutOutWithArr:self.uvLast7DayArr target:@"uv"] withXarr:self.weekDayXvalueArr];
            }else if(self.datatype == DataTypeSP){
                tempArr = [self getNumFromArr:[self cutOutWithArr:self.spLast7DayArr target:@"sp"] withXarr:self.weekDayXvalueArr];
            }
//            else if(self.datatype == DataTypeCHG){
//                //TO DO
//                
//            }
            else{
                NSLog(@"dataType error");
            }            break;
        case execlTag+3:
            if (self.datatype == DataTypePV) {
                tempArr = [self getNumFromArr:[self cutOutWithArr:self.pvLast30DayArr target:@"pv"] withXarr:self.monDayXvalueArr];
            }else if (self.datatype == DataTypeUV){
                tempArr = [self getNumFromArr:[self cutOutWithArr:self.uvLast30DayArr target:@"uv"] withXarr:self.monDayXvalueArr];
            }else if(self.datatype == DataTypeSP){
                tempArr = [self getNumFromArr:[self cutOutWithArr:self.spLast30DayArr target:@"sp"] withXarr:self.monDayXvalueArr];
            }
//            else if(self.datatype == DataTypeCHG){
//                //TO DO
//                
//            }
            else{
                NSLog(@"dataType error");
            }
            break;
        default:
            break;
    }
    NSInteger max = [self getMaxValueFromArr:tempArr];
    maxH = [self getMaxH:max];
    return CGRangeMake(maxH, 0);
}
-(NSInteger)getMaxH:(NSInteger)max
{
    NSInteger i = 1;
    while (max>i*100) {
        i++;
    }
    NSInteger maxH = i*100+100;
    return maxH;
}
#pragma mark 折线图专享功能

//标记数值区域
//- (CGRange)chartHighlightRangeInLine:(UUChart *)chart
//{
////    if (chart.tag<execlTag+2) {
////        return CGRangeMake(250, 750);
////    }else{
////        return CGRangeMake(1250, 3750);
////    }
//}

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

- (void)alertViewtimeFinishedToDo {
    [self.navigationController popViewControllerAnimated:YES];

}

@end
