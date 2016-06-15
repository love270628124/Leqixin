//
//  VistorInfoTableViewCell.m
//  乐企信
//
//  Created by 震霄 张 on 16/3/25.
//  Copyright © 2016年 SDW. All rights reserved.
//

#import "VistorInfoTableViewCell.h"

#define cellHeight 60


@interface VistorInfoTableViewCell()


@end
@implementation VistorInfoTableViewCell

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
        [self setVistorInfoView];
    }
    return self;
}
+(id)cellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity=@"vistorInfoCell";
    
    VistorInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity forIndexPath:indexPath];
    return cell;
    
}
-(void)setVistorInfoView
{
    UIImageView *iconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_visitor_blue"]];
    iconView.x = 26 * SCREEN_SCALE_W;
    iconView.width = 25*SCREEN_SCALE_H;
    iconView.height = 25*SCREEN_SCALE_H;
    iconView.y = (cellHeight - iconView.height)*0.5;
    [self.contentView addSubview:iconView];
    self.iconView = iconView;
    
    UILabel *infoLabel = [[UILabel alloc]init];
    //    locationLabel.backgroundColor = [UIColor grayColor];
    infoLabel.x = CGRectGetMaxX(iconView.frame)+16*SCREEN_SCALE_W;
    infoLabel.width = 100 * SCREEN_SCALE_W;
    infoLabel.height = 40*SCREEN_SCALE_H;
    infoLabel.y = (cellHeight - infoLabel.height)*0.5;
    infoLabel.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:infoLabel];
    self.infoLabel = infoLabel;
    
    UILabel *descirbLabel = [[UILabel alloc]init];
    descirbLabel.textColor = [UIColor grayColor];
    descirbLabel.width = 100*SCREEN_SCALE_W;
    descirbLabel.height = infoLabel.height;
    descirbLabel.x = SCREEN_W - descirbLabel.width - 10*SCREEN_SCALE_W;
    descirbLabel.y = infoLabel.y;
    [self.contentView addSubview:descirbLabel];
    self.describLabel = descirbLabel;
    
   
}

@end
