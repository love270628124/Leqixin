//
//  CompanyWebViewController.m
//  乐企信
//
//  Created by Raija on 16/5/27.
//  Copyright © 2016年 SDW. All rights reserved.
//

#import "CompanyWebViewController.h"
#import "ImgAndNameAndTitleTVCell.h"
#import "MineWebViewController.h"
#import "ContactUsController.h"
#import "AppDelegate.h"

@interface CompanyWebViewController () <UITableViewDelegate,UITableViewDataSource> {
    
    NSArray *iconArray;
    NSArray *nameArray;
    NSArray *dataKeyArray;
}

@property (nonatomic, strong) UITableView *webListTableView;
@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) NSMutableArray *dataMArray;

@end

@implementation CompanyWebViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:10.];
    
    [self setNavigation];
    [self setInitionData];
    [self requestDataFromServer];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.webListTableView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
}

#pragma mark - tableView 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [nameArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"webListCell";
    ImgAndNameAndTitleTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        
        cell = [[ImgAndNameAndTitleTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//        cell.contentView.frame = CGRectMake(0, 0, CGRectGetWidth(self.webListTableView.frame), 0);
//        cell.iconString = (NSString *)iconArray[indexPath.row];
//        cell.nameString = (NSString *)nameArray[indexPath.row];
        
//        if (indexPath.row == self.dataMArray.count -1) {
//            cell.isNotShowRightImg = YES;
//        }
    }
    
    cell.iconString = (NSString *)iconArray[indexPath.row];
    cell.nameString = (NSString *)nameArray[indexPath.row];
    cell.detailString = self.dataMArray[indexPath.row];
    if (indexPath.row == self.dataMArray.count -1 && ! [cell.detailString isEqualToString:@"暂无"]) {
        cell.isNotShowRightImg = YES;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ImgAndNameAndTitleTVCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ( ![cell.nameString isEqualToString:@"公众号"] && ![cell.detailString isEqualToString:@"暂无"]) {
        //如果有网页链接，并且不是公众号，跳到下页显示网页
        MineWebViewController *webView = [[MineWebViewController alloc] init];
        webView.urlString = cell.detailString;
        
        [self.navigationController pushViewController:webView
                                             animated:YES];
        
    } else if ([cell.detailString isEqualToString:@"暂无"]) {
        //如果是暂无，跳转到联系我们页
        ContactUsController *contact = [[ContactUsController alloc] init];
        
        [self.navigationController pushViewController:contact animated:YES];
    }
    
}

- (void)setNavigation {
    
    self.navigationItem.title = @"我的网站";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"bt_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClick:)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    
}

-(void)backBtnClick:(UIButton *)btn {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setInitionData {
    
    iconArray = @[@"web_pczhan",@"web_shoujizhan",@"web_app",@"web_b2b",@"web_gongzhonghao"];
    nameArray = @[@"PC站",@"手机站",@"企业APP",@"B2B平台",@"公众号"];
    dataKeyArray  = @[@"domain",@"wapdomain",@"qyapp",@"B2B",@"wx"];
}

- (void)requestDataFromServer {
    
        UserInfoModel *userModel = self.appDelegate.userModel;
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:[NSString stringWithFormat:@"%ld",(long)userModel.companyid] forKey:@"userid"];
        
        NSString *changePswdUrl = [NSString stringWithFormat:@"%@/index.php",rootUrl];
        NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
        [muDic setObject:@"Interface" forKey:@"g"];
        [muDic setObject:@"New" forKey:@"m"];
        [muDic setObject:@"mysite" forKey:@"a"];
        
        [muDic setObject:[self dictionaryToJson:params] forKey:@"data"];
        [manager GET:changePswdUrl parameters:muDic progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            NSLog(@"我的网站数据请求结果:%@",dic);
            
            if ([dic[@"result"] isEqualToString:@"200"]) {
                //正确数据
                if (self.dataMArray.count != 0) {
                    [self.dataMArray removeAllObjects];
                }
                
                for (NSString *dataKey in dataKeyArray) {

                    if ([dic[dataKey] isEqualToString:@"null"]) {

                        [self.dataMArray addObject:@"暂无"];
                    } else {
                        
                        [self.dataMArray addObject:dic[dataKey]];
                        
                    }
                }
//                NSLog(@"%@",self.dataMArray);
                
                [self.webListTableView reloadData];
                
            } else {
                //错误数据
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"我的网站数据请求异常:%@",error);
            AlertView *showView = [[AlertView alloc]initWithTitle:@"网络异常" style:kAlertViewStyleFail showTime:kAlerViewShowTimeOneSecond];
            [showView showInView:self.view];
        }];

}

//字典转json字符串
- (NSString*)dictionaryToJson:(NSDictionary *)dic {
    
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (UITableView *)webListTableView {
    
    if (_webListTableView == nil) {
        
        _webListTableView = [[UITableView alloc] init];
        _webListTableView.delegate = self;
        _webListTableView.dataSource = self;
        _webListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _webListTableView.scrollEnabled = NO;
        _webListTableView.backgroundColor = [UIColor clearColor];
        _webListTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:_webListTableView];
    }
    
    return _webListTableView;
}

- (NSMutableArray *)dataMArray {
    
    if (_dataMArray == nil) {
        
        _dataMArray = [NSMutableArray arrayWithObjects:@"暂无",@"暂无",@"暂无",@"暂无",@"暂无", nil];
    }
    
    return _dataMArray;
}

- (AppDelegate *)appDelegate {
    
    if (_appDelegate == nil) {
        
        _appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    }
    
    return _appDelegate;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
