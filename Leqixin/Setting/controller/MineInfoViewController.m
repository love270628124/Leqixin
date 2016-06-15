//
//  MineInfoViewController.m
//  乐企信
//
//  Created by 震霄 张 on 16/3/30.
//  Copyright © 2016年 SDW. All rights reserved.
//

#import "MineInfoViewController.h"
#import "AlertView.h"
#import "UserInfoModel.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "MLSelectPhotoAssets.h"
#import "MLSelectPhotoPickerAssetsViewController.h"
#import "MLSelectPhotoBrowserViewController.h"
#import "HomeViewController.h"


#define cellHeight 44 * SCREEN_SCALE_H
#define labelWidth 180 *SCREEN_SCALE_W
//回掉代码块

@interface MineInfoViewController ()<UITableViewDataSource,UITableViewDelegate,AlertViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *mineInfoArr;
@property (nonatomic,strong)NSMutableArray *companyInfoArr;
@property (nonatomic,strong)UserInfoModel *userModel;
@property (nonatomic,strong)UIAlertController *alertController;
@property (nonatomic,weak)UIImageView *iconView;
@property (nonatomic,strong)AlertView *alterView;


@end

@implementation MineInfoViewController

-(NSMutableArray *)mineInfoArr
{

    if (_mineInfoArr == nil) {

        _mineInfoArr = [NSMutableArray array];
//        NSDictionary *dicIcon =  @{@"type":@"头像",@"value":@"pic_header"};
        NSMutableDictionary *dicIcon =[NSMutableDictionary dictionary];
        [dicIcon setObject:@"头像" forKey:@"type"];
        [dicIcon setObject:self.userModel.headimg forKey:@"value"];
        
        NSMutableDictionary *dicName =[NSMutableDictionary dictionary];
        [dicName setObject:@"姓名" forKey:@"type"];
        [dicName setObject:self.userModel.truename forKey:@"value"];
        
        NSMutableDictionary *dicTel =[NSMutableDictionary dictionary];
        [dicTel setObject:@"手机" forKey:@"type"];
        [dicTel setObject:[NSString stringWithFormat:@"%ld",(long)self.userModel.mobile] forKey:@"value"];
        
        NSMutableDictionary *dicMob =[NSMutableDictionary dictionary];
        [dicMob setObject:@"电话" forKey:@"type"];
        [dicMob setObject:[NSString stringWithFormat:@"%ld",(long)self.userModel.telphone] forKey:@"value"];
        
        NSMutableDictionary *dicWX =[NSMutableDictionary dictionary];
        [dicWX setObject:@"微信号" forKey:@"type"];
        [dicWX setObject:self.userModel.wxnumber forKey:@"value"];
        
        NSMutableDictionary *dicEmail =[NSMutableDictionary dictionary];
        [dicEmail setObject:@"邮箱" forKey:@"type"];
        [dicEmail setObject:self.userModel.email forKey:@"value"];
        
        NSMutableDictionary *dicSex =[NSMutableDictionary dictionary];
        [dicSex setObject:@"性别" forKey:@"type"];
        NSInteger sex = self.userModel.sex;
        if (sex == 0) {
            [dicSex setObject:@"男" forKey:@"value"];

        }else{
            [dicSex setObject:@"女" forKey:@"value"];

        }

//        [dicSex setObject:[NSString stringWithFormat:@"%ld",self.userModel.sex] forKey:@"value"];
        
        NSMutableDictionary *dicBirth =[NSMutableDictionary dictionary];
        [dicBirth setObject:@"生日" forKey:@"type"];
        [dicBirth setObject:self.userModel.brithday forKey:@"value"];

        
        [_mineInfoArr addObject:dicIcon];
        [_mineInfoArr addObject:dicName];
        [_mineInfoArr addObject:dicTel];
        [_mineInfoArr addObject:dicMob];
        [_mineInfoArr addObject:dicWX];
        [_mineInfoArr addObject:dicEmail];
        [_mineInfoArr addObject:dicSex];
        [_mineInfoArr addObject:dicBirth];

        
    }
    return _mineInfoArr;
}
-(NSMutableArray *)companyInfoArr
{
    if (_companyInfoArr == nil) {
        _companyInfoArr = [NSMutableArray array];
        
        NSMutableDictionary *dicAccount =[NSMutableDictionary dictionary];
        [dicAccount setObject:@"账号" forKey:@"type"];
        [dicAccount setObject:self.userModel.username forKey:@"value"];
        
        NSMutableDictionary *dicDepart =[NSMutableDictionary dictionary];
        [dicDepart setObject:@"部门" forKey:@"type"];
        [dicDepart setObject:self.userModel.department forKey:@"value"];
        
        NSMutableDictionary *dicOfficer =[NSMutableDictionary dictionary];
        [dicOfficer setObject:@"职位" forKey:@"type"];
        [dicOfficer setObject:self.userModel.officer forKey:@"value"];
        
        NSMutableDictionary *dicEntry =[NSMutableDictionary dictionary];
        [dicEntry setObject:@"入职时间" forKey:@"type"];
        [dicEntry setObject:self.userModel.entry forKey:@"value"];
        
        [_companyInfoArr addObject:dicAccount];
        [_companyInfoArr addObject:dicDepart];
        [_companyInfoArr addObject:dicOfficer];
        [_companyInfoArr addObject:dicEntry];
        
    }
    return _companyInfoArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *tempDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.userModel = tempDelegate.userModel;
    self.view.backgroundColor = ZXcolor(239, 239, 244);

    [self setupNav];
    [self setupMineInfoView];
    self.automaticallyAdjustsScrollViewInsets = false;//去掉顶部空白
    
    //拍照或打开相册控制器
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 ) {
        [self setupCameraView];
    }

    
}
-(void)setupCameraViewBelow8
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"选择图片"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"拍照", @"从手机相册选择",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:imagePickerController animated:YES completion:^{
            
        }];
    }else if (buttonIndex == 1) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:imagePickerController animated:YES completion:^{
            
        }];

        
    }else if(buttonIndex == 2) {
        
    }
    
}


