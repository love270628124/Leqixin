//
//  SettingViewController.m
//  乐企信
//
//  Created by 震霄 张 on 16/3/29.
//  Copyright © 2016年 SDW. All rights reserved.
//

#import "SettingViewController.h"
#import "MineInfoViewController.h"
#import "ChangePswdController.h"
#import "EditReplyViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "AlertView.h"
#import "ContactUsController.h"
#import "ContactModel.h"
#import "Contact.h"

#import "SingletonWebSocket.h"

#define cellHeight 49 * SCREEN_SCALE_H
@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate,AlertViewDelegate>
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,weak)UIButton *quickBtn;
@property (nonatomic,weak)UISwitch *switchBtn;
@end

@implementation SettingViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ZXcolor(239, 239, 244);
    
    [self setupNav];
    [self setupSettingView];
    
    self.automaticallyAdjustsScrollViewInsets = false;//去掉顶部空白

}

-(void)setupNav
{
    //导航栏透明处理
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
 self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"bt_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClick:)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    self.title = @"设置";
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

-(void)setupSettingView
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 30*SCREEN_SCALE_H+cellHeight* 7) style:UITableViewStyleGrouped];

    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"settingCell"];
    tableView.dataSource = self;
    tableView.delegate = self;
    
    self.tableView = tableView;
    [self.view addSubview:tableView];
    self.tableView.scrollEnabled = NO;
    
    UIButton *quitBtn = [[UIButton alloc]init];

    //[quitBtn setBackgroundColor:[UIColor whiteColor]];
    [quitBtn setBackgroundImage:[UIImage imageNamed:@"bg_baidi"] forState:UIControlStateNormal];
    [quitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [quitBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    quitBtn.x = 0;
    quitBtn.y = CGRectGetMaxY(self.tableView.frame);
    quitBtn.width = SCREEN_W;
    quitBtn.height = cellHeight;
    self.quickBtn = quitBtn;
    [quitBtn addTarget:self action:@selector(quickBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:quitBtn];
    
}
-(void)quickBtnClick:(UIButton *)btn
{
    NSLog(@"退出登录");
    
    AlertView *showView = [[AlertView alloc]initWithTitle:@"温馨提醒" content:@"是否退出登录" target:self buttonsTitle:@[@"确定",@"取消"]];
        [showView showInView:self.view];
    NSUserDefaults *userD=[NSUserDefaults standardUserDefaults];
    [userD setObject:@"0" forKey:@"autoLogin"];//0-不自动登录
    

    [JPUSHService setTags:nil
                    alias:@""
         callbackSelector:nil
                   object:self];
    
    
    //清空数据库通讯录数据
//    AppDelegate *tempDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        NSMutableArray *dataArr=[self readDataWithCompanyId:[NSString stringWithFormat:@"%li",(long)tempDelegate.userModel.companyid]];//从数据库读取本地数据
//    if (dataArr.count == 0) {
//        return;
//    }
//    NSManagedObjectContext *myContext = tempDelegate.managedObjectContext;
//
//    for (Contact* aUser in dataArr) {
//        [myContext deleteObject:aUser];
//    }
    
    //清空首页展示数据缓存
    NSUserDefaults *sevenDefault = [NSUserDefaults standardUserDefaults];
    [sevenDefault setObject:@"0" forKey:@"sevenPV"];
    [sevenDefault setObject:@"0" forKey:@"sevenUV"];
    [sevenDefault setObject:@"0%" forKey:@"sevenJP"];
    [sevenDefault setObject:@"0" forKey:@"sevenSP"];
    
}


- (void)alertView:(AlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex withString:(NSString *)str{
    if (buttonIndex==0) {
        if (alertView.indexPath != nil) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setValue:[NSDictionary dictionary] forKey:@"chatRoomDataDic"];
            AlertView *showView = [[AlertView alloc]initWithTitle:@"清空完毕" style:kAlertViewStyleSuccess showTime:kAlerViewShowTimeOneSecond];
            [showView showInView:self.view];
        }else{
            AppDelegate *tempDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            tempDelegate.mainNavigationController = nil;
            tempDelegate.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:[[LoginViewController alloc]init]];
            //cut webSocket connect
            [SingletonWebSocket handCutOffConnectServer];
        }
        
        
    }else{
        
    }
}
//- (void)alertViewtimeFinishedToDo
//{
////    AppDelegate *tempDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
////    tempDelegate.leftSideMenu = nil;
////    tempDelegate.mainNavigationController = nil;
////    tempDelegate.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:[[LoginViewController alloc]init]];
//
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)backBtnClick:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark tableViewDelegate/dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if(section == 1){
        return 3;
    }else
        return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *tempDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingCell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.imageView.image = [UIImage imageNamed:@"icon_me"];
        cell.textLabel.text = @"我的资料";
       
        UIView *accessView = [[UIView alloc]init];
        UIImage *dataEnter = [UIImage imageNamed:@"data_icon_enter"];
        UIImageView *iconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_moren-tx"]];


       // UIImage *iconImage = [UIImage imageNamed:@"pic_header"];
        accessView.width = cellHeight+10+dataEnter.size.width;
        accessView.height = cellHeight;


        
        UserInfoModel *model = tempDelegate.userModel;
        [iconView sd_setImageWithURL:[NSURL URLWithString:model.headimg] placeholderImage:[UIImage imageNamed:@"login_icon_photo"]];
        
        iconView.y = 5;
        iconView.width = cellHeight - 10;
        iconView.height = iconView.width;
        iconView.x = SCREEN_W - 40*SCREEN_SCALE_W - iconView.width;
        [cell.contentView addSubview:iconView];
        
        
        iconView.layer.masksToBounds = YES;
        iconView.layer.cornerRadius = iconView.width * 0.5;
        iconView.layer.borderWidth = 1.0;
        UIColor *tempColor = ZXcolor(230, 230, 230);
        iconView.layer.borderColor = tempColor.CGColor;
        
