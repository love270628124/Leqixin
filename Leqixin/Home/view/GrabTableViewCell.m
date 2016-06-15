//
//  GrabTableViewCell.m
//  乐企信
//
//  Created by 震霄 张 on 16/3/21.
//  Copyright © 2016年 SDW. All rights reserved.
//

#import "GrabTableViewCell.h"
#import "ChatViewController.h"

#define padding 10

@interface GrabTableViewCell()
@property (nonatomic,weak)UIImageView *iconView;
@property (nonatomic,weak)UILabel *locationLabel;
@property (nonatomic,weak)UIButton *grabBtn;

@end
@implementation GrabTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //界面加载
        [self setGrabCellView];
        
    }
    return self;
}
+(id)cellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity = @"grabCell";
    
    GrabTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity forIndexPath:indexPath];
    return cell;
    
}
-(void)setGrabCellView
{
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 8*SCREEN_SCALE_H)];
    [self.contentView addSubview:lineView];
    lineView.backgroundColor = ZXcolor(235, 235, 244);
    self.lineView = lineView;
    
    UIImageView *iconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_visitor_blue"]];
    iconView.x = 26 * SCREEN_SCALE_W;
    iconView.y = 25 * SCREEN_SCALE_H;
    iconView.width = 30 * SCREEN_SCALE_W;
    iconView.height = 30 * SCREEN_SCALE_W;
    self.iconView = iconView;
    [self.contentView addSubview:iconView];
    
    UILabel *locationLabel = [[UILabel alloc]init];
//    locationLabel.backgroundColor = [UIColor grayColor];
    locationLabel.x = CGRectGetMaxX(iconView.frame)+padding*3;
    locationLabel.y = 15 * SCREEN_SCALE_H;
    locationLabel.width = 200 * SCREEN_SCALE_W;
    locationLabel.height = 50*SCREEN_SCALE_H;
    locationLabel.font = [UIFont systemFontOfSize:17];
    locationLabel.text = @"来自江苏苏州新访客咨询";

    self.locationLabel = locationLabel;
    [self.contentView addSubview:locationLabel];
    
    UIButton *grabBtn = [[UIButton alloc]init];
    grabBtn.width = 50 * SCREEN_SCALE_W;
    grabBtn.height = grabBtn.width;
    grabBtn.x = SCREEN_W - 2*padding - grabBtn.width;
    grabBtn.y = iconView.y - 5*SCREEN_SCALE_H;
    grabBtn.tag = 1010;
    [grabBtn setImage:[UIImage imageNamed:@"icon_grap_chlick"] forState:UIControlStateNormal];
    
    self.grabBtn = grabBtn;
//    [grabBtn addTarget:self action:@selector(grabBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:grabBtn];
    

    
}

//点击抢单按钮
-(void)grabBtnClick:(UIButton *)btn
{
    [btn setImage:[UIImage imageNamed:@"icon_grap_default"] forState:UIControlStateNormal];
    
   // btn.enabled = NO;

}
-(void)setModel:(NewConsultModel *)model
{
    _model = model;
    self.locationLabel.text = [NSString stringWithFormat:@"来自%@的咨询",model.country];
    if ([self.model.workerid integerValue]>0) {
        self.locationLabel.textColor = [UIColor grayColor];
        self.iconView.image = [UIImage imageNamed:@"icon_visitor_gray"];
    }else{
        self.locationLabel.textColor = [UIColor blackColor];
        self.iconView.image = [UIImage imageNamed:@"icon_visitor_blue"];
    }
    if ([self.model.workerid integerValue]>0) {
        self.grabBtn.enabled = NO;
        [self.grabBtn setImage:[UIImage imageNamed:@"icon_grap_default"] forState:UIControlStateNormal];

    }else{
        self.grabBtn.enabled = YES;
        [self.grabBtn setImage:[UIImage imageNamed:@"icon_grap_chlick"] forState:UIControlStateNormal];

    }
}
@end
