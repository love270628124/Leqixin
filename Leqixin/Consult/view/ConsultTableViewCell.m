//
//  ConsultTableViewCell.m
//  乐企信
//
//  Created by 震霄 张 on 16/3/21.
//  Copyright © 2016年 SDW. All rights reserved.
//

#import "ConsultTableViewCell.h"
#import "UIImageView+WebCache.h"


#define padding 10

@interface ConsultTableViewCell()
@property (nonatomic,weak)UIImageView *iconView;//头像
@property (nonatomic,weak)UILabel *nameLabel;//名字
@property (nonatomic,weak)UILabel *locationLabel;//定位
@property (nonatomic,weak)UILabel *timeLabel;//时间
@property (nonatomic,weak)UIButton *msgBtn;

@end
@implementation ConsultTableViewCell

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
        [self setConsultCellView];
        
    }
    return self;
}
+(id)cellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity = @"consultCell";
    
    ConsultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
-(void)setConsultCellView
{
    UIImageView *iconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_moren-tx"]];
    iconView.x = 12 * SCREEN_SCALE_W;
    iconView.y =15 * SCREEN_SCALE_H;
    iconView.width = 40 * SCREEN_SCALE_W;
    iconView.height = 40 * SCREEN_SCALE_W;
    iconView.layer.cornerRadius = 5.0f;
    iconView.clipsToBounds = YES;
    self.iconView = iconView;
    [self.contentView addSubview:iconView];
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.adjustsFontSizeToFitWidth = YES;
    nameLabel.x = CGRectGetMaxX(self.iconView.frame)+padding;
    nameLabel.y = self.iconView.y;
    nameLabel.width = 50*SCREEN_SCALE_W;
    nameLabel.height = 20*SCREEN_SCALE_H;
    nameLabel.font = [UIFont systemFontOfSize:18];
//    nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];

    nameLabel.text = @"彭丽君";
    self.nameLabel = nameLabel;
    [self.contentView addSubview:nameLabel];
    
    UILabel *showLabel = [[UILabel alloc]init];
    showLabel.adjustsFontSizeToFitWidth = YES;
    showLabel.x = CGRectGetMaxX(nameLabel.frame)+5;
    showLabel.y = nameLabel.y;
    showLabel.width = nameLabel.width;
    showLabel.height = nameLabel.height;
    showLabel.font = [UIFont systemFontOfSize:15];
    showLabel.text = @"已接待";
    showLabel.textColor = ZXcolor(85, 85, 85);
    [self.contentView addSubview:showLabel];
    
    UILabel *locationLabel = [[UILabel alloc]init];
    locationLabel.adjustsFontSizeToFitWidth = YES;
    locationLabel.x = self.nameLabel.x;
    locationLabel.y = CGRectGetMaxY(nameLabel.frame)+padding;
    locationLabel.width = 150 * SCREEN_SCALE_W;
    locationLabel.height = nameLabel.height;
    locationLabel.font = [UIFont systemFontOfSize:15];
    locationLabel.text = @"江苏省苏州市的访客";
    self.locationLabel = locationLabel;
    locationLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:locationLabel];
    
    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.adjustsFontSizeToFitWidth = YES;
    timeLabel.width = 120*SCREEN_SCALE_W;
    timeLabel.height = 50*SCREEN_SCALE_H;
    timeLabel.x = SCREEN_W - padding - timeLabel.width;
    timeLabel.y = 2 * padding;
    timeLabel.font = [UIFont systemFontOfSize:15];
    timeLabel.text = @"3-15 12:06";
    timeLabel.textColor = [UIColor grayColor];
    timeLabel.textAlignment = NSTextAlignmentRight;
    self.timeLabel = timeLabel;
    [self.contentView addSubview:timeLabel];
    
    UIButton *newMsgBtn = [[UIButton alloc]init];
    newMsgBtn.y = nameLabel.y;
    newMsgBtn.width = 10;
    newMsgBtn.height = newMsgBtn.width;
    newMsgBtn.x = CGRectGetMaxX(timeLabel.frame)-10;
    [newMsgBtn setBackgroundImage:[UIImage imageNamed:@"home_btn_tishi"] forState:UIControlStateNormal];
    [self.contentView addSubview:newMsgBtn];
    self.msgBtn = newMsgBtn;
}
-(void)setVistorModel:(VistorModel *)vistorModel
{
    _vistorModel = vistorModel;
    self.nameLabel.text = vistorModel.name;
    self.locationLabel.text = vistorModel.country;
  //---
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:vistorModel.time];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"MM-dd HH:mm:ss"];
//    NSLog(@"time:%@",[dateFormatter stringFromDate:date]);
    //--
//    self.timeLabel.text = [dateFormatter stringFromDate:date];
    self.timeLabel.text = [self transformTime:vistorModel.time];
    
    NSString *imgUrl = [NSString stringWithFormat:@"%@%@",rootUrl,vistorModel.img];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"icon_moren-tx"]];
    
    if (vistorModel.isHaveNewMsg) {
        self.msgBtn.hidden = NO;
    }else{
        self.msgBtn.hidden = YES;
    }
}
-(NSString *)transformTime:(NSInteger)addtime
{
    
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:addtime];
    //    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    
    
    //    NSDate *createDate = [dateFormatter dateFromString:date];
    //
    //    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    //    return [fmt stringFromDate:createDate];
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents *cmps = [calendar components:unit fromDate:createDate toDate:now options:0];
    NSDateComponents *dateCmps = [calendar components:unit fromDate:createDate];
    NSDateComponents *nowCmps = [calendar components:unit fromDate:now];
    if (nowCmps.year == dateCmps.year) {//今年
        if (nowCmps.day==(dateCmps.day + 1)) {//昨天
            fmt.dateFormat = @"昨天 HH:mm";
            return [fmt stringFromDate:createDate];
        }else if (nowCmps.day == dateCmps.day){//今天
            if (cmps.hour >= 1) {
                return [NSString stringWithFormat:@"%ld小时前",(long)cmps.hour];
            }else if(cmps.minute >1){
                return [NSString stringWithFormat:@"%ld分钟前",(long)cmps.minute];
            }else{
                return @"刚刚";
            }
        }else{//今年的其他日子
            fmt.dateFormat =@"MM-dd HH:mm";
            return [fmt stringFromDate:createDate];
        }
    }else{//非今年
        fmt.dateFormat = @"yyyy-MM-dd HH:mm";
        return [fmt stringFromDate:createDate];
    }
}
@end
