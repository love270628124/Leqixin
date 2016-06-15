//
//  HomeViewController.m
//  乐企信
//
//  Created by 震霄 张 on 16/4/29.
//  Copyright © 2016年 SDW. All rights reserved.
//

#import "HomeViewController.h"
#import "ZXappModel.h"
#import "ZXappView.h"
#import "MineCollectionViewCell.h"
#import "NewConsultViewController.h"
#import "StatisticsViewController.h"
#import "UpdateViewController.h"
#import "ShareViewController.h"
#import "CommentViewController.h"
#import "WebDataViewController.h"
#import "SettingViewController.h"
#import "MineWebViewController.h"
#import "WebData.h"
#import "ConsultModel.h"
#import "ChatViewController.h"
#import "MineInfoViewController.h"
#import "ContactViewController.h"
#import "VisitingCardViewController.h"
#import "ChergeModel.h"
#import "CompanyWebViewController.h"

#import "SingletonWebSocket.h"
#import "UUMessageFrame.h"
#import "UUMessage.h"

#define PartHeight (SCREEN_H - 64-20 * SCREEN_SCALE_H) * 0.2
#define MAXCOL 3
#define PHOTOW  (SCREEN_W - 6)/3
#define PHOTOH  (PartHeight * 3-4)/3

@interface HomeViewController ()<ZXappViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,AlertViewDelegate,UICollectionViewDelegateFlowLayout,changeIconImageDelegate>
@property (nonatomic,weak)UIView *iconView;
@property (nonatomic,weak)UIImageView *iconImageView;
@property (nonatomic,weak)UILabel *nameLabel;
@property (nonatomic,weak)UIView *dataView;
@property (nonatomic,weak)UICollectionView *collectionView;
@property (nonatomic,strong)AppDelegate *tempDelegate;
@property (nonatomic,strong)AlertView *ConsultView;//抢单弹窗
@property (nonatomic, strong) NSString *itemId;

@property (nonatomic,weak)UILabel *todayLabel;
@property (nonatomic,weak)UILabel *todayRecLabel;
@property (nonatomic,weak)UILabel *sevenPvLabel;
@property (nonatomic,weak)UILabel *sevenUvLabel;
@property (nonatomic,weak)UILabel *totalLabel;
@property (nonatomic,weak)UILabel *totalRecLabel;
@property (nonatomic,weak)UILabel *sevenJpLabel;
@property (nonatomic,weak)UILabel *sevenSpLabel;

@property (nonatomic,strong) ChergeModel *chergeModel;

@end

@implementation HomeViewController

