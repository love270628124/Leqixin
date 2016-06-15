//
//  ContactInfoController.m
//  乐企信
//
//  Created by 震霄 张 on 16/5/19.
//  Copyright © 2016年 SDW. All rights reserved.
//

#import "ContactInfoController.h"
#import "ContactModel.h"
#import "UIImageView+WebCache.h"

#define cellHeight 44*SCREEN_SCALE_H

@interface ContactInfoController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *showDataArr;
@end

@implementation ContactInfoController

-(NSMutableArray *)showDataArr
{
    
    if (_showDataArr == nil) {
        
        _showDataArr = [NSMutableArray array];
//        NSDictionary *dicIcon =  @{@"type":@"头像",@"value":@"pic_header"};
        NSMutableDictionary *dicIcon = [NSMutableDictionary dictionary];
        [dicIcon setObject:@"头像" forKey:@"type"];
        if (self.model.img != nil) {
            [dicIcon setObject:[NSString stringWithFormat:@"%@%@",rootUrl,self.model.img] forKey:@"value"];
        }else{
            [dicIcon setObject:[NSString stringWithFormat:@"%@",rootUrl] forKey:@"value"];
        }
        
        NSMutableDictionary *dicName =[NSMutableDictionary dictionary];
        [dicName setObject:@"姓名" forKey:@"type"];
        if (self.model.name == nil) {
            self.model.name = @"";
        }
        [dicName setObject:self.model.name forKey:@"value"];
        
        NSMutableDictionary *dicDepart =[NSMutableDictionary dictionary];
        [dicDepart setObject:@"部门" forKey:@"type"];
        if (self.model.department == nil) {
            self.model.department = @"";
        }
        [dicDepart setObject:self.model.department forKey:@"value"];
        
        NSMutableDictionary *dicLoction =[NSMutableDictionary dictionary];
        [dicLoction setObject:@"职位" forKey:@"type"];
        if (self.model.position == nil) {
            self.model.position = @"";
        }
        [dicLoction setObject:self.model.position forKey:@"value"];
        
        NSMutableDictionary *dicTel =[NSMutableDictionary dictionary];
        [dicTel setObject:@"手机" forKey:@"type"];
        if (self.model.mobile == nil) {
            self.model.mobile = @"";
        }
        [dicTel setObject:self.model.mobile forKey:@"value"];
        
        
        NSMutableDictionary *dicMob =[NSMutableDictionary dictionary];
        [dicMob setObject:@"电话" forKey:@"type"];
        if (self.model.telphone == nil) {
            self.model.telphone = @"";
        }
        [dicMob setObject:self.model.telphone forKey:@"value"];
        
        NSMutableDictionary *dicEmail =[NSMutableDictionary dictionary];
        [dicEmail setObject:@"邮箱" forKey:@"type"];
        if (self.model.email == nil) {
            self.model.email = @"";
        }
        [dicEmail setObject:self.model.email forKey:@"value"];
        

        NSMutableDictionary *dicBirth =[NSMutableDictionary dictionary];
        [dicBirth setObject:@"生日" forKey:@"type"];
        if (self.model.brithday == nil) {
            self.model.brithday = @"";
        }
        [dicBirth setObject:self.model.brithday forKey:@"value"];
        
        NSMutableDictionary *dicEntry =[NSMutableDictionary dictionary];
        [dicEntry setObject:@"入职时间" forKey:@"type"];
        if (self.model.entry == nil) {
            self.model.entry = @"";
        }
        [dicEntry setObject:self.model.entry forKey:@"value"];
        
        [_showDataArr addObject:dicIcon];
        [_showDataArr addObject:dicName];
        [_showDataArr addObject:dicDepart];
        [_showDataArr addObject:dicLoction];
        [_showDataArr addObject:dicTel];
        [_showDataArr addObject:dicMob];
        [_showDataArr addObject:dicEmail];
        [_showDataArr addObject:dicBirth];
        [_showDataArr addObject:dicEntry];
        
    }
    return _showDataArr;
}

