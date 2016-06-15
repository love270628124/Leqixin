//
//  CmInfoViewController.m
//  乐企信
//
//  Created by 震霄 张 on 16/4/5.
//  Copyright © 2016年 SDW. All rights reserved.
//

#import "CmInfoViewController.h"
#import "CommentModel.h"
#import "AnswerCmCell.h"
#import "UsrAnswerModel.h"
#import "UsrAnswerFrame.h"
#import "CmInputBar.h"

#define lineHeight 10*SCREEN_SCALE_H
@interface CmInfoViewController ()<CommentInputBarDelegate>
//@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,weak)UILabel *bodyLabel;//回复的label
@property (nonatomic,weak)CmInputBar *inputBar;
//@property (nonatomic,strong)NSMutableArray *cmInfoArr;
@end

@implementation CmInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ZXcolor(239, 239, 244);

    [self setupNav];
    [self setupCmInfoView];
    
   self.automaticallyAdjustsScrollViewInsets = NO;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGes:)];
//    [self.view addGestureRecognizer:tap];
}

//- (void)tapGes:(UITapGestureRecognizer *)aTapGes {
//    [self.view endEditing:YES];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)setupCmInfoView
{

    if ([self.cmframe.model.reply isEqualToString:@""]) {
        CmInputBar *inputBar = [[CmInputBar alloc]init];
        inputBar.x = 0;
        inputBar.height = 52 * SCREEN_SCALE_H;
        inputBar.y = SCREEN_H - inputBar.height-64;
        inputBar.width = SCREEN_W;
        self.inputBar = inputBar;
        self.inputBar.delegate = self;
        
        [self.view addSubview:inputBar];
        self.inputBar.hidden = NO;
    }else{
        self.inputBar.hidden = YES;
    }
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, self.cmframe.cellHeight)];
    headView.backgroundColor = [UIColor whiteColor];
    UIImageView *iconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_moren-tx"]];
    iconView.frame = self.cmframe.iconViewFrame;
    [headView addSubview:iconView];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:self.cmframe.nameLabelFrame];
    nameLabel.text = self.cmframe.model.customername;
    nameLabel.font = [UIFont systemFontOfSize:16];
    [headView addSubview:nameLabel];
    
    //    UILabel *locationLable = [[UILabel alloc]initWithFrame:self.cmframe.locationLabelFrame];
    //    locationLable.font = [UIFont systemFontOfSize:14];
    //    locationLable.text = self.cmframe.model.locationStr;
    //    [headView addSubview:locationLable];
    
    UIImageView *statusView = [[UIImageView alloc]initWithFrame:self.cmframe.statusViewFrame];
    statusView.image = [UIImage imageNamed:@"bg_tongguo"];
    [headView addSubview:statusView];
    
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:self.cmframe.commentLabelFrame];
    contentLabel.numberOfLines = 0;
    contentLabel.font = [UIFont systemFontOfSize:15];
    contentLabel.text = self.cmframe.model.content;
    [headView addSubview:contentLabel];
    
    
    UILabel *bodyLabel = [[UILabel alloc]init];
    bodyLabel.x = contentLabel.x;
    bodyLabel.y = CGRectGetMaxY(contentLabel.frame)+14 * SCREEN_SCALE_H;
    bodyLabel.numberOfLines = 0;
    if (![self.cmframe.model.reply isEqualToString:@""]) {
        NSString *replyStr = [NSString stringWithFormat:@"客服回复:%@",self.cmframe.model.reply];
        bodyLabel.size = [replyStr sizeWithFont:[UIFont systemFontOfSize:14] maxW:(SCREEN_W - 26 * SCREEN_SCALE_W)];
        bodyLabel.text = replyStr;
        headView.height+=bodyLabel.size.height;
    }
    bodyLabel.font = [UIFont systemFontOfSize:14];
    bodyLabel.backgroundColor = ZXcolor(231, 229, 229);
    [headView addSubview:bodyLabel];
    self.bodyLabel = bodyLabel;
    
    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.frame = self.cmframe.timeLabelFrame;