-(AppDelegate *)tempDelegate
{
    if (_tempDelegate == nil) {
        _tempDelegate =(AppDelegate *)[UIApplication sharedApplication].delegate;

    }
    return _tempDelegate;
}
-(void)checkVersion
{
    if (self.tempDelegate.newerVersion != nil && self.tempDelegate.versionUpdateUrl != nil) {
        NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
        NSString *currentVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
        NSInteger current = [[currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""]integerValue];
        NSInteger newer = [[self.tempDelegate.newerVersion stringByReplacingOccurrencesOfString:@"." withString:@""]integerValue];
        if (newer > current) {
            NSString *newVersion = [NSString stringWithFormat:@"有新版本v%@可以更新",self.tempDelegate.newerVersion];
            AlertView *updateAlter = [[AlertView alloc]initWithTitle:@"新版本检测" content:newVersion target:self buttonsTitle:@[@"取消",@"更新"]];
            updateAlter.delegate = self;
            [updateAlter showInView:self.view];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.nameLabel.text = self.tempDelegate.userModel.truename;
//    [self userLogin];//获取E站数据
    [self readEdata];
    [self requestConsultData];
    [self checkVersion];
    
    int webSocketState = [[SingletonWebSocket shareWebSocket] webSocketState];
    NSLog(@"webSocketState = %i",webSocketState);
    if (webSocketState != 1) {
        //
        [SingletonWebSocket handCutOffConnectServer];
//        NSString *urlAndId = [NSString stringWithFormat:@"ws://61.155.215.16:8077/websocket/websocket?username=%li",(long)self.tempDelegate.userModel.userid];
        NSString *urlAndId = [NSString stringWithFormat:@"%@%li",webSocketUrl,(long)self.tempDelegate.userModel.userid];
        [SingletonWebSocket connectServerWithUrlStringAndUserId:urlAndId];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    int webSocketState = [[SingletonWebSocket shareWebSocket] webSocketState];
    NSLog(@"webSocketState = %i",webSocketState);
    if (webSocketState != 1) {
        //
        [SingletonWebSocket handCutOffConnectServer];
//        NSString *urlAndId = [NSString stringWithFormat:@"ws://61.155.215.16:8077/websocket/websocket?username=%li",(long)self.tempDelegate.userModel.userid];
        NSString *urlAndId = [NSString stringWithFormat:@"%@%li",webSocketUrl,(long)self.tempDelegate.userModel.userid];
        [SingletonWebSocket connectServerWithUrlStringAndUserId:urlAndId];
    }
}

-(void)readEdata
{
    
    if ([self.tempDelegate.chergeModel.shujuzhongxin isEqualToString:@"false"]) {
        self.sevenJpLabel.text = @"--";
        self.sevenPvLabel.text = @"--";
        self.sevenSpLabel.text = @"--";
        self.sevenUvLabel.text = @"--";
        return;
    }
    
    NSUserDefaults *Edefault = [NSUserDefaults standardUserDefaults];
    NSString *pv = [Edefault valueForKey:@"sevenPV"];
    NSString *uv = [Edefault valueForKey:@"sevenUV"];
    NSString *jp = [Edefault valueForKey:@"sevenJP"];
    NSString *sp = [Edefault valueForKey:@"sevenSP"];
    NSLog(@"pv:%@,uv:%@,jp:%@,sp:%@",pv,uv,jp,sp);
    if (pv != nil) {
        self.sevenPvLabel.text = pv;
    }
    if (uv != nil) {
        self.sevenUvLabel.text = uv;
    }
    if (jp != nil) {
        self.sevenJpLabel.text = jp;
    }
    if (sp != nil) {
        self.sevenSpLabel.text = sp;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    [self setupIconView];

    [self setMidDataView];
    [self setupChoiceBtnView];    
    [self userLogin];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidReceiveMessage:)
                          name:kJPFNetworkDidReceiveMessageNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(serviceError:)
                          name:kJPFServiceErrorNotification
                        object:nil];
    //connect webSocket
//    NSString *urlAndId = [NSString stringWithFormat:@"ws://61.155.215.16:8077/websocket/websocket?username=%li",(long)self.tempDelegate.userModel.userid];
    NSString *urlAndId = [NSString stringWithFormat:@"%@%li",webSocketUrl,(long)self.tempDelegate.userModel.userid];
    [SingletonWebSocket connectServerWithUrlStringAndUserId:urlAndId];
    //receivedChatMessage
    [defaultCenter addObserver:self
                      selector:@selector(receiveWebSocketChatMessage:)
                          name:ReceivedChatMessage object:nil];
    
    //监听网络状态
    [self reachablilitNet];
    
}

- (void)receiveWebSocketChatMessage:(NSNotification *)notification {
    //
//    NSLog(@"%@",[SingletonWebSocket receivedMessageDictionary]);
    NSDictionary *recevieDict = [[NSDictionary alloc] initWithDictionary:[SingletonWebSocket receivedMessageDictionary]];
//    //聊天回复
    NSMutableDictionary *msgDic = [NSMutableDictionary dictionary];
    [msgDic setValue:recevieDict[@"itemid"] forKey:@"itemid"];
    [msgDic setValue:recevieDict[@"msg"] forKey:@"content"];
    [msgDic setObject:recevieDict[@"id"] forKey:@"nameid"];
    
    [self saveChatMessage:recevieDict];
    
    if (!self.tempDelegate.isChatRoomExist ) {
        self.tempDelegate.isChatRoomExist = YES;
        ChatViewController *vistor = [[ChatViewController alloc]init];
        vistor.msgDic = [NSMutableDictionary new];
        [vistor.msgDic setObject:recevieDict[@"itemid"] forKey:@"itemid"];
        [vistor.msgDic setObject:recevieDict[@"id"] forKey:@"nameid"];
        vistor.title = [NSString stringWithFormat:@"%@客户",recevieDict[@"itemid"]];
        
//        [self saveChatMessage:recevieDict];
        
        [self.navigationController pushViewController:vistor animated:YES];
    }else{
        
        if ([recevieDict[@"itemid"] isEqualToString:self.tempDelegate.chatingVistorId]) {
            
//            [self saveChatMessage:recevieDict];
            self.tempDelegate.isReceivedNewMsg = YES;
        }else{
            [self addUnreadMessage:msgDic];
            
            if (![self.tempDelegate.haveNewMsgIdArr containsObject:recevieDict[@"itemid"]]) {
                [self.tempDelegate.haveNewMsgIdArr addObject:recevieDict[@"itemid"]];
                
            }
        }
//        NSLog(@"%@",self.tempDelegate.haveNewMsgIdArr);
    }
    
}

- (void)saveChatMessage:(NSDictionary *)recevieDict {
    //
    NSLog(@"收到聊天消息");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.tempDelegate.chatRoomDataDic = [NSMutableDictionary dictionaryWithDictionary:[defaults objectForKey:@"chatRoomDataDic"] ];
    
    NSMutableArray *dataArr = [NSMutableArray array];
    if (self.tempDelegate.chatRoomDataDic) {
        dataArr = [[self.tempDelegate.chatRoomDataDic valueForKey:recevieDict[@"itemid"]] mutableCopy];
        
    }
    
    if (dataArr == nil) {
        dataArr = [NSMutableArray array];
    }
    
    UUMessage *msg = [[UUMessage alloc]init];
    msg.strName = @"访客";
    msg.from = 1;
    msg.strContent = recevieDict[@"msg"];
    
    NSDictionary *dic = [self dicWithMessageModel:msg];
    [dataArr addObject:dic];
    
    [self.tempDelegate.chatRoomDataDic setValue:dataArr
                                         forKey:recevieDict[@"itemid"] ];
    [defaults setValue:self.tempDelegate.chatRoomDataDic forKey:@"chatRoomDataDic"];
}

-(NSDictionary *)dicWithMessageModel:(UUMessage *)model
{
    return [model mj_keyValuesWithKeys:@[@"strIcon",@"strId",@"strTime",@"strName",@"strContent",@"picture",@"voice",@"strVoiceTime",@"type",@"from",@"showDateLabel"]];
    
}

//未读消息列表没有此聊天对象
- (void)addUnreadMessage:(NSDictionary *)msgDict {
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"UnreadMessageFiel" ofType:@"plist"];
    [self.tempDelegate.receiveUnReadMsgArr addObject:msgDict];
    [self.tempDelegate.receiveUnReadMsgArr writeToFile:path atomically:YES];
//    [defaults setObject:self.tempDelegate.receiveUnReadMsgArr forKey:@"unReadMsgArray"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ReceivedUnReadMessage
                                                        object:nil];
}