-(void)setupCameraView
{
//    UIColor *showColor = [UIColor colorWithRed:0/255.0 green:152/255.0 blue:234/255.0 alpha:0.85];
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"选择图片" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAc = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //     [self.bg removeFromSuperview];
        [self.alertController.view setTintColor:[UIColor blackColor]];
        
    }];
//    [cancelAc setValue:[UIColor redColor] forKey:@"titleTextColor"];

    UIAlertAction *openCamera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //            [self takePhoto];
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:imagePickerController animated:YES completion:^{
            
        }];
    }];
//    [openCamera setValue:showColor forKey:@"titleTextColor"];

    UIAlertAction *openAlbum = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:imagePickerController animated:YES completion:^{
            
        }];
        
    }];
//    [openAlbum setValue:showColor forKey:@"titleTextColor"];

    [ac addAction:cancelAc];
    [ac addAction:openCamera];
    [ac addAction:openAlbum];
    [ac.view setTintColor:[UIColor blackColor]];
    self.alertController = ac;

}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    UIImage *iconImage = [info objectForKey:UIImagePickerControllerEditedImage];
//    self.iconView.image = iconImage;
    
    
    AppDelegate *tempDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UserInfoModel *userModel = tempDelegate.userModel;
    self.delegate = tempDelegate.homeVc;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
//    NSString *imageUrl = @"http://180.76.164.79/index.php?g=Interface&m=New&a=img_upload";
    NSString *imageUrl = [NSString stringWithFormat:@"%@/index.php?g=Interface&m=New&a=img_upload",rootUrl];
    //?g=Interface&m=New&a=img_upload
    
    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];

    muDic[@"itemid"]=[NSString stringWithFormat:@"%ld",(long)userModel.userid];
    

    iconImage = [self imageWithImage:iconImage scaledToSize:CGSizeMake(200, 200)];
    NSData *imageData = UIImageJPEGRepresentation(iconImage, 1);
    
//    tempDelegate.meIconImage = iconImage;

    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
    
    [manager POST:imageUrl parameters:muDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:imageData name:@"file"fileName:fileName mimeType:@"image/jpeg"];

    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//        NSLog(@"%@",dic);
    
        NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        //转变其中的内容
        str=[str stringByReplacingOccurrencesOfString:@"," withString:@",\n"];
        str=[str stringByReplacingOccurrencesOfString:@"{" withString:@"{\n"];
        str=[str stringByReplacingOccurrencesOfString:@"}" withString:@"\n}"];
        NSLog(@"%@",str);
        tempDelegate.userModel.headimg = [NSString stringWithFormat:@"%@%@",rootUrl,dic[@"content"]];
        AlertView *view = [[AlertView alloc] initWithTitle:@"上传头像成功" style:kAlertViewStyleSuccess showTime:kAlerViewShowTimeOneSecond];
        [view showInView:self.view];
        
        tempDelegate.meIconImage = iconImage;
        self.iconView.image = iconImage;

        if ([self.delegate respondsToSelector:@selector(changeIconImage)]) {
            [self.delegate changeIconImage];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        AlertView *view = [[AlertView alloc] initWithTitle:@"上传头像失败" style:kAlertViewStyleFail showTime:kAlerViewShowTimeOneSecond];
        [view showInView:self.view];
        
    }];
    
    
    //[self saveImage:image WithName:@"userAvatar"];
    
}

