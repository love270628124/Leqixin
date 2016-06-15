//
//  ChangePswdController.m
//  乐企信
//
//  Created by 震霄 张 on 16/4/7.
//  Copyright © 2016年 SDW. All rights reserved.
//

#import "ChangePswdController.h"
#import "AppDelegate.h"
#import "UserInfoModel.h"

@interface ChangePswdController ()<AlertViewDelegate>
@property (nonatomic,weak)UITextField *usedPswdField;
@property (nonatomic,weak)UITextField *setNewPswdField;
@property (nonatomic,weak)UITextField *againPswdField;
@end

@implementation ChangePswdController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ZXcolor(239, 239, 244);
    
    [self setupNav];
    [self setupNewPswdView];
}
-(void)alertViewtimeFinishedToDo
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupNav
{
    //导航栏透明处理
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"bt_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClick:)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(completeBtnClick)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    self.title = @"修改密码";
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
}
-(void)backBtnClick:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)completeBtnClick
{
    
    NSUserDefaults *userD=[NSUserDefaults standardUserDefaults];
    NSDictionary *loginUserinfoDic=[userD valueForKey:@"userInfo"];
    if (loginUserinfoDic != NULL) {

        if (![self.usedPswdField.text isEqualToString:loginUserinfoDic[@"userPwd"]]) {
            AlertView *showView = [[AlertView alloc]initWithTitle:@"旧密码错误" style:kAlertViewStyleWarn showTime:kAlerViewShowTimeOneSecond];
            [showView showInView:self.view];
            return;
        }
    }
    
    if ([self.setNewPswdField.text isEqualToString:self.usedPswdField.text]) {
        AlertView *showView = [[AlertView alloc]initWithTitle:@"新旧密码相同" style:kAlertViewStyleWarn showTime:kAlerViewShowTimeOneSecond];
        [showView showInView:self.view];
        return;
    }
    
    if (![self.setNewPswdField.text isEqualToString:self.againPswdField.text]) {
        AlertView *showView = [[AlertView alloc]initWithTitle:@"新密码不一致" style:kAlertViewStyleWarn showTime:kAlerViewShowTimeOneSecond];
        [showView showInView:self.view];
        return;
    }
    if (self.usedPswdField.text.length == 0) {
        AlertView *showView = [[AlertView alloc]initWithTitle:@"请输入旧密码" style:kAlertViewStyleWarn showTime:kAlerViewShowTimeOneSecond];
        [showView showInView:self.view];
        return;
    }
    if (self.setNewPswdField.text.length == 0) {
        AlertView *showView = [[AlertView alloc]initWithTitle:@"请输入新密码" style:kAlertViewStyleWarn showTime:kAlerViewShowTimeOneSecond];
        [showView showInView:self.view];
        return;
    }

    //TO DO
    AppDelegate *tempDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UserInfoModel *userModel = tempDelegate.userModel;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSString stringWithFormat:@"%ld",userModel.userid] forKey:@"itemid"];
    [params setObject:@"19f22d9afe1998d3def77bf51b7933d2" forKey:@"identify"];
    [params setObject:self.setNewPswdField.text forKey:@"password"];
    [params setObject:self.usedPswdField.text forKey:@"password_bk"];