- (void)serviceError:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSString *error = [userInfo valueForKey:@"error"];
    NSLog(@"%@", error);
}
- (void)dealloc {
    [self unObserveAllNotifications];
}
- (void)unObserveAllNotifications {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidReceiveMessageNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFServiceErrorNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:ReceivedChatMessage
                           object:nil];
}
-(void)requestConsultData
{
    UserInfoModel *userModel = self.tempDelegate.userModel;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSString stringWithFormat:@"%ld",(long)userModel.companyid] forKey:@"company"];
    [params setObject:[NSString stringWithFormat:@"%ld",(long)userModel.userid] forKey:@"worker"];
    //    [params setObject:[NSString stringWithFormat:@"%ld",self.refreshCount] forKey:@"number"];
    
    NSString *changePswdUrl = [NSString stringWithFormat:@"%@/index.php",rootUrl];
    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
    [muDic setObject:@"Interface" forKey:@"g"];
    [muDic setObject:@"Newask" forKey:@"m"];
    [muDic setObject:@"get_get" forKey:@"a"];
    
    [muDic setObject:[self dictionaryToJson:params] forKey:@"data"];
    [manager GET:changePswdUrl parameters:muDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        //        NSDictionary *dataDic = dic[@"data"];// 汇总数据
        ConsultModel *consultModel = [ConsultModel mj_objectWithKeyValues:dic[@"data"]];
        NSInteger recInt = [consultModel.reception integerValue];
        NSInteger totalInt = [consultModel.total integerValue];
        NSInteger recTodayInt = [consultModel.reception_today integerValue];
        NSInteger totalTodayInt = [consultModel.total_today integerValue];
        consultModel.totalReceptRate = [NSString stringWithFormat:@"%.2f",(double)recInt/totalInt];
        consultModel.todayReceptRate = [NSString stringWithFormat:@"%.2f",(double)recTodayInt/totalTodayInt];
        
        NSInteger rate1 = [consultModel.totalReceptRate doubleValue]*100;
        NSInteger rate2 = [consultModel.todayReceptRate doubleValue]*100;
        self.todayLabel.text = consultModel.total_today;
        self.todayRecLabel.text = [NSString stringWithFormat:@"%ld%%",(long)rate2];
        
        self.totalLabel.text = consultModel.total;
        self.totalRecLabel.text = [NSString stringWithFormat:@"%ld%%",(long)rate1];

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        AlertView *showView = [[AlertView alloc]initWithTitle:@"询盘数据异常" style:kAlertViewStyleFail showTime:kAlerViewShowTimeOneSecond];
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

-(void)userLogin
{
    if ([self.tempDelegate.chergeModel.shujuzhongxin isEqualToString:@"false"]) {
        self.sevenJpLabel.text = @"--";
        self.sevenPvLabel.text = @"--";
        self.sevenSpLabel.text = @"--";
        self.sevenUvLabel.text = @"--";
        return;
    }
    UserInfoModel *model = self.tempDelegate.userModel;
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
            self.tempDelegate.tokenStr = loginInfoDic[@"token"];
            self.tempDelegate.idStr = loginInfoDic[@"id"];
            
            
            NSDate *todayDate = [NSDate date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            
            NSDate *lastDayDate = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:todayDate];//前一天
            NSString *lastDayStr= [dateFormatter stringFromDate:lastDayDate];
            
            NSDate *last7DayDate = [NSDate dateWithTimeInterval:-24*60*60*7 sinceDate:todayDate];//前一天
            NSString *last7DayStr= [dateFormatter stringFromDate:last7DayDate];
            [self requestForDataWithStartTime:last7DayStr endTime:lastDayStr type:@"3"];//请求7天数据
            
        } else if ([responseObject[@"code"] intValue]== 400) {
            
            NSString *error = [NSString stringWithFormat:@"E站%@",responseObject[@"message"]];
            
            AlertView *alter = [[AlertView alloc] initWithTitle:error style:kAlertViewStyleWarn showTime:kAlerViewShowTimeOneSecond];
            [alter showInView:self.view];
//            [[JSSDWProgressHUD shareProgressHud] hiddenProgressHud];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        AlertView *alter = [[AlertView alloc] initWithTitle:@"E站数据异常" style:kAlertViewStyleWarn showTime:kAlerViewShowTimeOneSecond];
        [alter showInView:self.view];
    }];
    
}
-(void)requestForDataWithStartTime:(NSString *)startTime endTime:(NSString *)endTime type:(NSString *)type
{
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    NSString *Eurl = @"http://2016.iezhan.com/ezhan/phone/get/getAllData";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.tempDelegate.idStr forKey:@"id"];
    [params setObject:self.tempDelegate.tokenStr forKey:@"token"];
    [params setObject:startTime forKey:@"startime"];
    [params setObject:endTime forKey:@"endtime"];
    
    [manger POST:Eurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject[@"code"]);
        
        BOOL isReceiveDataSuc = YES;

        WebData *data = [WebData mj_objectWithKeyValues:responseObject[@"param"]];
        
        if (data.PV == nil || [data.PV isEqualToString:@""]) {
            self.sevenPvLabel.text = @"0";
            isReceiveDataSuc = NO;
        }else{
            self.sevenPvLabel.text = data.PV;
        }
        
        if (data.UV == nil || [data.UV isEqualToString:@""]) {
            self.sevenUvLabel.text = @"0";
            isReceiveDataSuc = NO;

        }else{
            self.sevenUvLabel.text = data.UV;
        }
        if (data.SP == nil || [data.SP isEqualToString:@""]) {
            self.sevenSpLabel.text = @"0";
            isReceiveDataSuc = NO;

        }else{
            self.sevenSpLabel.text = data.SP;
        }
        if (data.JP == nil || [data.JP isEqualToString:@""]||[data.JP isEqualToString:@"null"]) {
            self.sevenJpLabel.text = @"0%";
            isReceiveDataSuc = NO;

        }else{
            self.sevenJpLabel.text =[NSString stringWithFormat:@"%@%%",data.JP];
        }
        if (isReceiveDataSuc) {
            NSUserDefaults *sevenDefault =[NSUserDefaults  standardUserDefaults];
            [sevenDefault setObject:data.PV forKey:@"sevenPV"];
            [sevenDefault setObject:data.UV forKey:@"sevenUV"];
            [sevenDefault setObject:[NSString stringWithFormat:@"%@%%",data.JP] forKey:@"sevenJP"];
            [sevenDefault setObject:data.SP forKey:@"sevenSP"];
        }