-(void)setupNav
{
    //导航栏透明处理
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"bt_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClick:)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    self.title = @"我的资料";
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
}
-(void)backBtnClick:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)setupMineInfoView
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64) style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    tableView.delegate = self;
    self.tableView = tableView;
    [self.view addSubview:tableView];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"mineCell"];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 8;
    }else
        return 4;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mineCell" forIndexPath:indexPath];
    UIImage *dataEnter = [UIImage imageNamed:@"data_icon_enter"];
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
            {
            cell.textLabel.text = self.mineInfoArr[indexPath.row][@"type"];
                UIView *accessView = [[UIView alloc]init];
                UIImage *iconImage = [UIImage imageNamed:self.mineInfoArr[indexPath.row][@"value"]];
                accessView.width = cellHeight+dataEnter.size.width;
                accessView.height = cellHeight;
                UIImageView *iconView = [[UIImageView alloc]initWithImage:iconImage];
//                iconView.frame = CGRectMake(0, (cellHeight-iconImage.size.height)*0.5, iconImage.size.width, iconImage.size.height);
                iconView.frame = CGRectMake(0, 5, cellHeight-10, cellHeight-10);
                iconView.layer.masksToBounds = YES;
                iconView.layer.cornerRadius = iconView.width * 0.5;
                iconView.layer.borderWidth = 1.0;
                UIColor *tempColor = ZXcolor(230, 230, 230);
                iconView.layer.borderColor = tempColor.CGColor;
       
                [iconView sd_setImageWithURL:[NSURL URLWithString:self.userModel.headimg] placeholderImage:[UIImage imageNamed:@"login_icon_photo"]];
                self.iconView = iconView;
                
                UIImageView *changeTag = [[UIImageView alloc]initWithImage:dataEnter];
                changeTag.frame = CGRectMake(CGRectGetMaxX(iconView.frame)+10, (cellHeight-dataEnter.size.height)*0.5, dataEnter.size.width, dataEnter.size.height);
                [accessView addSubview:iconView];
                [accessView addSubview:changeTag];

            cell.accessoryView = accessView;
            }else
            {
                cell.textLabel.text = self.mineInfoArr[indexPath.row][@"type"];
                
                UIView *accessView = [[UIView alloc]init];
                accessView.height = cellHeight;
                accessView.width = labelWidth;
                UILabel *label = [[UILabel alloc]init];
                label.textAlignment = NSTextAlignmentRight;
                label.text = self.mineInfoArr[indexPath.row][@"value"];
                label.font = [UIFont systemFontOfSize:15];
                label.textColor = ZXcolor(150, 150, 153);
                label.frame = CGRectMake(0, 0, labelWidth-dataEnter.size.width-10, cellHeight);
                label.adjustsFontSizeToFitWidth = YES;
                if (indexPath.row != 1) {
                
                UIImageView *changeTag = [[UIImageView alloc]initWithImage:dataEnter];
                changeTag.frame = CGRectMake(CGRectGetMaxX(label.frame)+10,(cellHeight-dataEnter.size.height)*0.5, dataEnter.size.width, dataEnter.size.height);
                    [accessView addSubview:changeTag];
                }
                [accessView addSubview:label];
                cell.accessoryView = accessView;;
                
            }
    }else{
        cell.textLabel.text = self.companyInfoArr[indexPath.row][@"type"];
        UILabel *label = [[UILabel alloc]init];
        label.textAlignment = NSTextAlignmentRight;
        label.text = self.companyInfoArr[indexPath.row][@"value"];
        label.width = labelWidth;
        label.height = cellHeight;
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = ZXcolor(150, 150, 153);
        label.adjustsFontSizeToFitWidth = YES;
        cell.accessoryView = label;
    }
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"个人资料";
    }else
        return @"企业资料";
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10*SCREEN_SCALE_H;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSMutableDictionary *Mdic = [NSMutableDictionary dictionaryWithDictionary:self.mineInfoArr[indexPath.row]];
    AlertView *alterView = [[AlertView alloc]initWithTitle:Mdic[@"type"] target:self buttonsTitle:@[@"确定",@"取消"]];
    alterView.indexPath = indexPath;
    

    if (indexPath.section != 0 ) {
        return;
    }else if (indexPath.row == 1){
    
        return;
    }else if (indexPath.row == 0){
        //点击了修改头像
        
        if (self.alertController != nil) {
            [self presentViewController:self.alertController animated:YES completion:^{
    
            }];
        }else{
            [self setupCameraViewBelow8];

        }

//
    }else if(indexPath.row == 7){
        
        //修改生日
        
        AlertView *datePicker = [[AlertView alloc] initWithPopBirthdatePickerWithtarget:self];
        datePicker.indexPath = indexPath;
        [datePicker showInView:self.view];
    }else{

        if ([Mdic[@"type"] isEqualToString:@"邮箱"]) {
            alterView.keyboardType = UIKeyboardTypeEmailAddress;
        }else if ([Mdic[@"type"] isEqualToString:@"姓名"]){
            alterView.keyboardType = UIKeyboardTypeDefault;
            
        }else if([Mdic[@"type"] isEqualToString:@"微信号"]){
            alterView.keyboardType = UIKeyboardTypeDefault;
        }
        else{
            alterView.keyboardType = UIKeyboardTypeNumberPad;
        }
        [alterView showInView:self.view];
    
    }

    }