//    NSString *changePswdUrl = @"http://180.76.164.79/index.php";
    NSString *changePswdUrl = [NSString stringWithFormat:@"%@/index.php",rootUrl];
    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
    [muDic setObject:@"Interface" forKey:@"g"];
    [muDic setObject:@"New" forKey:@"m"];
    [muDic setObject:@"password_save" forKey:@"a"];
    
    [muDic setObject:[self dictionaryToJson:params] forKey:@"data"];
    [manager GET:changePswdUrl parameters:muDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSInteger result = [dic[@"result"]intValue];
        NSLog(@"result:%ld",(long)result);
        if (result == 1) {
            tempDelegate.userModel.password = self.setNewPswdField.text;//保存
            AlertView *showView = [[AlertView alloc]initWithTitle:@"密码修改成功" style:kAlertViewStyleSuccess showTime:kAlerViewShowTimeOneSecond];
            showView.delegate = self;
            [showView showInView:self.view];
        }else if(result == 0){
            AlertView *showView = [[AlertView alloc]initWithTitle:@"原密码错误" style:kAlertViewStyleWarn showTime:kAlerViewShowTimeOneSecond];
            [showView showInView:self.view];
        }else{
            AlertView *showView = [[AlertView alloc]initWithTitle:@"系统错误" style:kAlertViewStyleFail showTime:kAlerViewShowTimeOneSecond];
            [showView showInView:self.view];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        AlertView *showView = [[AlertView alloc]initWithTitle:@"系统错误" style:kAlertViewStyleFail showTime:kAlerViewShowTimeOneSecond];
        [showView showInView:self.view];
    }];

}
-(void)setupNewPswdView
{
    UIView *usedPswdView = [[UIView alloc]init];
    usedPswdView.frame = CGRectMake(0,10*SCREEN_SCALE_H, SCREEN_W, 44 * SCREEN_SCALE_H);
    usedPswdView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:usedPswdView];
    [self setupInputPswdView:usedPswdView andPlaceHold:@"旧密码" index:0];
    
    UIView *newPswdView = [[UIView alloc]init];
    newPswdView.frame = CGRectMake(0, CGRectGetMaxY(usedPswdView.frame)+10 * SCREEN_SCALE_H, SCREEN_W, 44 * SCREEN_SCALE_H);
    newPswdView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:newPswdView];
    [self setupInputPswdView:newPswdView andPlaceHold:@"新密码" index:1];
    
    UIView *againPswdView = [[UIView alloc]init];
    againPswdView.frame = CGRectMake(0, CGRectGetMaxY(newPswdView.frame)+1, SCREEN_W, 44 * SCREEN_SCALE_H);
    againPswdView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:againPswdView];
    [self setupInputPswdView:againPswdView andPlaceHold:@"请再次输入新密码" index:2];

}
-(void)setupInputPswdView:(UIView *)bgView andPlaceHold:(NSString *)placeHold index:(NSInteger)index
{

    UITextField *inputField = [[UITextField alloc]initWithFrame:CGRectMake(20*SCREEN_SCALE_W, 0, bgView.width - 66 * SCREEN_SCALE_W, bgView.height)];
    inputField.placeholder = placeHold;
    [bgView addSubview:inputField];
    inputField.secureTextEntry = YES;
    
    UIButton *deleteBtn = [[UIButton alloc]init];
    deleteBtn.x = CGRectGetMaxX(inputField.frame);
    UIImage *deleteImage = [UIImage imageNamed:@"name_bt_delete"];
    [deleteBtn setBackgroundImage:deleteImage forState:UIControlStateNormal];
    deleteBtn.y =(bgView.height - deleteImage.size.height)*0.5;
    deleteBtn.size = deleteImage.size;
    [bgView addSubview:deleteBtn];
    [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    if (index == 0) {
        self.usedPswdField = inputField;
        deleteBtn.tag = usedPswdDeleteBtnTag;
    }else if (index == 1){
        self.setNewPswdField = inputField;
        deleteBtn.tag = newPswdDeleteBtnTag;
    }else{
        self.againPswdField = inputField;
        deleteBtn.tag = againPswdDeleteBtnTag;
    }
}
-(void)deleteBtnClick:(UIButton *)btn
{
    if (btn.tag == usedPswdDeleteBtnTag) {
        self.usedPswdField.text = @"";
        
    }else if (btn.tag == newPswdDeleteBtnTag){
        self.setNewPswdField.text = @"";
    
    }else if (btn.tag == againPswdDeleteBtnTag){
        self.againPswdField.text = @"";
    }
}

//字典转json字符串
- (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}
@end