//        [[JSSDWProgressHUD shareProgressHud] hiddenProgressHud];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        AlertView *alter = [[AlertView alloc] initWithTitle:@"E站数据异常" style:kAlertViewStyleWarn showTime:kAlerViewShowTimeOneSecond];
        [alter showInView:self.view];
//        [[JSSDWProgressHUD shareProgressHud] hiddenProgressHud];

    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setupNav
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"daohaglan_bg"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    self.view.backgroundColor = ZXcolor(242, 242, 245);
    self.title = @"仕脉";
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
}
-(void)setupIconView
{
    CGFloat iconViewHeight = PartHeight * 0.8;
    UIView *iconView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, iconViewHeight)];
    iconView.backgroundColor = [UIColor whiteColor];
    UIImageView *iconImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_icon_photo"]];
    iconImageView.width = 64 * SCREEN_SCALE_W;
    iconImageView.height =iconImageView.width;
    iconImageView.x = 20 * SCREEN_SCALE_W;
    iconImageView.y = (iconViewHeight - iconImageView.width ) / 2;
    iconImageView.layer.cornerRadius = iconImageView.width * 0.5;
    iconImageView.layer.masksToBounds = YES;
    iconImageView.layer.borderWidth = 3.0;
    UIColor *tempColor = ZXcolor(230,230,230);
    iconImageView.layer.borderColor = tempColor.CGColor;

    iconImageView.image = self.tempDelegate.meIconImage;
    self.iconImageView = iconImageView;
    [iconView addSubview:iconImageView];
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.x = CGRectGetMaxX(iconImageView.frame)+20 * SCREEN_SCALE_W;
    nameLabel.width  =150 * SCREEN_SCALE_W;
    nameLabel.height = 20 * SCREEN_SCALE_H;
    nameLabel.y = iconImageView.y + 4;
    nameLabel.text = self.tempDelegate.userModel.truename;
    nameLabel.font = [UIFont systemFontOfSize:18];
    nameLabel.adjustsFontSizeToFitWidth = YES;
    self.nameLabel = nameLabel;
    [iconView addSubview:nameLabel];
    
    UILabel *partLabel = [[UILabel alloc]init];
    partLabel.x = nameLabel.x;
    partLabel.y = CGRectGetMaxY(nameLabel.frame);
    partLabel.width = nameLabel.width;
    partLabel.height = 40 * SCREEN_SCALE_H;
    partLabel.adjustsFontSizeToFitWidth = YES;
    partLabel.font = [UIFont systemFontOfSize:15];
//    partLabel.backgroundColor = [UIColor blueColor];
    partLabel.text = [NSString stringWithFormat:@"%@-%@",self.tempDelegate.userModel.department,self.tempDelegate.userModel.officer];
    partLabel.textColor = [UIColor grayColor];
    [iconView addSubview:partLabel];
    
    UIImageView *nextView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"data_icon_enter"]];
    nextView.width = 8*SCREEN_SCALE_W;
    nextView.height = 16*SCREEN_SCALE_H;
    nextView.x = SCREEN_W -20*SCREEN_SCALE_W-nextView.width;
    nextView.y = iconImageView.centerY - nextView.height*0.5;
    [iconView addSubview:nextView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, iconViewHeight - 1, SCREEN_W, 1)];
    lineView.backgroundColor = ZXcolor(239, 239, 239);
    [iconView addSubview:lineView];
    
    self.iconView = iconView;
    [self.view addSubview:iconView];
    
    
    UITapGestureRecognizer* singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SingleTap:)];
    //点击的次数
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    
    //给self.view添加一个手势监测；
    [iconView addGestureRecognizer:singleRecognizer];
    
}
-(void)SingleTap:(UITapGestureRecognizer*)recognizer
{
    [self.navigationController pushViewController:[[MineInfoViewController alloc]init] animated:YES];
}

- (void)setMidDataView {
        
    CGFloat dataViewHeight = PartHeight * 1.2;//整个view的高度
    CGFloat dataWidth = (SCREEN_W) / 3.0;//每条数据的宽度
    CGFloat dataHeight =(dataViewHeight) / 4.0;//每条数据的高度
    UIView *dataView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.iconView.frame)+10*SCREEN_SCALE_H, SCREEN_W, dataViewHeight)];
    dataView.backgroundColor = ZXcolor(255, 255, 255);
