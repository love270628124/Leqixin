//
//  CheckVistorInfoController.m
//  乐企信
//
//  Created by 震霄 张 on 16/3/25.
//  Copyright © 2016年 SDW. All rights reserved.
//

#import "CheckVistorInfoController.h"
#import "VistorInfoTableViewCell.h"
#import "RecordTableViewCell.h"


#define headViewHeight 60
#define cellHeight 60
#define recordCellHeight 40


@interface CheckVistorInfoController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,weak)UITableView *recordTableView;

@property (nonatomic,strong)NSArray *recordArr;//咨询记录
@end

@implementation CheckVistorInfoController


-(NSArray *)recordArr
{
    if (_recordArr == nil) {
        _recordArr = @[@{@"time":@"2016年10月13号",@"status":@"首次访问"},
                       @{@"time":@"2016年10月20号",@"status":@"二次访问"}];
    }
    return _recordArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setupBaseInfo];
    [self setupRecord];
    
}
//设置导航界面
-(void)setupNav
{
    self.view.backgroundColor =[UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1.0];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 64)];
    bgView.backgroundColor =[UIColor colorWithRed:10/255.0 green:212/255.0 blue:134/255.0 alpha:1.0];
    [self.view addSubview:bgView];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"btn_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnOnClick:)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    self.title = @"访客详情";

}
//加载访客基本信息界面
-(void)setupBaseInfo
{
    UITableView *tableView = [[UITableView alloc]init];
    tableView.x = 0;
    tableView.y = 64;
    tableView.width = SCREEN_W;
    tableView.height = cellHeight*SCREEN_SCALE_H * 5;
    [self.view addSubview:tableView];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.tag = baseInfoCellTag;
    self.tableView = tableView;
    [self.tableView registerClass:[VistorInfoTableViewCell class] forCellReuseIdentifier:@"vistorInfoCell"];
    self.tableView.scrollEnabled = NO;
    tableView.separatorInset = UIEdgeInsetsMake(0,60, 0, 0);
}

//加载访问记录界面
-(void)setupRecord
{
    UITableView *recordTableView = [[UITableView alloc]init];
    recordTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    recordTableView.x = 0;
    recordTableView.y = CGRectGetMaxY(self.tableView.frame)+10;
    recordTableView.width = SCREEN_W;
    recordTableView.height = recordCellHeight * self.recordArr.count+headViewHeight;
    self.recordTableView = recordTableView;
    recordTableView.tag =recordCellTag;
    recordTableView.dataSource = self;
    recordTableView.delegate = self;
    [recordTableView registerClass:[RecordTableViewCell class] forCellReuseIdentifier:@"recordCell"];
    [self.view addSubview:recordTableView];
    //recordTableView.scrollEnabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)backBtnOnClick:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == baseInfoCellTag) {
        return 5;
    }else if (tableView.tag == recordCellTag){
        return self.recordArr.count;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView.tag == recordCellTag) {
        RecordTableViewCell *cell = [RecordTableViewCell cellWithTableView:tableView indexpath:indexPath];
        NSDictionary *recordDic = self.recordArr[indexPath.row];
        cell.timeLabel.text =recordDic[@"time"];
        cell.statusLabel.text = recordDic[@"status"];
        return cell;
    }else{
        VistorInfoTableViewCell *cell = [VistorInfoTableViewCell cellWithTableView:tableView indexpath:indexPath];
        if (indexPath.row == 0) {
            cell.iconView.image = [UIImage imageNamed:@"icon_customer"];
            cell.infoLabel.text = @"客户级别";
            cell.describLabel.text = @"二次咨询";
        }else if (indexPath.row == 1){
            cell.iconView.image = [UIImage imageNamed:@"icon_source"];
            cell.infoLabel.text = @"访客来源";
            cell.describLabel.text = @"百度搜索";
        }else if (indexPath.row == 2){
            cell.iconView.image = [UIImage imageNamed:@"icon_keyword"];
            cell.infoLabel.text = @"关键词";
            cell.describLabel.text = @"乐企信";
        }else if (indexPath.row == 3){
            cell.iconView.image = [UIImage imageNamed:@"icon_map"];
            cell.infoLabel.text = @"来源地区";
            cell.describLabel.text = @"苏州";
        }else if (indexPath.row == 4){
            cell.iconView.image = [UIImage imageNamed:@"icon_ip"];
            cell.infoLabel.text = @"访客IP";
            cell.describLabel.text = @"190.140.1.1";
        }
        cell.userInteractionEnabled = NO;
        return cell;

    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == baseInfoCellTag) {
        return cellHeight * SCREEN_SCALE_H;

    }else if(tableView.tag == recordCellTag){
        return recordCellHeight * SCREEN_SCALE_H;
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView.tag == recordCellTag) {
        UIView *headView = [[UIView alloc]init];
        headView.backgroundColor  = [UIColor whiteColor];
        UIImageView *iconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_consult"]];
        iconView.x = 26 * SCREEN_SCALE_W;
        iconView.width = 30 * SCREEN_SCALE_W;
        iconView.height = 30 * SCREEN_SCALE_W;
        iconView.y = (headViewHeight - 30)*SCREEN_SCALE_H/2;
        [headView addSubview:iconView];
        
        UILabel *label = [[UILabel alloc]init];
        label.x = CGRectGetMaxX(iconView.frame)+16*SCREEN_SCALE_W;
        label.y = 10 * SCREEN_SCALE_H;
        label.width = 100 * SCREEN_SCALE_W;
        label.height = 40*SCREEN_SCALE_H;
        label.font = [UIFont systemFontOfSize:17];
        label.text = @"咨询记录";
        [headView addSubview:label];
        return headView;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView.tag == recordCellTag) {
        return headViewHeight;
    }else
        return 0;
}
@end