//}
/**
 *  按钮点击事件
 *  buttonIndex是点击的按钮tag值
 *  str是输入框的值（现在只是一个输入框）
 **/
- (void)alertView:(AlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex withString:(NSString *)str
{
    if (str.length==0) {
        return;
    }
    
    AppDelegate *tempDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UserInfoModel *userModel = tempDelegate.userModel;
    
    if (buttonIndex == 1) {
        return;
    }
    NSMutableDictionary *Mdic = [NSMutableDictionary dictionaryWithDictionary:self.mineInfoArr[alertView.indexPath.row]];
    [Mdic setValue:str forKey:@"value"];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSString stringWithFormat:@"%ld",(long)userModel.userid] forKey:@"itemid"];
    
    switch (alertView.indexPath.row) {
//        case 0://头像
//            
//            break;
        case 1://姓名
            userModel.truename = str;
            [params setObject:str forKey:@"truename"];
            
            break;
        case 2://手机
            userModel.mobile = [str integerValue];
            [params setObject:str forKey:@"mobile"];
            break;
        case 3://电话
            userModel.telphone = [str integerValue];
            [params setObject:str forKey:@"telphone"];
            break;
        case 4://微信号
            userModel.wxnumber = str;
            [params setObject:str forKey:@"wxnumber"];
            break;
        case 5://邮箱
            if ([self validateEmail:str]) {
                userModel.email = str;
                [params setObject:str forKey:@"emai"];
            }else{
                AlertView *view = [[AlertView alloc] initWithTitle:@"邮箱地址不合法" style:kAlertViewStyleFail showTime:kAlerViewShowTimeOneSecond];
                view.delegate = self;
                [view showInView:self.view];
                return;

            }
            
            break;
            
        case 6://性别
            userModel.sex = [str intValue];
            [params setObject:str forKey:@"sex"];
            if ([str isEqualToString:@"0"]) {
                [Mdic setValue:@"男" forKey:@"value"];
            }else{
                [Mdic setValue:@"女" forKey:@"value"];
            }
            break;
            
        case 7://生日
            userModel.brithday = str;
            [params setObject:str forKey:@"brithday"];
            break;
            
        default:
            break;
    }

//    [self.mineInfoArr replaceObjectAtIndex:alertView.indexPath.row withObject:Mdic];
//    
//    [self.tableView reloadData];
    
//    //保存内存中的usermodel
//    tempDelegate.userModel = userModel;
    
    //TO DO异步进行网络数据更新
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *url = [NSString stringWithFormat:@"%@/index.php",rootUrl];
 
    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
    [muDic setObject:@"Interface" forKey:@"g"];
    [muDic setObject:@"New" forKey:@"m"];
    [muDic setObject:@"member_amend" forKey:@"a"];
    
    [muDic setObject:[self dictionaryToJson:params] forKey:@"data"];
    
    [manager GET:url parameters:muDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSInteger result = [dic[@"result"]intValue];
        if (result == 1) {
            NSLog(@"修改成功");
            AlertView *view = [[AlertView alloc] initWithTitle:@"修改成功" style:kAlertViewStyleSuccess showTime:kAlerViewShowTimeOneSecond];
            view.delegate = self;
            [view showInView:self.view];
            //保存内存中的usermodel
            tempDelegate.userModel = userModel;
            [self.mineInfoArr replaceObjectAtIndex:alertView.indexPath.row withObject:Mdic];
            
            [self.tableView reloadData];

        }else if (result == -1){
            NSLog(@"数据为空");
            AlertView *view = [[AlertView alloc] initWithTitle:@"数据为空" style:kAlertViewStyleFail showTime:kAlerViewShowTimeOneSecond];
            view.delegate = self;
            [view showInView:self.view];
        }else{
            NSLog(@"修改失败");
            AlertView *view = [[AlertView alloc] initWithTitle:@"修改失败" style:kAlertViewStyleFail showTime:kAlerViewShowTimeOneSecond];
            view.delegate = self;
            [view showInView:self.view];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        AlertView *view = [[AlertView alloc] initWithTitle:@"修改失败" style:kAlertViewStyleFail showTime:kAlerViewShowTimeOneSecond];
        view.delegate = self;
        [view showInView:self.view];
    }];
}
//判断邮箱地址是否合法
- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}
//字典转json字符串
- (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}
/**
 *  提示窗消失事件
 **/
- (void)alertViewtimeFinishedToDo
{
    
}
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

@end
