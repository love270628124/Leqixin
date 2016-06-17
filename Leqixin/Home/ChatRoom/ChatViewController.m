//
//  RootViewController.m
//  UUChatTableView
//
//  Created by shake on 15/1/4.
//  Copyright (c) 2015年 uyiuyao. All rights reserved.
//

#import "ChatViewController.h"
#import "UUInputFunctionView.h"
//#import "MJRefresh.h"
#import "UUMessageCell.h"
#import "ChatModel.h"
#import "UUMessageFrame.h"
#import "UUMessage.h"

#import "SingletonWebSocket.h"
#import <AudioToolbox/AudioToolbox.h>

@interface ChatViewController ()<UUInputFunctionViewDelegate,UUMessageCellDelegate,UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) ChatModel *chatModel;

@property (weak, nonatomic) IBOutlet UITableView *chatTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@property (nonatomic,strong)AppDelegate *tempDelegate;
@property (nonatomic, strong) NSUserDefaults *defaults;

@end

@implementation ChatViewController{
    UUInputFunctionView *IFView;
    UILabel *unReadMsgLabel;
    UIActivityIndicatorView *activityIndicatorView;
}

-(void)regisFirstBecome
{
    [IFView.TextViewInput resignFirstResponder];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    self.defaults = [NSUserDefaults standardUserDefaults];
    [self loadBaseViewsAndData];
    
    self.tempDelegate.isChatRoomExist = YES;

    //读取本地聊天记录
//    [self readChatRoomDataSource];
    //获取服务器未读消息
//    [self getUnreadMsgs];
    
    [self getWebSocketMessage];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self readChatRoomDataSource];
    [self.chatTableView reloadData];
    [self tableViewScrollToBottom];
    [IFView refreshData];
    
}
-(void)setupNav
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"bt_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClick:)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       
       NSForegroundColorAttributeName:[UIColor whiteColor]}];

    //KVO
    self.tempDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [self.tempDelegate addObserver:self forKeyPath:@"isReceivedNewMsg" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"isReceivedNewMsg"]) {
        //
//        self.msgDic = self.tempDelegate.chatRoomDataDic;
//        [self getWebSocketMessage];
        [self readChatRoomDataSource];
    }
}

- (void)getUnreadMessage {
    //
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"UnreadMessageFiel" ofType:@"plist"];
//    self.tempDelegate.receiveUnReadMsgArr = [NSMutableArray arrayWithContentsOfFile:path];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.tempDelegate.receiveUnReadMsgArr = [[defaults objectForKey:@"unReadMsgArray"] mutableCopy];
    
    for (int i = 0; i < self.tempDelegate.receiveUnReadMsgArr.count; i++) {
        NSDictionary *dic = self.tempDelegate.receiveUnReadMsgArr[i];
        if ([dic[@"itemid"] isEqualToString:self.msgDic[@"itemid"]]) {
            UUMessage *msg = [[UUMessage alloc]init];
            msg.strName = @"访客";
            msg.from = 1;
            msg.strContent = dic[@"content"];
            UUMessageFrame *msgF = [[UUMessageFrame alloc]init];
            msgF.message = msg;
//            [self.chatModel.dataSource addObject:msgF];
            [self.tempDelegate.receiveUnReadMsgArr removeObjectAtIndex:i];
            i--;
        }
        
    }
    
    [defaults setObject:self.tempDelegate.receiveUnReadMsgArr forKey:@"unReadMsgArray"];
    
//    [self.tempDelegate.receiveUnReadMsgArr writeToFile:path atomically:YES];
    
//    [self.chatTableView reloadData];
//    [self tableViewScrollToBottom];
}

- (void)getWebSocketMessage {
    //
    if (self.msgDic[@"content"]) {
        UUMessage *msg = [[UUMessage alloc]init];
        msg.strName = @"访客";
        msg.from = 1;
        msg.strContent = self.msgDic[@"content"];
        UUMessageFrame *msgF = [[UUMessageFrame alloc]init];
        msgF.message = msg;
        [self.chatModel.dataSource addObject:msgF];
        [self.chatTableView reloadData];
        [self tableViewScrollToBottom];
    }
    
}

