//
//  homeTableViewCell.m
//  乐企信
//
//  Created by 震霄 张 on 16/3/16.
//  Copyright © 2016年 SDW. All rights reserved.
//

#import "HomeTableViewCell.h"


@interface HomeTableViewCell()
@property (nonatomic,weak)UIImageView *iconView;
@property (nonatomic,weak)UILabel *remindLabel;
@property (nonatomic,weak)UIButton *remindBtn;
@end

@implementation HomeTableViewCell

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
        [self setHomeCellView];
        
    }
    return self;
}
+(id)cellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity = @"homeCell";
    
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity forIndexPath:indexPath];
    
    return cell;
    
}
-(void)setHomeCellView
{

    UIImageView *iconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_btn_zixun"]];
    iconView.x = 26 * SCREEN_SCALE_W;
    iconView.y =16 * SCREEN_SCALE_H;
    iconView.width = 30 * SCREEN_SCALE_W;
    iconView.height = 30 * SCREEN_SCALE_W;
    self.iconView = iconView;
    [self.contentView addSubview:iconView];
    
    UILabel *remindLabel = [[UILabel alloc]init];
   // remindLabel.backgroundColor = [UIColor redColor];
    remindLabel.x = CGRectGetMaxX(iconView.frame)+44 * SCREEN_SCALE_W;
    remindLabel.y = 10 * SCREEN_SCALE_H;
    remindLabel.width = 230 * SCREEN_SCALE_W;
    remindLabel.height = 40 * SCREEN_SCALE_H;
    remindLabel.font = [UIFont systemFontOfSize:18];
    remindLabel.text = @"有新的客户咨询";
    remindLabel.adjustsFontSizeToFitWidth = YES;
    self.remindLabel = remindLabel;
    [self.contentView addSubview:remindLabel];
    
    UIButton *remindBtn = [[UIButton alloc]init];
    
    [remindBtn setBackgroundImage:[UIImage imageNamed:@"home_btn_tishi"] forState:UIControlStateNormal];
    remindBtn.width = 35 * SCREEN_SCALE_W;
    remindBtn.height = 35 * SCREEN_SCALE_W;
    
    remindBtn.x = SCREEN_W - remindBtn.width - 35 * SCREEN_SCALE_W;
    remindBtn.y = iconView.centerY - 0.5 * remindBtn.height;
    [remindBtn setTitle:@"5" forState:UIControlStateNormal];
    [self.contentView addSubview:remindBtn];
    self.remindBtn = remindBtn;

}

-(void)setIconNameStr:(NSString *)iconNameStr
{
    _iconNameStr = iconNameStr;
    _iconView.image = [UIImage imageNamed:iconNameStr];
}
-(void)setRemindInfoStr:(NSString *)remindInfoStr
{
    _remindInfoStr = remindInfoStr;
    _remindLabel.text = remindInfoStr;
}
-(void)setRemindNumStr:(NSString *)remindNumStr
{
    _remindNumStr = remindNumStr;
    NSInteger num = [remindNumStr intValue];
    if (num < 1) {
        
        UIImage *noRemindImage = [UIImage imageNamed:@"home_btn_jiantou"];
//        NSInteger leftCapWidth = noRemindImage.size.width * 0.5f;
//        NSInteger topCapHeight = noRemindImage.size.height * 0.5f;
//        noRemindImage = [noRemindImage stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
        _remindBtn.width = noRemindImage.size.width;
        _remindBtn.height = noRemindImage.size.height;
        _remindBtn.y = self.iconView.centerY - 0.5 * _remindBtn.height;

        [_remindBtn setBackgroundImage:noRemindImage forState:UIControlStateNormal];
        [_remindBtn setTitle:@"" forState:UIControlStateNormal];
        
    }else{
        UIImage *circleImage = [UIImage imageNamed:@"home_btn_tishi"];
        _remindBtn.width = circleImage.size.width*1.5;
        _remindBtn.height = circleImage.size.height*1.5;
        _remindBtn.y = self.iconView.centerY - 0.5 * _remindBtn.height;

        [_remindBtn setBackgroundImage:circleImage forState:UIControlStateNormal];
        [_remindBtn setTitle:remindNumStr forState:UIControlStateNormal];
    }
}
@end