//    timeLabel.x = nameLabel.x;
//    timeLabel.y = CGRectGetMaxY(nameLabel.frame)+5*SCREEN_SCALE_H;
//    timeLabel.width = 120*SCREEN_SCALE_W;
//    timeLabel.height = ;
    timeLabel.font = [UIFont systemFontOfSize:12];
    timeLabel.textColor = ZXcolor(153, 153, 153);
    //timeLabel.text = [NSString stringWithFormat:@"%ld",self.cmframe.model.addtime];
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.cmframe.model.addtime];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    timeLabel.text = [self transformTime:self.cmframe.model.addtime];
    [headView addSubview:timeLabel];
    
    [self.view addSubview:headView];
    
}


-(NSString *)transformTime:(NSInteger)addtime
{
    
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:addtime];
    //    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    
    
    //    NSDate *createDate = [dateFormatter dateFromString:date];
    //
    //    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    //    return [fmt stringFromDate:createDate];
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents *cmps = [calendar components:unit fromDate:createDate toDate:now options:0];
    NSDateComponents *dateCmps = [calendar components:unit fromDate:createDate];
    NSDateComponents *nowCmps = [calendar components:unit fromDate:now];
    if (nowCmps.year == dateCmps.year) {//今年
        if (nowCmps.day==(dateCmps.day + 1)) {//昨天
            fmt.dateFormat = @"昨天 HH:mm";
            return [fmt stringFromDate:createDate];
        }else if (nowCmps.day == dateCmps.day){//今天
            if (cmps.hour >= 1) {
                return [NSString stringWithFormat:@"%ld小时前",(long)cmps.hour];
            }else if(cmps.minute >1){
                return [NSString stringWithFormat:@"%ld分钟前",(long)cmps.minute];
            }else{
                return @"刚刚";
            }
        }else{//今年的其他日子
            fmt.dateFormat =@"MM-dd HH:mm";
            return [fmt stringFromDate:createDate];
        }
    }else{//非今年
        fmt.dateFormat = @"yyyy-MM-dd HH:mm";
        return [fmt stringFromDate:createDate];
    }
}