-(void)backBtnClick:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
    if (unReadMsgLabel) {
        unReadMsgLabel.hidden = YES;
    }
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //add notification
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tableViewScrollToBottom) name:UIKeyboardDidShowNotification object:nil];
    //
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(returnMessageFromServer:)
                                                 name:ReceivedSenderSuccessMessage
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(returnMessageFromServer:)
                                                 name:ReceivedSenderFailedMessage
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showUnReadMessageAlert:)
                                                 name:ReceivedUnReadMessage object:nil];
    //
    [self getUnreadMessage];
    
    //未读消息提醒
    if (unReadMsgLabel == nil) {
        unReadMsgLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 100, 20)];
        unReadMsgLabel.text = @"0条未读";
        unReadMsgLabel.centerY = 20;
        unReadMsgLabel.textColor = [UIColor whiteColor];
        unReadMsgLabel.hidden = YES;
        [self.navigationController.navigationBar addSubview:unReadMsgLabel];
        
        if (self.tempDelegate.receiveUnReadMsgArr.count > 0) {
            unReadMsgLabel.text = [NSString stringWithFormat:@"%li条未读",self.tempDelegate.receiveUnReadMsgArr.count];
            unReadMsgLabel.hidden = NO;
        }
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    self.tempDelegate.isChatRoomExist = NO;
    
    [self saveChatRoomDataSource];
}


- (void)loadBaseViewsAndData
{
    self.chatModel = [[ChatModel alloc]init];
    self.chatModel.isGroupChat = NO;
    
    IFView = [[UUInputFunctionView alloc]initWithSuperVC:self];
    IFView.delegate = self;
    [self.view addSubview:IFView];
    
    [self.chatTableView reloadData];
    [self tableViewScrollToBottom];
}

-(void)keyboardChange:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    //adjust ChatTableView's height
    if (notification.name == UIKeyboardWillShowNotification) {
        
        self.bottomConstraint.constant = keyboardEndFrame.size.height+40;
    }else{
        self.bottomConstraint.constant = 40 ;

    }
    
    [self.view layoutIfNeeded];
    
    //adjust UUInputFunctionView's originPoint
    CGRect newFrame = IFView.frame;
    newFrame.origin.y = keyboardEndFrame.origin.y - newFrame.size.height - 64;
    IFView.frame = newFrame;
    
    [UIView commitAnimations];
    
}