//    NSArray *topLabelNameArr = @[@"今日询盘数",@"7天拜访量",@"总询盘数"];
//    NSArray *bottomLabelNameArr = @[@"今日接待率",@"7天访客数",@"总接待率"];
    NSArray *topLabelNameArr = @[@"总询盘数",@"7天访问量",@"7天平均访时(s)"];
    NSArray *bottomLabelNameArr = @[@"总接待率",@"7天访客数",@"7天跳出率"];
    
    for (int i = 0; i < 3; i++) {
        
        UILabel *topLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(i * dataWidth, 5, dataWidth, dataHeight)];
        topLabel1.text = @"0";
        topLabel1.tag = 101 + i;
        topLabel1.textAlignment = NSTextAlignmentCenter;
        topLabel1.backgroundColor = [UIColor whiteColor];
        topLabel1.font = [UIFont boldSystemFontOfSize:18];
        topLabel1.adjustsFontSizeToFitWidth = YES;
        topLabel1.backgroundColor = [UIColor clearColor];
        [dataView addSubview:topLabel1];
        
        UILabel *topLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(i * dataWidth, CGRectGetMaxY(topLabel1.frame) - 10, dataWidth, dataHeight)];
        topLabel2.text = topLabelNameArr[i];
        topLabel2.textColor = ZXcolor(51, 51, 51);
        topLabel2.textAlignment = NSTextAlignmentCenter;
        topLabel2.backgroundColor = [UIColor whiteColor];
        topLabel2.font = [UIFont systemFontOfSize:12];
        topLabel2.adjustsFontSizeToFitWidth = YES;
        topLabel2.backgroundColor = [UIColor clearColor];
        [dataView addSubview:topLabel2];
        
        UIButton *topShowBtn = [[UIButton alloc]init];
        topShowBtn.tag = HomeTopDataBtnTag+i;
        topShowBtn.frame = CGRectMake(topLabel1.x, topLabel1.y, topLabel1.width, topLabel1.height+topLabel2.height);
        [dataView addSubview:topShowBtn];
        [topShowBtn addTarget:self action:@selector(showBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UILabel *bottomLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(i * dataWidth, CGRectGetMaxY(topLabel2.frame) + 11, dataWidth, dataHeight)];
        bottomLabel1.text = @"0";
        bottomLabel1.tag = 104 + i;
        bottomLabel1.textAlignment = NSTextAlignmentCenter;
        bottomLabel1.backgroundColor = [UIColor whiteColor];
        bottomLabel1.font = [UIFont boldSystemFontOfSize:18];
        bottomLabel1.adjustsFontSizeToFitWidth = YES;
        bottomLabel1.backgroundColor = [UIColor clearColor];
        [dataView addSubview:bottomLabel1];
        
        UILabel *bottomLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(i * dataWidth, CGRectGetMaxY(bottomLabel1.frame) - 10, dataWidth, dataHeight)];
        bottomLabel2.text = bottomLabelNameArr[i];
        bottomLabel2.textColor = ZXcolor(51, 51, 51);
        bottomLabel2.textAlignment = NSTextAlignmentCenter;
        bottomLabel2.backgroundColor = [UIColor whiteColor];
        bottomLabel2.font = [UIFont systemFontOfSize:12];
        bottomLabel2.adjustsFontSizeToFitWidth = YES;
        bottomLabel2.backgroundColor = [UIColor clearColor];
        [dataView addSubview:bottomLabel2];
        
        UIButton *downShowBtn = [[UIButton alloc]init];
        downShowBtn.frame = CGRectMake(bottomLabel1.x, bottomLabel1.y, bottomLabel1.width, bottomLabel1.height+bottomLabel2.height);
        downShowBtn.tag = HomeDowmDataBtnTag+i;
        [dataView addSubview:downShowBtn];
        [downShowBtn addTarget:self action:@selector(showBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i != 0) {
            UIImageView *lineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(i * dataWidth, CGRectGetHeight(dataView.frame) / 10, 1, CGRectGetHeight(dataView.frame) * 4 / 5)];
            lineImgView.image = [UIImage imageNamed:@"bg_shuxian"];
            lineImgView.contentMode = UIViewContentModeScaleToFill;
            [dataView addSubview:lineImgView];
        }
    }
    
    UIImageView *lineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(dataView.frame) / 2, CGRectGetWidth(dataView.frame), 1)];
    lineImgView.image = [UIImage imageNamed:@"data_huixian"];
    lineImgView.contentMode = UIViewContentModeScaleToFill;
    [dataView addSubview:lineImgView];

//    self.todayLabel = (UILabel *)[dataView viewWithTag:101];
//    self.sevenPvLabel = (UILabel *)[dataView viewWithTag:102];
//    self.totalLabel = (UILabel *)[dataView viewWithTag:103];
//    self.todayRecLabel = (UILabel *)[dataView viewWithTag:104];
//    self.sevenUvLabel = (UILabel *)[dataView viewWithTag:105];
//    self.totalRecLabel = (UILabel *)[dataView viewWithTag:106];
    
    self.totalLabel = (UILabel *)[dataView viewWithTag:101];
    self.sevenPvLabel = (UILabel *)[dataView viewWithTag:102];
    self.sevenSpLabel = (UILabel *)[dataView viewWithTag:103];
    self.totalRecLabel = (UILabel *)[dataView viewWithTag:104];
    self.sevenUvLabel = (UILabel *)[dataView viewWithTag:105];
    self.sevenJpLabel = (UILabel *)[dataView viewWithTag:106];
    
    self.dataView = dataView;
    [self.view addSubview:dataView];
    
}

-(void)showBtnClick:(UIButton *)sender
{
    NSLog(@"click");
    NSInteger intTag = sender.tag;
    NSString *dataStr = @"";
    int type = 0;
    switch (intTag) {
        case HomeTopDataBtnTag:
            dataStr = @"总询盘数是指总的网站访客询盘的数量";
            type = 0;
            break;
        case HomeTopDataBtnTag+1:
            dataStr = @"7天访问量是指过去7天内网站所有的页面浏览量";
            type = 1;
            break;
        case HomeTopDataBtnTag+2:
            dataStr = @"7天平均访时是指过去7天内所有访客浏览网站的平均时间";
            type = 2;
            break;
        case HomeDowmDataBtnTag:
            dataStr = @"总接待率是指总的网站访客被客服接待的百分比";
            type = 3;
            break;
        case HomeDowmDataBtnTag+1:
            dataStr = @"7天访客数是指过去7天内浏览网站的访客数量";
            type = 4;
            break;
        case HomeDowmDataBtnTag+2:
            dataStr = @"7天跳出率是指过去7天内只浏览了一页即离开网站的用户占所有访问用户的百分比";
            type = 5;
            break;
        default:
            break;
    }
    
    [self dataPopAlertView:dataStr type:type];

}

