//
//  LoginViewController.m
//  乐企信
//
//  Created by 震霄 张 on 16/3/28.
//  Copyright © 2016年 SDW. All rights reserved.
//

#import "LoginViewController.h"
//#import "FindPasswdViewController.h"
#import "AppDelegate.h"
#import "AlertView.h"
#import "UserInfoModel.h"
#import "ChergeModel.h"
#import "HomeViewController.h"

@interface LoginViewController ()<UITextFieldDelegate,AlertViewDelegate>

@property (nonatomic,weak)UIImageView *iconView;
@property (nonatomic,weak)UIView *inputView;
@property (nonatomic,weak)UITextField *companyIdField;
@property (nonatomic,weak)UITextField *userNameField;
@property (nonatomic,weak)UITextField *passwdField;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *iconView = [[UIImageView alloc]init];
    iconView.y = 70 * SCREEN_SCALE_H;
    iconView.width = SCREEN_W * 0.3*0.85;
    iconView.height = iconView.width;
    iconView.x = SCREEN_W * 0.5 - iconView.width*0.5;

    iconView.image = [UIImage imageNamed:@"login_icon_photo"];
    [self.view addSubview:iconView];
    self.iconView = iconView;
    iconView.layer.masksToBounds = YES;
    iconView.layer.cornerRadius = iconView.width * 0.5;
    iconView.layer.borderWidth = 1.0;
    iconView.layer.borderColor = [UIColor grayColor].CGColor;
    
    AppDelegate *tempDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:tempDelegate.userModel.headimg] placeholderImage:[UIImage imageNamed:@"login_icon_photo"]];
    
    [self setupNav];
    
    [self setupInputView];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

    
    //测试用途
//    self.companyIdField.text = @"10076";
//    self.userNameField.text = @"test";
//    self.passwdField.text = @"123456";
    
    [self readUserInfo];
}