//        iconView.image = tempDelegate.iconImage;
        
//        UIImageView *changeTag = [[UIImageView alloc]initWithImage:dataEnter];
//        changeTag.frame = CGRectMake(CGRectGetMaxX(iconView.frame)+10, (cellHeight-dataEnter.size.height)*0.5, dataEnter.size.width, dataEnter.size.height);
//        [accessView addSubview:iconView];
//        [accessView addSubview:changeTag];
        
//        cell.accessoryView = accessView;
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;


        
        }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            cell.imageView.image = [UIImage imageNamed:@"icon_code"];
            cell.textLabel.text = @"修改密码";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        }else if(indexPath.row == 1){
            cell.imageView.image = [UIImage imageNamed:@"icon_answer"];
            cell.textLabel.text = @"快捷回复";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else if(indexPath.row == 2){
            cell.imageView.image = [UIImage imageNamed:@"icon_rubbish"];
            cell.textLabel.text = @"清空聊天记录";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            UISwitch *switchBtb = [[UISwitch alloc]init];
            AppDelegate *tempDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            switchBtb.on = tempDelegate.isGrabOut;
            if (tempDelegate.isGrabOut == NO) {
                switchBtb.enabled = NO;
            }else{
                switchBtb.enabled = YES;
            }
            [switchBtb addTarget:self action:@selector(switchClick) forControlEvents:UIControlEventValueChanged];
            self.switchBtn = switchBtb;
            cell.imageView.image = [UIImage imageNamed:@"icon_window"];
            cell.textLabel.text = @"询盘弹窗";
            cell.accessoryView = switchBtb;
            
            
        }
        else if (indexPath.row == 1){
            cell.imageView.image = [UIImage imageNamed:@"set_icon_contact"];
            cell.textLabel.text = @"联系我们";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
//        else if (indexPath.row == 2){
//            cell.imageView.image = [UIImage imageNamed:@"icon_shake"];
//            cell.textLabel.text = @"震动";
//            cell.accessoryView = [[UISwitch alloc]init];
//        }
    }
    
    return cell;
}

-(void)switchClick
{
    AppDelegate *tempDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    tempDelegate.isGrabOut = self.switchBtn.on;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10 * SCREEN_SCALE_H;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        [self.navigationController pushViewController:[[MineInfoViewController alloc]init] animated:YES];
    }else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            [self.navigationController pushViewController:[[ChangePswdController alloc]init] animated:YES];
        }else if (indexPath.row == 1){
            [self.navigationController pushViewController:[[EditReplyViewController alloc]init] animated:YES];
        }else if (indexPath.row == 2){//清空聊天记录
            AlertView *showView = [[AlertView alloc]initWithTitle:@"温馨提醒" content:@"是否清空聊天记录" target:self buttonsTitle:@[@"确定",@"取消"]];
            showView.indexPath = indexPath;
            showView.delegate = self;
            [showView showInView:self.view];
        }
    }else if (indexPath.section == 2){
    
        if (indexPath.row == 1) {
            // 联系我们
            [self.navigationController pushViewController:[[ContactUsController alloc]init] animated:YES];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10 * SCREEN_SCALE_H;
}

@end