-(void)setupChoiceBtnView
{
    UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing = 1.0f;
    flowLayout.minimumInteritemSpacing = 1.0f;
    UICollectionView *collectionView  =[[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.dataView.frame)+10*SCREEN_SCALE_H, SCREEN_W, PartHeight*3) collectionViewLayout:flowLayout];
    collectionView.backgroundColor = ZXcolor(225, 225, 225);
    [self.view addSubview:collectionView];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    self.collectionView = collectionView;
    [collectionView registerClass:[MineCollectionViewCell class] forCellWithReuseIdentifier:@"appCell"];
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 12;

}
-(MineCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MineCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"appCell" forIndexPath:indexPath];

    cell.backgroundColor = [UIColor whiteColor];
    if (indexPath.item == 0) {
        cell.cellImage.image = [UIImage imageNamed:@"home_myweb"];
        cell.nameLabel.text = @"我的网站";
    }else if (indexPath.item == 1){
        cell.cellImage.image = [UIImage imageNamed:@"home_qiangdan"];
        cell.nameLabel.text = @"询盘抢单";
    }else if (indexPath.item== 2){
        cell.cellImage.image = [UIImage imageNamed:@"home_wodexunpan"];
        cell.nameLabel.text = @"我的询盘";
    }else if (indexPath.row == 3){
        cell.cellImage.image = [UIImage imageNamed:@"home_fangkezixun"];
        cell.nameLabel.text = @"访客咨询";
    }else if (indexPath.item == 4){
        cell.cellImage.image = [UIImage imageNamed:@"home_shujugengxin"];
        cell.nameLabel.text = @"数据更新";
    }else if (indexPath.item == 5){
        cell.cellImage.image = [UIImage imageNamed:@"home_share"];
        cell.nameLabel.text = @"协同分享";
    }else if (indexPath.item == 6){
        cell.cellImage.image = [UIImage imageNamed:@"home_shujuzhongxin"];
        cell.nameLabel.text = @"数据中心";
    }else if (indexPath.item == 7){
        cell.cellImage.image = [UIImage imageNamed:@"home_hudong"];
        cell.nameLabel.text = @"全员互动";
    }else if (indexPath.item == 8){
        cell.cellImage.image = [UIImage imageNamed:@"home_tongxunlu"];
        cell.nameLabel.text = @"通讯录";
    }else if (indexPath.item == 9){
        cell.cellImage.image = [UIImage imageNamed:@"home_mingpian"];
        cell.nameLabel.text = @"我的名片";
    }else if (indexPath.item == 10) {
        cell.cellImage.image = [UIImage imageNamed:@"home_shezhi"];
        cell.nameLabel.text = @"设置";
    }
    
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (SCREEN_W - 3.0) / 4.0;
    CGFloat height = (PartHeight * 3 - 2.0) / 3.0;
    
    return CGSizeMake(width,height);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MineCollectionViewCell * cell = (MineCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    cell.backgroundColor = [UIColor whiteColor];
    cell.circleImage.hidden = YES;
    ChergeModel *chergeModel = self.tempDelegate.chergeModel;
    
    if (indexPath.row == 0) {//我的网站
        [self.navigationController pushViewController:[[CompanyWebViewController alloc] init] animated:YES];
//        [self.navigationController pushViewController:[[MineWebViewController alloc]init] animated:YES];
    }else if (indexPath.row == 1){//抢单询盘
        NewConsultViewController *newConsult = [[NewConsultViewController alloc]init];
        [self.navigationController pushViewController:newConsult animated:YES];
        
    }else if (indexPath.row == 2){//我的询盘
        StatisticsViewController *vc = [[StatisticsViewController alloc]init];
        vc.chergeString = chergeModel.gerenxunpan;
        vc.isShowMineFirst = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 3){//访客咨询
        [self.navigationController pushViewController:[[StatisticsViewController alloc]init] animated:YES];
    }else if (indexPath.row == 4){//数据更新
        UpdateViewController *update = [[UpdateViewController alloc]init];
        update.chergeString = chergeModel.shujutixin;
        if ([update.chergeString isEqualToString:@"true"]) {
            [self.navigationController pushViewController:update animated:YES];
        } else {
            [self popAlertView:@"home_tan1"];
        }
        
    }else if (indexPath.row == 5){//协同分享
        [self.navigationController pushViewController:[[ShareViewController alloc]init] animated:YES];
    }else if (indexPath.row == 6){//数据中心
        WebDataViewController *webData = [[WebDataViewController alloc]init];
        webData.chergeString = chergeModel.shujuzhongxin;
        if ([webData.chergeString isEqualToString:@"true"]) {
            [self.navigationController pushViewController:webData animated:YES];
        } else {
            [self popAlertView:@"home_tan1"];
        }
//        [self.navigationController pushViewController:webData animated:YES];
    }else if (indexPath.row == 7){//全员互动
        [self.navigationController pushViewController:[[CommentViewController alloc]init] animated:YES];
    }else if (indexPath.row == 8){//通讯录
        ContactViewController *contact = [[ContactViewController alloc]init];
        contact.crmChergeString = chergeModel.crm;
        [self.navigationController pushViewController:contact animated:YES];
    } else if (indexPath.row == 9){//我的名片
        VisitingCardViewController *visitingCard = [[VisitingCardViewController alloc] init];
        visitingCard.chergeString = chergeModel.mingpian;
        [self.navigationController pushViewController:visitingCard animated:YES];
    }else if (indexPath.row == 10){//设置
        [self.navigationController pushViewController:[[SettingViewController alloc]init] animated:YES];
    }
    
    
}
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (void)networkDidReceiveMessage:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    NSString *title = [userInfo valueForKey:@"title"];
    NSString *content = [userInfo valueForKey:@"content"];
    
    NSIndexPath *path;
    //新评论
    if ([title isEqualToString:@"-1"]) {
        path = [NSIndexPath indexPathForItem:7 inSection:0];
        
    }else if([title isEqualToString:@"-2"]){
        path = [NSIndexPath indexPathForItem:5 inSection:0];
        
    }else if([title isEqualToString:@"-3"]){
        
        path = [NSIndexPath indexPathForItem:1 inSection:0];
        
        if (self.tempDelegate.isGrabOut == YES) {
            
            if (self.ConsultView) {
                [[self.ConsultView superview]removeFromSuperview];
                self.ConsultView = nil;
            }
            NSDictionary *dic = [self dictionaryWithJsonString:[userInfo valueForKey:@"content"]];;
            NSString *country =[dic valueForKey:@"c"];
            NSString *ip =[dic valueForKey:@"ip"];
            self.itemId = [dic valueForKey:@"i"];
            NSString *locationStr = [NSString stringWithFormat:@"%@,IP:%@",country,ip];
            self.ConsultView = [[AlertView alloc]initWithObject:locationStr target:self];
            
            if ([self.navigationController.topViewController isKindOfClass:[ChatViewController class]]) {
                ChatViewController *vc = (ChatViewController *)self.navigationController.topViewController;
                [vc regisFirstBecome];
            }
            [self.navigationController.topViewController.view endEditing:YES];
           [self.ConsultView showInView:self.navigationController.topViewController.view];
            
        }
        
    }else if ([title integerValue]>0){
        //聊天回复
        NSMutableDictionary *msgDic = [NSMutableDictionary dictionary];
        [msgDic setValue:title forKey:@"vistorId"];
        [msgDic setValue:content forKey:@"content"];
        
        if (!self.tempDelegate.isChatRoomExist) {
            ChatViewController *vistor = [[ChatViewController alloc]init];
            vistor.msgDic = msgDic;
            vistor.title = [NSString stringWithFormat:@"%@客户",msgDic[@"vistorId"]];
            [self.navigationController pushViewController:vistor animated:YES];
            
        }else{
            if ([title isEqualToString:self.tempDelegate.chatingVistorId]) {
                //                [self.tempDelegate.receiveUnReadMsgArr addObject:msgDic];
                self.tempDelegate.isReceivedNewMsg = YES;
            }else{
                if (![self.tempDelegate.haveNewMsgIdArr containsObject:title]) {
                    [self.tempDelegate.haveNewMsgIdArr addObject:title];
                }
            }
            NSLog(@"%@",self.tempDelegate.haveNewMsgIdArr);
        }
    }
    
    MineCollectionViewCell * cell = (MineCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:path];
    cell.circleImage.hidden = NO;
    
}
//json字符串转字典
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
- (void)alertView:(AlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex withString:(NSString *)str
{
    NSLog(@"抢单");
    if (buttonIndex == 2) {//抢单
        NSIndexPath *path = [NSIndexPath indexPathForItem:1 inSection:0];
        MineCollectionViewCell * cell = (MineCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:path];
        cell.circleImage.hidden = YES;
        [self requestGrabCaseWithVistorId:self.itemId];
    }else if(buttonIndex == 1){
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:self.tempDelegate.versionUpdateUrl]];
    }else{
    
    }

}