-(void)setupNav
{
    //导航栏透明处理
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"bt_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClick:)];    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    self.title = @"评论管理";
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
}
-(void)backBtnClick:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma  mark tableViewDataSource/Delegate
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//        return self.cmInfoArr.count;
//}
//-(AnswerCmCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//     AnswerCmCell *cell = [AnswerCmCell cellWithTableView:tableView indexpath:indexPath];
//    cell.ansFrame = self.cmInfoArr[indexPath.row];
//    return cell;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return self.cmframe.cellHeight+lineHeight;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UsrAnswerFrame *ansFrame = self.cmInfoArr[indexPath.row];
//    return ansFrame.ansCellHeight;
//}
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *headView = [[UIView alloc]init];
//    headView.frame = CGRectMake(0, 0, SCREEN_W, self.cmframe.cellHeight);
//    headView.backgroundColor = [UIColor whiteColor];
//    headView.frame = CGRectMake(0, 0, SCREEN_W, self.cmframe.cellHeight);
//    UIImageView *iconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_moren-tx"]];
//    iconView.frame = self.cmframe.iconViewFrame;
//    [headView addSubview:iconView];
//    
//    UILabel *nameLabel = [[UILabel alloc]initWithFrame:self.cmframe.nameLabelFrame];
//    nameLabel.text = self.cmframe.model.customername;
//    nameLabel.font = [UIFont systemFontOfSize:16];
//    [headView addSubview:nameLabel];
//    
////    UILabel *locationLable = [[UILabel alloc]initWithFrame:self.cmframe.locationLabelFrame];
////    locationLable.font = [UIFont systemFontOfSize:14];
////    locationLable.text = self.cmframe.model.locationStr;
////    [headView addSubview:locationLable];
//    
//    UIImageView *statusView = [[UIImageView alloc]initWithFrame:self.cmframe.statusViewFrame];
//    statusView.image = [UIImage imageNamed:@"bg_tongguo"];
//    [headView addSubview:statusView];
//    
//    UILabel *contentLabel = [[UILabel alloc]initWithFrame:self.cmframe.commentLabelFrame];
//    contentLabel.numberOfLines = 0;
//    contentLabel.font = [UIFont systemFontOfSize:15];
//    contentLabel.text = self.cmframe.model.content;
//    [headView addSubview:contentLabel];
//    
//    
//    UILabel *bodyLabel = [[UILabel alloc]init];
//    bodyLabel.x = contentLabel.x;
//    bodyLabel.y = CGRectGetMaxY(contentLabel.frame)+14 * SCREEN_SCALE_H;
//    bodyLabel.size = [self.cmframe.model.reply sizeWithFont:[UIFont systemFontOfSize:14] maxW:(SCREEN_W - 26 * SCREEN_SCALE_W)];
//    bodyLabel.font = [UIFont systemFontOfSize:14];
//    bodyLabel.text = self.cmframe.model.reply;
//    bodyLabel.backgroundColor = ZXcolor(231, 229, 229);
//    [headView addSubview:bodyLabel];
//    
//    UILabel *timeLabel = [[UILabel alloc]init];
//    timeLabel.x = bodyLabel.x;
//    timeLabel.y = CGRectGetMaxY(bodyLabel.frame)+14*SCREEN_SCALE_H;
//    timeLabel.width = statusView.x - timeLabel.x - 10 * SCREEN_SCALE_W;
//    timeLabel.height = 40 * SCREEN_SCALE_H;
//    timeLabel.font = [UIFont systemFontOfSize:12];
//    timeLabel.textColor = ZXcolor(153, 153, 153);
//    //timeLabel.text = [NSString stringWithFormat:@"%ld",self.cmframe.model.addtime];
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.cmframe.model.addtime];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    timeLabel.text = [dateFormatter stringFromDate:date];
//    [headView addSubview:timeLabel];
//    
//    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, self.cmframe.cellHeight+lineHeight)];
//    [bgView addSubview:headView];
//    return bgView;
//}
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//   // [self.inputBar.mInputTextView resignFirstResponder];
//    if (self.inputBar.isOut) {
//        self.inputBar.ansModel = nil;
//        [self.view endEditing:YES];
//    }else{
//        UsrAnswerFrame *ansF = self.cmInfoArr[indexPath.row];
//    
//        UsrAnswerModel *newAnswerModel = [[UsrAnswerModel alloc]init];
//        newAnswerModel.toWhoStr = ansF.model.nameStr;
//        
//        self.inputBar.ansModel = newAnswerModel;
//    }
//    
//
//
//}
//
//#pragma mark CommentInputBarDelegate
//-(void)changeHightWithInputBar:(CGFloat)inputBarY
//{
//    self.tableView.height = inputBarY-self.tableView.y;
//    
//#warning row固定了
//    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    
//    [self.tableView scrollToRowAtIndexPath:indexPath
//     
//                          atScrollPosition:UITableViewScrollPositionBottom animated:NO];
//    
//    
//}
-(void)sendComment:(NSString *)replyStr
{
//    UsrAnswerFrame *newF = [[UsrAnswerFrame alloc]init];
//    newF.model = ansModel;
//    [self.cmInfoArr insertObject:newF atIndex:0];
//    [self.tableView reloadData];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSString stringWithFormat:@"%ld",(long)self.cmframe.model.itemid] forKey:@"itemid"];
    [params setObject:replyStr forKey:@"content"];
    
    NSString *url = [NSString stringWithFormat:@"%@/index.php",rootUrl];
    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
    [muDic setObject:@"Interface" forKey:@"g"];
    [muDic setObject:@"Newpinlun" forKey:@"m"];
    [muDic setObject:@"set_discuss" forKey:@"a"];
    
    [muDic setObject:[self dictionaryToJson:params] forKey:@"data"];
    
    
    [manager GET:url parameters:muDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSInteger result = [dic[@"result"]integerValue];
        if (result == 1) {//评论提交成功
            self.cmframe.model.reply = replyStr;
            [self setupCmInfoView];
            
        }else if (result == 2){//评论已处理
            NSLog(@"为该评论已经有留言了");
        }else if(result == -1){
            NSLog(@"已经有留言了");
        }else{
            NSLog(@"未知系统错误");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
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