-(void)readUserInfo
{
    NSUserDefaults *userD=[NSUserDefaults standardUserDefaults];
    NSString *isAuto = [userD valueForKey:@"autoLogin"];
    
    NSDictionary *loginUserinfoDic=[userD valueForKey:@"userInfo"];
    if (loginUserinfoDic != NULL) {
        self.companyIdField.text = loginUserinfoDic[@"companyId"];
        self.userNameField.text = loginUserinfoDic[@"userName"];
        self.passwdField.text = loginUserinfoDic[@"userPwd"];
    }

    if ([isAuto isEqualToString:@"1"]) {
        [self loginBtnClick:nil];
    }
}
-(void)setupNav
{
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //    //导航栏透明处理
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
}
-(void)setupInputView
{
    NSArray *labelArr = @[@"企业编号",@"用户名",@"密码"];
    NSArray *textFieldArr = @[@"请填写企业编号",@"请填写用户名",@"请填写密码"];
    
    UIView *inputView = [[UIView alloc]init];
    inputView.x = 20 *SCREEN_SCALE_W;
    inputView.y = CGRectGetMaxY(self.iconView.frame)+ 40 *SCREEN_SCALE_H;
    inputView.width = SCREEN_W-inputView.x*2;
    inputView.height = 220 *SCREEN_SCALE_H;
    inputView.backgroundColor = [UIColor clearColor];
    self.inputView = inputView;
    [self.view addSubview:inputView];
    
    CGFloat labelWidth = inputView.height * 0.35;
    CGFloat labelHeight = inputView.height / (labelArr.count + 1);
    CGFloat textFieldWidth = inputView.width - labelWidth;
    CGFloat textFieldHeight = labelHeight;
    for (int i = 0; i<labelArr.count; i++) {
        UILabel *label = [[UILabel alloc]init];
        label.adjustsFontSizeToFitWidth = YES;
        label.x = 10 *SCREEN_SCALE_W;
        label.y = labelHeight * i;
        label.width = labelWidth;
        label.height = labelHeight;
        label.text = labelArr[i];
      //  label.backgroundColor = [UIColor redColor];
        label.font = [UIFont systemFontOfSize:18];
        label.textColor = ZXcolor(85, 83, 96);
        [inputView addSubview:label];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(label.x, CGRectGetMaxY(label.frame)-1, inputView.width-2*label.x, 1)];
        lineView.backgroundColor = ZXcolor(230, 230, 230);
        [inputView addSubview:lineView];
        
        UITextField *textField = [[UITextField alloc]init];
        if (i==0) {
            textField.keyboardType = UIKeyboardTypePhonePad;
            self.companyIdField = textField;
        }else if(i == 1){
            textField.keyboardType = UIKeyboardTypeEmailAddress;
            self.userNameField = textField;
        }else{
            textField.keyboardType = UIKeyboardTypeASCIICapable;
            self.passwdField = textField;
        }
        textField.textColor = [UIColor blackColor];
        textField.delegate = self;
        textField.x = CGRectGetMaxX(label.frame)+10;
        textField.y = label.y;
        textField.width = textFieldWidth;
        textField.height = textFieldHeight;
        textField.placeholder = textFieldArr[i];
        textField.font = [UIFont systemFontOfSize:16];
        UIColor *color = ZXcolor(134, 135, 136);
        [textField setValue:color forKeyPath:@"_placeholderLabel.textColor"];
        [inputView addSubview:textField];
        if(i == labelArr.count-1){
            textField.secureTextEntry = YES;
            textField.width = textFieldWidth * 0.6;
        }
    }
    UIButton *loginBtn = [[UIButton alloc]init];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //loginBtn.backgroundColor = ZXcolor(29, 206, 115);
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"Sign-In-Button"] forState:UIControlStateNormal];

    loginBtn.x = 10 * SCREEN_SCALE_W;
    loginBtn.width = inputView.width - loginBtn.x * 2;
    loginBtn.y = labelHeight * 3+5*SCREEN_SCALE_H;
    loginBtn.height  = labelHeight*0.8;
    [loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [inputView addSubview:loginBtn];
    
    /**
     *  @brief  监听键盘显示、隐藏变化，让自己伴随键盘移动
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];
}
//-(void)forgetBtnClick:(UIButton *)btn
//{
//    [self.navigationController pushViewController:[[FindPasswdViewController alloc]init] animated:YES];
//}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - 伴随键盘移动

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
    
    
    if (notification.name == UIKeyboardWillShowNotification)
    {

        self.inputView.y =SCREEN_H - keyboardEndFrame.size.height - self.inputView.height;
        self.iconView.y = self.inputView.y - self.iconView.height-40*SCREEN_SCALE_H;
//        if (self.inputView.y<CGRectGetMaxY(self.iconView.frame)) {
//            self.iconView.hidden = YES;
//        }else
//            self.iconView.hidden = NO;
    }else
    {
        self.iconView.y = 70*SCREEN_SCALE_H;


//        self.iconView.y += keyboardEndFrame.size.height;
        self.inputView.y = CGRectGetMaxY(self.iconView.frame)+40 *SCREEN_SCALE_H;
//        self.iconView.hidden = NO;
    }
    
    [self.view layoutIfNeeded];
    [UIView commitAnimations];
}


//输入框获取输入焦点后，隐藏其他视图
-(void)textViewDidBeginEditing:(UITextView *)textView
{


}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if ([string isEqualToString:@"\n"]) {
        
        [textField resignFirstResponder];  //textField为你的UITextField实例对象
        return NO;
    }
    
    return YES;
}
//字典转json字符串
- (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
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
//字符串转json字符串
-(NSString *) jsonStringWithString:(NSString *) string{
    return [NSString stringWithFormat:@"\"%@\"",
            [[string stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"] stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""]
            ];
}

-(void)loginBtnClick:(id)sender
{

    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    [[JSSDWProgressHUD shareProgressHud]showWithSuperView:self.view];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.companyIdField.text forKey:@"companyid"];
    [params setObject:self.userNameField.text forKey:@"username"];
    [params setObject:self.passwdField.text forKey:@"password"];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
    [muDic setObject:@"Interface" forKey:@"g"];
    [muDic setObject:@"Init150" forKey:@"m"];
    [muDic setObject:@"login" forKey:@"a"];
    
    [muDic setObject:[self dictionaryToJson:params] forKey:@"data"];
//@"http://180.76.164.79/index.php"
    [manager GET:[NSString stringWithFormat:@"%@/index.php",rootUrl] parameters:muDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",dic);
        
        if ([dic[@"errcode"]isEqualToString:@"0"]) {
            
            [[JSSDWProgressHUD shareProgressHud]hiddenProgressHud];
            
            if (dic[@"data"]) {
                UserInfoModel *userModel = [UserInfoModel mj_objectWithKeyValues:dic[@"data"]];
                
                AppDelegate * tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
                tempAppDelegate.userModel = userModel;
                
                UIImage *iconImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:userModel.headimg]]];
                if (iconImage!=nil) {
                    tempAppDelegate.meIconImage = iconImage;
                }else
                {
                    tempAppDelegate.meIconImage = [UIImage imageNamed:@"login_icon_photo"];
                }
                
                AlertView *view = [[AlertView alloc] initWithTitle:@"登录成功" style:kAlertViewStyleSuccess showTime:kAlerViewShowTimeOneSecond];
                view.delegate = self;
                [view showInView:self.view];
                
                //极光设置别名x
                [JPUSHService setTags:nil
                                alias:[NSString stringWithFormat:@"%ld",(long)userModel.userid]
                     callbackSelector:@selector(tagsAliasCallback:tags:alias:)
                               object:self];
                
                [self saveUserInfo:userModel];
                
                HomeViewController *homeVc = [[HomeViewController alloc]init];
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:homeVc];
                [UINavigationBar appearance].barTintColor=[UIColor colorWithRed:0/255.0 green:152/255.0 blue:234/255.0 alpha:0.85];
                tempAppDelegate.window.rootViewController = nav;
                tempAppDelegate.homeVc = homeVc;

            }
            
            if (dic[@"cherge"]) {
                ChergeModel *chergeModel = [ChergeModel mj_objectWithKeyValues:dic[@"cherge"]];
                AppDelegate * tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
                tempAppDelegate.chergeModel = chergeModel;
                if ([chergeModel.xunpantanchuang isEqualToString:@"true"]) {
                    tempAppDelegate.isGrabOut = YES;
                }else{
                    tempAppDelegate.isGrabOut = NO;
                }
                
            }
            
        }
        
        else if([dic[@"errcode"]isEqualToString:@"25"]){
            
            [[JSSDWProgressHUD shareProgressHud]hiddenProgressHud];
            [self.view endEditing:YES];
            [self popAlertView:@"denglu_tan1"];
        }
        
        else{
            NSString *errorStr;
            if (dic == nil) {
                errorStr = @"登录失败";
            }else
                errorStr =dic[@"errmsg"];
            
            AlertView *sview = [[AlertView alloc] initWithTitle:errorStr style:kAlertViewStyleFail showTime:kAlerViewShowTimeOneSecond];
            sview.delegate = self;
            [sview showInView:self.view];
                    [[JSSDWProgressHUD shareProgressHud]hiddenProgressHud];

        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        AlertView *view = [[AlertView alloc] initWithTitle:@"登录失败" style:kAlertViewStyleFail showTime:kAlerViewShowTimeOneSecond];
        view.delegate = self;
        [view showInView:self.view];
        [[JSSDWProgressHUD shareProgressHud]hiddenProgressHud];

    }];

}

- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {
    NSString *callbackString =
    [NSString stringWithFormat:@"%d, \ntags: %@, \nalias: %@\n", iResCode,
     [self logSet:tags], alias];
    NSLog(@"TagsAlias回调:%@", callbackString);
}
- (NSString *)logSet:(NSSet *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

-(void)saveUserInfo:(UserInfoModel *)model
{
    NSUserDefaults *userD=[NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userInfoDic = [NSMutableDictionary dictionary];
    [userInfoDic setValue:model.username forKey:@"userName"];
    [userInfoDic setValue:model.password forKey:@"userPwd"];
    [userInfoDic setValue:model.headimg forKey:@"iconUrl"];
    [userInfoDic setValue:[NSString stringWithFormat:@"%ld",(long)model.companyid]forKey:@"companyId"];
    [userD setObject:userInfoDic forKey:@"userInfo"];
    
    [userD setObject:@"1" forKey:@"autoLogin"];//1-自动登录;0-不自动登录
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

-(void)alertViewtimeFinishedToDo
{
    
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

@end