-(void)requestGrabCaseWithVistorId:(NSString *)visitorid {
    //
    UserInfoModel *userModel = self.tempDelegate.userModel;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:visitorid forKey:@"visitorid"];
    [params setObject:[NSString stringWithFormat:@"%ld",(long)userModel.userid] forKey:@"itemid"];
    
    NSString *changePswdUrl = [NSString stringWithFormat:@"%@/App.php/Xunpan/single",rootUrl];
    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
    [muDic setObject:[self dictionaryToJson:params] forKey:@"data"];
    
    [manager GET:changePswdUrl parameters:muDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"return"]isEqualToString:@"1"]) {
            ChatViewController *vistor = [[ChatViewController alloc]init];
            vistor.msgDic = [NSMutableDictionary dictionary];
            [vistor.msgDic setObject:self.itemId forKey:@"itemid"];
            [vistor.msgDic setObject:dic[@"nameid"] forKey:@"nameid"];
            
            vistor.title = [NSString stringWithFormat:@"%@客户",self.itemId];

            if(self.tempDelegate.isChatRoomExist){
                [self.navigationController popViewControllerAnimated:NO];
            }
            [self.navigationController pushViewController:vistor animated:YES];
            
        }else{
            AlertView *alterView = [[AlertView alloc]initWithTitle:@"抢单失败" style:kAlertViewStyleWarn showTime:kAlerViewShowTimeOneSecond];
            [alterView showInView:self.navigationController.topViewController.view];
        }

        NSLog(@"%@",dic[@"return"]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        AlertView *alterView = [[AlertView alloc]initWithTitle:@"抢单失败" style:kAlertViewStyleWarn showTime:kAlerViewShowTimeOneSecond];
        [alterView showInView:self.navigationController.topViewController.view];
        
    }];

}

-(void)changeIconImage
{
    self.iconImageView.image = self.tempDelegate.meIconImage;
}

- (void)popAlertView:(NSString *)popImageStr{
    
    //预警提醒按钮事件
    //AUTOLAYTOU(246),AUTOLAYTOU(295),date_tanchuang_bg
    //    NSLog(@"弹出提示窗口");
    //
    UIView *popView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_W , SCREEN_H)];
    popView.backgroundColor = [UIColor clearColor];
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:popView.frame];
    bgImgView.image = [UIImage imageNamed:@"data_heidi"];
    [popView addSubview:bgImgView];
    [[UIApplication sharedApplication].keyWindow addSubview:popView];