//tableView Scroll to bottom
- (void)tableViewScrollToBottom
{
    if (self.chatModel.dataSource.count==0)
        return;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.chatModel.dataSource.count-1 inSection:0];
    [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

//
- (void)returnMessageFromServer:(NSNotification *)notification {
    //
    if ([notification.name isEqualToString:ReceivedSenderSuccessMessage]) {
        //发送成功
        [self saveChatRoomDataSource];
        
    } else if ([notification.name isEqualToString:ReceivedSenderFailedMessage]) {
        //发送失败,删除发送内容
        AlertView *alterView = [[AlertView alloc]initWithTitle:@"对方不在线" style:kAlertViewStyleFail showTime:kAlerViewShowTimeDefault];
        [alterView showInView:self.view];
        [self.chatModel.dataSource removeLastObject];
        [self.chatTableView reloadData];
        [self tableViewScrollToBottom];
    }
}

//
- (void)showUnReadMessageAlert:(NSNotification *)notification {
    //显示未读消息
    unReadMsgLabel.hidden = NO;
    unReadMsgLabel.text = [NSString stringWithFormat:@"%li条未读",self.tempDelegate.receiveUnReadMsgArr.count];
    //调用系统震动...
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

#pragma mark - InputFunctionViewDelegate

- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendMessage:(NSString *)message
{
    NSDictionary *dic = @{@"strContent": message,
                          @"type": @(UUMessageTypeText)};
    funcView.TextViewInput.text = @"";
    [self dealTheFunctionData:dic];
    
    //
    if (self.msgDic) {
        NSDictionary *msgDict = @{@"nameid":[self.msgDic valueForKey:@"nameid"],
                                  @"id":[NSString stringWithFormat:@"%li",self.tempDelegate.userModel.userid],
                                  @"itemid":[self.msgDic valueForKey:@"itemid"],
                                  @"type":@"1",
                                  @"msg":message};
        [self senderMessageToServer:msgDict];
        [self addActivityView];
    }
}

- (void)senderMessageToServer:(NSDictionary *)msgDict {
    //
    NSString *msgString = [self dictionaryToJson:msgDict];
    [SingletonWebSocket senderMessageWithString:msgString];
}

- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendPicture:(UIImage *)image
{
    NSDictionary *dic = @{@"picture": image,
                          @"type": @(UUMessageTypePicture)};
    [self dealTheFunctionData:dic];
}

- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendVoice:(NSData *)voice time:(NSInteger)second
{
    NSDictionary *dic = @{@"voice": voice,
                          @"strVoiceTime": [NSString stringWithFormat:@"%d",(int)second],
                          @"type": @(UUMessageTypeVoice)};
    [self dealTheFunctionData:dic];
}

- (void)dealTheFunctionData:(NSDictionary *)dic
{
    [self.chatModel addSpecifiedItem:dic];
    [self.chatTableView reloadData];
    [self tableViewScrollToBottom];
}

#pragma mark - tableView delegate & datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.chatModel.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UUMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    if (cell == nil) {
        cell = [[UUMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellID"];
        cell.delegate = self;
    }
    [cell setMessageFrame:self.chatModel.dataSource[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.chatModel.dataSource[indexPath.row] cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark - cellDelegate
- (void)headImageDidClick:(UUMessageCell *)cell userId:(NSString *)userId{
    
}
#pragma mark WSChatMessageInputBarDelegate
-(void)changeHightWithInputBar:(CGFloat)inputBarY
{
    self.chatTableView.height = inputBarY-self.chatTableView.y;
    
    [self tableViewScrollToBottom];
    
}
-(void)quickReplyViewShow:(CGFloat)quickReplyViewHeight
{
    self.bottomConstraint.constant = quickReplyViewHeight+40;
    
    [self.view layoutIfNeeded];
    
    [self tableViewScrollToBottom];
    
}

//字典转json字符串
- (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

- (void)dealloc {
    [self.tempDelegate removeObserver:self forKeyPath:@"isReceivedNewMsg"];
    
}

-(void)setMsgDic:(NSMutableDictionary *)msgDic
{
    _msgDic = msgDic;

}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

}

-(void)jump2ViewController:(UIViewController *)controller
{
    [self.navigationController pushViewController:controller animated:YES];
}


//读取聊天记录
- (void)readChatRoomDataSource {
    //从NSUserDefaults读取
    self.tempDelegate.chatRoomDataDic = [NSMutableDictionary dictionaryWithDictionary:[self.defaults objectForKey:@"chatRoomDataDic"] ];

    NSMutableArray *dataArr = [NSMutableArray array];
    if (self.tempDelegate.chatRoomDataDic) {
        if (self.model == nil && self.msgDic != nil) {
            //通过通知（抢单通知、自定义消息通知、正常通知）消息获取聊天记录
            dataArr = [self.tempDelegate.chatRoomDataDic
                                         valueForKey:self.msgDic[@"itemid"]];
            self.tempDelegate.chatingVistorId = self.msgDic[@"itemid"];
        } else if (self.model) {
            //通过抢单列表获取聊天记录
           dataArr = [self.tempDelegate.chatRoomDataDic
                                         valueForKey:self.model.itemid ];
            self.tempDelegate.chatingVistorId = self.model.itemid;
        }
        
        NSMutableArray *modelArr = [UUMessage mj_objectArrayWithKeyValuesArray:dataArr];
        NSMutableArray *FrameArr = [NSMutableArray array];

        for (int i = 0 ; i<modelArr.count; i++) {
            UUMessageFrame *msgF = [[UUMessageFrame alloc]init];
            msgF.message =modelArr[i];
            [FrameArr addObject:msgF];
        }
        
        self.chatModel.dataSource = FrameArr;
        
        [self.chatTableView reloadData];
        [self tableViewScrollToBottom];
//        [self getWebSocketMessage];
        
    }
    
}

//保存聊天消息
- (void)saveChatRoomDataSource {
    NSMutableArray *dataArr = [NSMutableArray array];
        //保存到NSUserDefaults
    for (int i = 0; i<self.chatModel.dataSource.count; i++) {
        UUMessageFrame *msgF =self.chatModel.dataSource[i];
        UUMessage *msgModel = msgF.message;
        NSDictionary *dic = [self dicWithMessageModel:msgModel];
        [dataArr addObject:dic];
    }
    
    if (dataArr == nil) {
        dataArr = [NSMutableArray array];
    }
    
    if (self.model == nil && self.msgDic != nil) {
        //消息来自通知（抢单通知、自定义消息通知、正常通知）
        [self.tempDelegate.chatRoomDataDic setValue:dataArr
                                             forKey:self.msgDic[@"itemid"] ];
    } else if (self.model) {
        //消息来自抢单列表
        [self.tempDelegate.chatRoomDataDic setValue:dataArr
                                             forKey:self.model.itemid ];
    }
    
    [self.defaults setValue:self.tempDelegate.chatRoomDataDic forKey:@"chatRoomDataDic"];
    
}

-(NSDictionary *)dicWithMessageModel:(UUMessage *)model
{
    return [model mj_keyValuesWithKeys:@[@"strIcon",@"strId",@"strTime",@"strName",@"strContent",@"picture",@"voice",@"strVoiceTime",@"type",@"from",@"showDateLabel"]];
    
}

#pragma mark - 发送等待
- (void)addActivityView {
    if (activityIndicatorView) {
        [activityIndicatorView removeFromSuperview];
    }
    activityIndicatorView = [[UIActivityIndicatorView alloc] init];
    activityIndicatorView.frame = CGRectMake(0, 0, 30, 30);
    activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [activityIndicatorView startAnimating];
    [self.view addSubview:activityIndicatorView];
}

@end