-(void)setupNav
{
    self.view.backgroundColor =[UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1.0];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"bt_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClick:)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    
    self.title = @"详细资料";
    
}
-(void)backBtnClick:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setupContactInfoView];
}
-(void)setupContactInfoView
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, cellHeight * self.showDataArr.count + 30*SCREEN_SCALE_H)];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"contactInfoCell"];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
//    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.scrollEnabled = NO;
    [self.view addSubview:tableView];

    self.tableView = tableView;

    self.automaticallyAdjustsScrollViewInsets = false;//去掉顶部空白
    
    UIButton *msgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    msgBtn.width = SCREEN_W*0.5;
    msgBtn.height = 48*SCREEN_SCALE_H;
    msgBtn.x = 0;
    msgBtn.y = SCREEN_H - msgBtn.height-64;
    [msgBtn setBackgroundImage:[UIImage imageNamed:@"daohaglan_bg"] forState:UIControlStateNormal];
    [msgBtn setImage:[UIImage imageNamed:@"ziliao_duanxin"] forState:UIControlStateNormal];
    [msgBtn setTitle:@"发短信" forState:UIControlStateNormal];
    [msgBtn addTarget:self action:@selector(msgBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [msgBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    [self.view addSubview:msgBtn];
    
//    UIImageView *lineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1, 48*SCREEN_SCALE_H)];
//    [self.view addSubview:lineImgView];
    
    UIButton *telBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    telBtn.width = SCREEN_W*0.5;
    telBtn.height = 48*SCREEN_SCALE_H;
    telBtn.x = CGRectGetMaxX(msgBtn.frame);
    telBtn.y = SCREEN_H - telBtn.height-64;
    [telBtn setBackgroundImage:[UIImage imageNamed:@"daohaglan_bg"] forState:UIControlStateNormal];
    [telBtn setImage:[UIImage imageNamed:@"ziliao_dianhua"] forState:UIControlStateNormal];
    [telBtn setTitle:@"打电话" forState:UIControlStateNormal];
    [telBtn addTarget:self action:@selector(telBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [telBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    [self.view addSubview:telBtn];

}
//发短信
-(void)msgBtnClick
{
    //self.model.mobile
    NSString *smsString = [NSString stringWithFormat:@"sms://%@",self.model.mobile];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:smsString]];
}
//打电话
-(void)telBtnClick
{
    //self.model.mobile
    NSString *telString = [NSString stringWithFormat:@"tel://%@",self.model.mobile];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telString]];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.showDataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell  =[tableView dequeueReusableCellWithIdentifier:@"contactInfoCell" forIndexPath:indexPath];
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactInfoCell"];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"contactInfoCell"];
//    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0) {
        cell.textLabel.text = [self.showDataArr[indexPath.row] valueForKey:@"type"];
        UIImage *iconImage = [UIImage imageNamed:@"icon_moren-tx"];
        UIImageView *iconView = [[UIImageView alloc]initWithImage:iconImage];
        
        NSString *imageStr = [self.showDataArr[indexPath.row] valueForKey:@"value"];
        [iconView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:iconImage];
        
        iconView.width = 34*SCREEN_SCALE_W;
        iconView.height = iconView.width;
        iconView.layer.masksToBounds = YES;
        iconView.layer.cornerRadius = iconView.width * 0.5;
        iconView.layer.borderWidth = 1.0;
        UIColor *tempColor = ZXcolor(230, 230, 230);
        iconView.layer.borderColor = tempColor.CGColor;
        cell.accessoryView = iconView;

    }else{
        cell.textLabel.text = [self.showDataArr[indexPath.row] valueForKey:@"type"];
        UILabel *label = [[UILabel alloc]init];
        label.textAlignment = NSTextAlignmentRight;
        label.text = [self.showDataArr[indexPath.row] valueForKey:@"value"];
        
        label.width = 150*SCREEN_SCALE_W;
        label.height = 34*SCREEN_SCALE_H;
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = ZXcolor(150, 150, 153);
        label.adjustsFontSizeToFitWidth = YES;
        cell.accessoryView = label;
    }
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, cellHeight - 1, cell.contentView.width, 1)];
    lineView.backgroundColor = ZXcolor(227, 227, 229);
    [cell addSubview:lineView];
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 30*SCREEN_SCALE_H)];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(14*SCREEN_SCALE_W, 0, SCREEN_W, 30*SCREEN_SCALE_H)];
    titleLabel.text = @"个人资料";
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = ZXcolor(150, 150, 153);
    headView.backgroundColor = ZXcolor(245, 245, 249);
    [headView addSubview:titleLabel];
    return headView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30*SCREEN_SCALE_H;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;
}
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setModel:(ContactModel *)model
{
    _model = model;
    
}
@end