//    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
//    singleTap.numberOfTapsRequired = 1;
//    [popView addGestureRecognizer:singleTap];
    //
    UIImageView *popImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 246, 167)];
    popImgView.image = [UIImage imageNamed:popImageStr];//@"home_tan1"
    popImgView.contentMode = UIViewContentModeScaleToFill;
    popImgView.center = CGPointMake(CGRectGetMidX(popView.frame), CGRectGetMidY(popView.frame));
    [popView addSubview:popImgView];
    //
    UIButton *knowBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(popImgView.frame), 246, 40)];
    [knowBtn setTitle:@"我知道了" forState:UIControlStateNormal];
    UIColor *titleColor = ZXcolor(0, 170, 238);
    [knowBtn setTitleColor:titleColor forState:UIControlStateNormal];
    knowBtn.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    [knowBtn setBackgroundImage:[UIImage imageNamed:@"home_tan2"] forState:UIControlStateNormal];
    knowBtn.center = CGPointMake(CGRectGetMidX(popView.frame), CGRectGetMidY(knowBtn.frame));
    [knowBtn addTarget:self action:@selector(knowButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [popView addSubview:knowBtn];
}

//弹窗消失
- (void)knowButtonPressed:(UIButton *)aButton {
    //    NSLog(@"click I konw button");
    [aButton.superview removeFromSuperview];
    
}
-(void)tapClick:(UITapGestureRecognizer *)tap
{
    [tap.view removeFromSuperview];
}
- (void)dataPopAlertView:(NSString *)str type:(int)type{
    
    UIView *popView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_W , SCREEN_H)];
    popView.backgroundColor = [UIColor clearColor];
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:popView.frame];
    bgImgView.image = [UIImage imageNamed:@"data_heidi"];
    [popView addSubview:bgImgView];
    [[UIApplication sharedApplication].keyWindow addSubview:popView];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    singleTap.numberOfTapsRequired = 1;
    [popView addGestureRecognizer:singleTap];
    
    UIImageView *popImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 270*SCREEN_SCALE_W, 118*SCREEN_SCALE_H)];
    popImgView.image = [UIImage imageNamed:@"home_tc_landi"];//@"home_tan1"
    popImgView.contentMode = UIViewContentModeScaleToFill;
    popImgView.center = CGPointMake(CGRectGetMidX(popView.frame), CGRectGetMidY(popView.frame));
    popImgView.y = 209*SCREEN_SCALE_H;
    [popView addSubview:popImgView];

    UIImageView *dataView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_tc_baidi"]];
    dataView.x =popImgView.x;
    dataView.y = CGRectGetMaxY(popImgView.frame);
    dataView.width = popImgView.width;
    
    UILabel *dataLabel = [[UILabel alloc]init];

    dataLabel.x = 20*SCREEN_SCALE_W;
    dataLabel.y = 17*SCREEN_SCALE_H;
    dataLabel.width = dataView.width - 40*SCREEN_SCALE_W;
    dataLabel.font = [UIFont systemFontOfSize:15];

    dataLabel.numberOfLines = 0;
    dataLabel.backgroundColor = [UIColor whiteColor];
    dataLabel.textAlignment = NSTextAlignmentCenter;
    dataLabel.textColor = ZXcolor(68, 68, 68);
    [dataView addSubview:dataLabel];
    
    switch (type) {
        case 0:
            dataLabel.attributedText = [self changeTextColor:str length:4];
            break;
        case 1:
            dataLabel.attributedText = [self changeTextColor:str length:5];
            break;
        case 2:
            dataLabel.attributedText = [self changeTextColor:str length:6];
            break;
        case 3:
            dataLabel.attributedText = [self changeTextColor:str length:4];
            break;
        case 4:
            dataLabel.attributedText = [self changeTextColor:str length:5];
            break;
        case 5:
            dataLabel.attributedText = [self changeTextColor:str length:5];
            break;
            
        default:
            break;
    }
    
    dataLabel.height = [dataLabel.attributedText boundingRectWithSize:CGSizeMake(dataLabel.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size.height;
    dataView.height =37*SCREEN_SCALE_H+dataLabel.height;

    [popView addSubview:dataView];
    

}

-(NSMutableAttributedString *)changeTextColor:(NSString *)str length:(NSInteger)num
{
    NSMutableAttributedString *tempstr = [[NSMutableAttributedString alloc]initWithString:str];
    //设置：在0-3个单位长度内的内容显示成红色
    UIColor *tempColor = ZXcolor(0, 170, 238);
    [tempstr addAttribute:NSForegroundColorAttributeName value:tempColor range:NSMakeRange(0, num)];
    [tempstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, num)];
    [tempstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(num, str.length-num)];
    return tempstr;
}

#pragma mark - 监听网络状态

- (void)reachablilitNet {
    //
    AFNetworkReachabilityManager *manger = [AFNetworkReachabilityManager sharedManager];
    
    //2.监听改变
    [manger setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        /*
         AFNetworkReachabilityStatusUnknown          = -1,
         AFNetworkReachabilityStatusNotReachable     = 0,
         AFNetworkReachabilityStatusReachableViaWWAN = 1,
         AFNetworkReachabilityStatusReachableViaWiFi = 2,
         */
        [SingletonWebSocket handCutOffConnectServer];
//        NSString *urlAndId = [NSString stringWithFormat:@"ws://61.155.215.16:8077/websocket/websocket?username=%li",(long)self.tempDelegate.userModel.userid];
        NSString *urlAndId = [NSString stringWithFormat:@"%@%li",webSocketUrl,(long)self.tempDelegate.userModel.userid];
        
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                
                [SingletonWebSocket connectServerWithUrlStringAndUserId:urlAndId];
                NSLog(@"3G|4G");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                
                [SingletonWebSocket connectServerWithUrlStringAndUserId:urlAndId];
                NSLog(@"WiFi");
                break;
            default:
                break;
        }
    }];
}

@end
