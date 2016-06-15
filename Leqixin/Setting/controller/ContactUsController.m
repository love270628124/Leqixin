//
//  ContactUsController.m
//  乐企信
//
//  Created by 震霄 张 on 16/5/13.
//  Copyright © 2016年 SDW. All rights reserved.
//

#import "ContactUsController.h"
#import "ContactTableViewCell.h"

#define cellHeight 50*SCREEN_SCALE_H

@interface ContactUsController ()<UITableViewDataSource,UITableViewDelegate,AlertViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray *dataArr;
@end

@implementation ContactUsController
-(NSArray *)dataArr
{
    if (_dataArr == nil) {
//        _dataArr = @[@"客服QQ：3054999080",@"联系热线：0512-68030065(8:30-18:00)",@"我们官网：www.leqixin.cc"];
        _dataArr = @[@{@"key":@"客服QQ：",@"value":@"3054999080"},
                     @{@"key":@"联系热线：",@"value":@"0512-68030065(8:30-18:00)"},
                     @{@"key":@"我们官网：",@"value":@"www.leqixin.cc"}];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupNav];
    self.view.backgroundColor = ZXcolor(245, 245, 249);
    [self setupView];
}
-(void)setupView
{
    
    
    UIImageView *iconView = [[UIImageView alloc]init];
    iconView.width = 80 * SCREEN_SCALE_W;
    iconView.height = 80 * SCREEN_SCALE_W;
    iconView.x = (SCREEN_W - iconView.width)* 0.5;
    iconView.y = 39*SCREEN_SCALE_H;
    iconView.image = [UIImage imageNamed:@"lianxi_logoicon"];
    [self.view addSubview:iconView];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(iconView.x, CGRectGetMaxY(iconView.frame)+13*SCREEN_SCALE_H, iconView.width, 30*SCREEN_SCALE_H)];
    nameLabel.adjustsFontSizeToFitWidth = YES;
    nameLabel.font = [UIFont systemFontOfSize:17];
    nameLabel.textAlignment =  NSTextAlignmentCenter;
    nameLabel.text = @"仕脉";
//    nameLabel.backgroundColor = [UIColor redColor];
    [self.view addSubview:nameLabel];
    
    UILabel *visonLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.x, CGRectGetMaxY(nameLabel.frame)+8*SCREEN_SCALE_H, nameLabel.width, nameLabel.height)];
//    visonLabel.backgroundColor = [UIColor blueColor];
    visonLabel.textColor = ZXcolor(119, 119, 119);
    visonLabel.font = [UIFont systemFontOfSize:14];
    visonLabel.textAlignment = NSTextAlignmentCenter;
    visonLabel.adjustsFontSizeToFitWidth = YES;
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
    visonLabel.text = [NSString stringWithFormat:@"V%@",currentVersion];
    [self.view addSubview:visonLabel];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(visonLabel.frame)+33*SCREEN_SCALE_H, SCREEN_W, cellHeight * self.dataArr.count)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[ContactTableViewCell class] forCellReuseIdentifier:@"showContactCell"];
    self.tableView.scrollEnabled = NO;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    ContactTableViewCell *cell = [ContactTableViewCell cellWithTableView:tableView indexpath:indexPath];
    ShowContactModel *model = [[ShowContactModel alloc]init];
    model.showStr = [self.dataArr[indexPath.row]valueForKey:@"key"];
    model.dataStr = [self.dataArr[indexPath.row]valueForKey:@"value"];
    cell.model = model;
    return cell;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        AlertView *showView = [[AlertView alloc]initWithTitle:@"温馨提醒" content:@"是否拨打0512-68030065" target:self buttonsTitle:@[@"确定",@"取消"]];
        [showView showInView:self.view];
    }
}
-(void)alertView:(AlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex withString:(NSString *)str
{
    if (buttonIndex == 0) {
        [self openTel:@"0512-68030065"];
    }
}
-(void)setupNav
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"bt_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClick:)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    self.title = @"联系我们";
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
    // Dispose of any resources that can be recreated.
}

- (BOOL)openTel:(NSString *)tel
{
    NSString *telString = [NSString stringWithFormat:@"tel://%@",tel];
    return [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telString]];
}


@end
